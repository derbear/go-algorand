#!/usr/bin/env bash

# 1. have an oracle sign a message

# generate the oracle's key
dkeygen > oracle.key
# > UOXY4PHOJMA3AZJPAXB7IFSJ7ZKSD7T6B7BPMNXR5W4A3OQ4QZMHRLMQMI

# compute the ephemeral proxy address
python driver.py oracle --auth UOXY4PHOJMA3AZJPAXB7IFSJ7ZKSD7T6B7BPMNXR5W4A3OQ4QZMHRLMQMI --ofee 40000 --own WO3QIJ6T4DZHBX5PWJH26JLHFSRT7W7M2DJOULPXDTUS6TUX7ZRIO4KDFY > oracle.teal
goal clerk compile oracle.teal -o oracle.tealc -d .
# > V5VDGPLJSTF34MVUPAH34OW536Z76ONAPWMU36FOGWYH6APEQTFXTJC72U

# sign the statement with the key 4160 and bit-value; i.e., (4160 << 32) | 1
echo "4160 * 2^32 + 1" | bc | osign oracle.key oracle.tealc > oracle.sig

# the oracle statement is now usable as a base64-encoded argument to a contract

# 2. have a contract account pay out conditionally based on the signed message

# compute the contract account's key
python driver.py oracle-insurance-event --orcl V5VDGPLJSTF34MVUPAH34OW536Z76ONAPWMU36FOGWYH6APEQTFXTJC72U --rcv1 W6UUUSEAOGLBHT7VFT4H2SDATKKSG6ZBUIJXTZMSLW36YS44FRP5NVAU7U --rcv2 XCIBIN7RT4ZXGBMVAMU3QS6L5EKB7XGROC5EPCNHHYXUIBAA5Q6C5Y7NEU --timeout 30000 --oid 42 --own WO3QIJ6T4DZHBX5PWJH26JLHFSRT7W7M2DJOULPXDTUS6TUX7ZRIO4KDFY --fee 100000 > insurance.teal
goal clerk compile insurance.teal -d .
# > 67RH5O2UL3HU44EJV2S62JC5IIBYGHDW6RMLDCJ2VZNR6JI7RNUVGL6GCI

# place money into the account
goal clerk send --from W6UUUSEAOGLBHT7VFT4H2SDATKKSG6ZBUIJXTZMSLW36YS44FRP5NVAU7U --to 67RH5O2UL3HU44EJV2S62JC5IIBYGHDW6RMLDCJ2VZNR6JI7RNUVGL6GCI --amount 300000 -d .

# pay money out of the account, with the oracle's signature as an argument proving correctness
# create a group transaction where in transaction
# (1) the contract escrow closes to rcv1 based on the oracle's statement,
#     paying the oracle proxy (ofee + minfee), and in transaction
# (2) the proxy pays the oracle owner ofee, with the signature as an argument.
goal clerk send --from-program insurance.teal -c W6UUUSEAOGLBHT7VFT4H2SDATKKSG6ZBUIJXTZMSLW36YS44FRP5NVAU7U --to V5VDGPLJSTF34MVUPAH34OW536Z76ONAPWMU36FOGWYH6APEQTFXTJC72U --amount 140000 --fee 100000 -d . -o payout.tx
goal clerk send --from-program oracle.teal -c WO3QIJ6T4DZHBX5PWJH26JLHFSRT7W7M2DJOULPXDTUS6TUX7ZRIO4KDFY --to WO3QIJ6T4DZHBX5PWJH26JLHFSRT7W7M2DJOULPXDTUS6TUX7ZRIO4KDFY --amount 40000 --argb64 `cat oracle.sig`
