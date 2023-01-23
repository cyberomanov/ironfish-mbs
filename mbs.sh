#/usr/bin/bash


function GetRandomMintFunc() {
    RANDOM_MINT=0
    while [ $(echo "${RANDOM_MINT} < 1000" | bc) -eq 1 ]; do
        RANDOM_MINT=$(awk 'BEGIN {
                      # seed
                      srand()
                      print int(1 + rand() * 10000)
                      }')
    done
    echo ${RANDOM_MINT}
}


function GetRandomPercFunc() {
    RANDOM_PERC=0
    while [ $(echo "${RANDOM_PERC} < ${1}" | bc) -eq 1 ] || [ $(echo "${RANDOM_PERC} > ${2}" | bc) -eq 1 ]; do
        RANDOM_PERC=$(awk 'BEGIN {
                      # seed
                      srand()
                      print int(1 + rand() * 100)
                      }')
    done
    echo ${RANDOM_PERC}
}


function WaitTransactionToBeCompleted() {
    HASH=${1}

    START_FROM_ZERO="false"
    TRANSACTION_STATUS="unconfirmed."
    while [[ ${TRANSACTION_STATUS} != "confirmed" ]] && [[ ${TRANSACTION_STATUS} != "expired" ]]; do
        TRANSACTION_STATUS=$(${BIN} wallet:transaction ${HASH} | grep "Status: " | sed "s/Status: //")
        if [[ ${TRANSACTION_STATUS} == "unconfirmed" ]] || [[ ${TRANSACTION_STATUS} == "pending" ]]; then
            echo -e "hash: ${HASH}, status: ${TRANSACTION_STATUS}."
            sleep 20
        elif [[ ${TRANSACTION_STATUS} == "confirmed" ]]; then
            echo -e "hash: ${HASH}, status: ${TRANSACTION_STATUS}.\n"
        elif [[ ${TRANSACTION_STATUS} == "expired" ]]; then
            echo -e "hash: ${HASH}, status: ${TRANSACTION_STATUS}.\n\nthis is not okay, starting from zero.\n"
            START_FROM_ZERO="true"
        else
            START_FROM_ZERO="true"
            echo -e "hash: ${HASH}, status: ${TRANSACTION_STATUS}.\n\nunknown status, ping @cyberomanov. starting from zero.\n"
        fi
    done
}


function GetBalanceFunc() {
    if [[ ${1} == '' ]]; then
        ${BIN} wallet:balance | grep -o "[0-9]\+.[0-9]*" | tail -1
    else
        ${BIN} wallet:balance --assetId=${1} | grep -o "[0-9]\+.[0-9]*" | tail -1
    fi
}


function MintFunc() {
    RANDOM_MINT=$(GetRandomMintFunc)
    RESULT=$(echo "Y" | ${BIN} wallet:mint --name=${GRAFFITI} --metadata=${GRAFFITI}  --amount=${RANDOM_MINT} --fee=0.00000001 | tr -d '\0')
    CheckResultFunc "MINT [ ${RANDOM_MINT} ]" "${RESULT}"
}


function BurnFunc() {
    BALANCE=$(GetBalanceFunc "${IDENTIFIER}")
    RANDOM_PERC=$(GetRandomPercFunc "30" "60")
    let "BURN_AMOUNT = ${BALANCE%.*} / 100 * ${RANDOM_PERC}"
    RESULT=$(echo "Y" | ${BIN} wallet:burn --assetId=${IDENTIFIER} --amount=${BURN_AMOUNT} --fee=0.00000001 | tr -d '\0')
    CheckResultFunc "BURN [ ${RANDOM_PERC}% of ${BALANCE%.*} = ${BURN_AMOUNT} ]" "${RESULT}"
}


function SendFunc() {
    BALANCE=$(GetBalanceFunc "${IDENTIFIER}")
    RANDOM_PERC=$(GetRandomPercFunc "80" "99")
    let "SEND_AMOUNT = ${BALANCE%.*} / 100 * ${RANDOM_PERC}"
    ADDRESS_TO_SEND="dfc2679369551e64e3950e06a88e68466e813c63b100283520045925adbe59ca"
    RESULT=$(echo "Y" | ${BIN} wallet:send --assetId=${IDENTIFIER} --amount=${SEND_AMOUNT} --to=${ADDRESS_TO_SEND} --memo="${GRAFFITI}" --fee=0.00000001 | tr -d '\0')
    CheckResultFunc "SEND [ ${RANDOM_PERC}% of ${BALANCE%.*} = ${SEND_AMOUNT} ]" "${RESULT}"
}


function GetTransactionHashFunc() {
    INPUT=${1}
    HASH=$(echo ${INPUT} | grep -Eo "Transaction Hash: [a-z0-9]*" | sed "s/Transaction Hash: //")
    echo ${HASH}
}


function CheckResultFunc() {
    FUNC_RESULT="fail"

    FUNCTION_NAME=${1}
    FUNCTION_RESULT=${2}

    if [[ ${FUNCTION_RESULT} == *"Transaction Hash"* ]]; then
        FUNC_RESULT="success"
        echo -e "\n/////////////////// [ ${FUNCTION_NAME} | SUCCESS | #${FUNC_TRY} ] ///////////////////\n"
        WaitTransactionToBeCompleted $(GetTransactionHashFunc "${FUNCTION_RESULT}")

        if [[ ${FUNCTION_NAME} == *"MINT"* ]]; then
            IDENTIFIER=$(echo ${RESULT} | grep -Eo "Asset Identifier: [a-z0-9]*" | sed "s/Asset Identifier: //")
        fi
    else
        echo -e "\n/////////////////// [ ${FUNCTION_NAME} | FAIL | #${FUNC_TRY} ] ///////////////////\n"
    fi
}


function FaucetRequestFunc() {
    echo
    if [[ ${1} != '' ]]; then
        FAUCET_RESULT=$(echo -e "${1}\n\n" | ironfish faucet)
        if [[ ${FAUCET_RESULT} == *"Congratulations"* ]]; then
            echo -e "${1}.\n\nfaucet just added your request to the queue.\n"
        else
            echo -e "${1}.\n\nfaucet request failed.\n"
        fi
    else
        FAUCET_RESULT=$(echo -e "\n\n" | ironfish faucet)
        if [[ ${FAUCET_RESULT} == *"Congratulations"* ]]; then
            echo -e "...\n\nfaucet just added your request to the queue.\n"
        else
            echo -e "...\n\nfaucet request failed.\n"
        fi
    fi
}


function GetBinaryFunc() {
    BINARY=$(which ironfish)
    if [[ ${BINARY} == "" ]]; then
        DOCKER_CONTAINER=$(docker ps | grep ironfish | awk '{ print $1 }')
        DOCKER_TEST=$(docker exec -it ${DOCKER_CONTAINER} ironfish)
        if [[ ${DOCKER_TEST} == *"Error"* ]]; then
            echo "i don't know where is your 'ironfish' binary. set it manually."
        else
            BINARY="docker exec -i ${DOCKER_CONTAINER} ironfish"
        fi
    fi
    echo ${BINARY}
}


function TryUntilSuccessLocalFunc() {
    FUNCTION=${1}

    FUNC_RESULT="fail"
    FUNC_TRY=0

    while [[ ${FUNC_RESULT} == "fail" ]] && [[ ${FUNC_TRY} != 100 ]]; do
        FUNC_TRY=$((FUNC_TRY + 1))
        ${FUNCTION}
        sleep 5
    done

    if [[ ${FUNC_TRY} == 10 ]]; then
        START_FROM_ZERO="true"
        echo -e "\n\nthis is not okay, starting from zero.\n"
    fi
}


function TryUntilSuccessMainFunc() {
    FINISHED="false"
    while [[ ${FINISHED} == "false" ]]; do
        if [ $(echo "$(GetBalanceFunc) > 0.00000003" | bc ) -eq 1 ]; then
            TryUntilSuccessLocalFunc "MintFunc"
            if [[ ${START_FROM_ZERO} == "false" ]]; then
                TryUntilSuccessLocalFunc "BurnFunc"
            fi
            if [[ ${START_FROM_ZERO} == "false" ]]; then
                TryUntilSuccessLocalFunc "SendFunc"
            fi
            if [[ ${START_FROM_ZERO} == "false" ]]; then
                echo -e "assetId: ${IDENTIFIER}.\n"
                echo -e "balance of \$IRON: $(GetBalanceFunc).\nbalance of \$${GRAFFITI}: $(GetBalanceFunc "${IDENTIFIER}").\n"
                echo -e "with love by @cyberomanov."
                FINISHED="true"
            fi
        else
            echo -e "not enough balance. minimum required: \$IRON 0.00000003, but you have only: \$IRON $(GetBalanceFunc).\n\nif it's a bug, try in a few minutes.\n"
            break
        fi
    done
}


function MainFunc() {
    MAIL=${1}

    BIN=$(GetBinaryFunc)
    GRAFFITI=$(echo $(${BIN} config:get blockGraffiti) | sed 's/\"//g')

    if [[ ${MAIL} != "" ]]; then
        FaucetRequestFunc "${MAIL}"
    else
        FaucetRequestFunc
    fi

    TryUntilSuccessMainFunc
}

MainFunc "${1}"
