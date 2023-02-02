# MBS

this bash script perform mint, burn and send automatically.<br>
[donations are welcome](https://cyberomanov.tech/WTF_donate), if you find this tool helpful.

## Installation

### One-line

1. Run the commands:
```
apt update && \
apt install bc wget -y && \
wget -O mbs.sh https://raw.githubusercontent.com/cyberomanov/ironfish-mbs/main/mbs.sh && \
chmod u+x mbs.sh
```
### Step-by-step

1. Install dependencies:
```
apt update && apt install bc wget -y
```
2. Download the script:
```
wget -O mbs.sh https://raw.githubusercontent.com/cyberomanov/ironfish-mbs/main/mbs.sh
```
3. Edit script permissions:
```
chmod u+x mbs.sh
```

## Execute

1. Run the script manually:
```
./mbs.sh
```
> You can run `./mbs.sh` without providing an email, that the faucet request will be executed without any email.
```
./mbs.sh "test@gmail.com"
```
> You can run `./mbs.sh "test@gmail.com"` with providing an email, that the faucet request will be executed with an specified email.
2. Be happy:
```
Enter your email to stay updated with Iron Fish: test@gmail.com.

[ 25-01-23 | 22:16:24 ] faucet just added your request to the queue.

Creating the transaction: [████████████████████████████████████████] 100% s

/////////////////// [ MINT [ 3234 ] | SUCCESS | #1 ] ///////////////////

[ 25-01-23 | 22:16:24 ] hash: 49dffa000b75389d578e2857ba3493624cf009abe73a698f58f96586efd2602e, status: pending.
[ 25-01-23 | 22:16:34 ] hash: 49dffa000b75389d578e2857ba3493624cf009abe73a698f58f96586efd2602e, status: pending.
[ 25-01-23 | 22:16:44 ] hash: 49dffa000b75389d578e2857ba3493624cf009abe73a698f58f96586efd2602e, status: unconfirmed.
[ 25-01-23 | 22:16:54 ] hash: 49dffa000b75389d578e2857ba3493624cf009abe73a698f58f96586efd2602e, status: unconfirmed.
[ 25-01-23 | 22:17:04 ] hash: 49dffa000b75389d578e2857ba3493624cf009abe73a698f58f96586efd2602e, status: confirmed.

Creating the transaction: [████████████████████████████████████████] 100% s

/////////////////// [ BURN [ 49% of 3325 = 1617 ] | SUCCESS | #1 ] ///////////////////

[ 25-01-23 | 22:17:14 ] hash: eca1685af2673bf39305937cfb93f69792effaff58f98ea9e4ee7a01b90869ef, status: pending.
[ 25-01-23 | 22:17:24 ] hash: eca1685af2673bf39305937cfb93f69792effaff58f98ea9e4ee7a01b90869ef, status: pending.
[ 25-01-23 | 22:17:34 ] hash: eca1685af2673bf39305937cfb93f69792effaff58f98ea9e4ee7a01b90869ef, status: unconfirmed.
[ 25-01-23 | 22:17:44 ] hash: eca1685af2673bf39305937cfb93f69792effaff58f98ea9e4ee7a01b90869ef, status: unconfirmed.
[ 25-01-23 | 22:17:54 ] hash: eca1685af2673bf39305937cfb93f69792effaff58f98ea9e4ee7a01b90869ef, status: confirmed.

Creating the transaction: [████████████████████████████████████████] 100% s

/////////////////// [ SEND [ 95% of 1708 = 1615 ] | SUCCESS | #1 ] ///////////////////

[ 25-01-23 | 22:18:04 ] hash: b461acfb72a81ecfa7c791f853be8acf8a61c1dc2f50e5acc7136cadfccfa0e4, status: pending.
[ 25-01-23 | 22:18:14 ] hash: b461acfb72a81ecfa7c791f853be8acf8a61c1dc2f50e5acc7136cadfccfa0e4, status: pending.
[ 25-01-23 | 22:18:24 ] hash: b461acfb72a81ecfa7c791f853be8acf8a61c1dc2f50e5acc7136cadfccfa0e4, status: unconfirmed.
[ 25-01-23 | 22:18:34 ] hash: b461acfb72a81ecfa7c791f853be8acf8a61c1dc2f50e5acc7136cadfccfa0e4, status: unconfirmed.
[ 25-01-23 | 22:18:44 ] hash: b461acfb72a81ecfa7c791f853be8acf8a61c1dc2f50e5acc7136cadfccfa0e4, status: confirmed.

assetId: c9b46622e3de4d46aaeda9610a98db8cbcc5e5596a19793f10eb41ae0824c712.

balance of $IRON: 4.99999978.
balance of $cyberomanov: 838.00000000.

with love by @cyberomanov.
```

## Crontab
1. Update crontab:
```
apt update && apt install cron --reinstall
```
2. Open crontab editor:
```
crontab -e
```
3. Set one of rules or create your own. Use [crontab.guru](https://crontab.guru/), if you like one-liners:
> With this settings script will be executed every 4 hours and all output will be logged into `/root/mbs.log`.
> Faucet request will be executed without any email.
```
22 */4 * * * bash /root/mbs.sh >> /root/mbs.log
```
> With this settings script will be executed every 4 hours and all output will be logged into `/root/mbs.log`.
> Faucet request will be executed with an specified email.
```
22 */4 * * * bash /root/mbs.sh "test@gmail.com" >> /root/mbs.log
```
