# MBS

this bash script perform mint, burn and send automatically.<br>
[donations are welcome](https://cyberomanov.tech/WTF_donate), if you find this tool helpful.

## Installation

### One-line

1. Run the commands:
```
apt install bc -y && \
wget -O mbs.sh https://raw.githubusercontent.com/cyberomanov/ironfish-mbs/main/mbs.sh && \
chmod u+x mbs.sh
```
### Step-by-step

1. Install dependencies:
```
apt install bc -y
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
2. Be happy:
```
Creating the transaction: [████████████████████████████████████████] 100% | ETA: 0s

/////////////////// [ MINT | SUCCESS | #1 ] ///////////////////

hash: be04078ffb0d3456988b585610781c2f844de9a9129d4c2ba299de7746969a9d, transaction status: pending.
hash: be04078ffb0d3456988b585610781c2f844de9a9129d4c2ba299de7746969a9d, transaction status: pending.
hash: be04078ffb0d3456988b585610781c2f844de9a9129d4c2ba299de7746969a9d, transaction status: unconfirmed.
hash: be04078ffb0d3456988b585610781c2f844de9a9129d4c2ba299de7746969a9d, transaction status: unconfirmed.
hash: be04078ffb0d3456988b585610781c2f844de9a9129d4c2ba299de7746969a9d, transaction status: confirmed.

Creating the transaction: [████████████████████████████████████████] 100% | ETA: 0s

/////////////////// [ BURN | SUCCESS | #1 ] ///////////////////

hash: 31e195b0cb952f4d02c9a1710204d66e114b0cbbf65a2a9e2940dc4aeb527e36, transaction status: pending.
hash: 31e195b0cb952f4d02c9a1710204d66e114b0cbbf65a2a9e2940dc4aeb527e36, transaction status: pending.
hash: 31e195b0cb952f4d02c9a1710204d66e114b0cbbf65a2a9e2940dc4aeb527e36, transaction status: unconfirmed.
hash: 31e195b0cb952f4d02c9a1710204d66e114b0cbbf65a2a9e2940dc4aeb527e36, transaction status: unconfirmed.
hash: 31e195b0cb952f4d02c9a1710204d66e114b0cbbf65a2a9e2940dc4aeb527e36, transaction status: confirmed.

Creating the transaction: [████████████████████████████████████████] 100% | ETA: 0s

/////////////////// [ SEND | SUCCESS | #1 ] ///////////////////

hash: 1ece69e539d9a4052a41909828f477e35050ea482772b8975df5a471d32bfac4, transaction status: pending.
hash: 1ece69e539d9a4052a41909828f477e35050ea482772b8975df5a471d32bfac4, transaction status: pending.
hash: 1ece69e539d9a4052a41909828f477e35050ea482772b8975df5a471d32bfac4, transaction status: unconfirmed.
hash: 1ece69e539d9a4052a41909828f477e35050ea482772b8975df5a471d32bfac4, transaction status: unconfirmed.
hash: 1ece69e539d9a4052a41909828f477e35050ea482772b8975df5a471d32bfac4, transaction status: confirmed.

with love by @cyberomanov.
```

## Crontab
1. Open crontab editor:

```
crontab -e
```
2. Set one of rules:
> With this settings script will be executed twice a day at 06:10 and 18:10 o'clock and all output will be logged into `~/mbs.log`.
```
10 6,18 * * * bash /root/mbs.sh >> /root/mbs.log
```
> With this settings script will be executed 1 day per week, on Sunday at 14:55 o'clock and all output will be logged into `~/mbs.log`.
```
55 14 * * SUN bash /root/mbs.sh >> /root/mbs.log
```
