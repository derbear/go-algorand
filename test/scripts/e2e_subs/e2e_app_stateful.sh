#!/bin/bash

date '+keyreg-teal-test start %Y%m%d_%H%M%S'

set -e
set -x
set -o pipefail
export SHELLOPTS

WALLET=$1

# Directory of this bash program
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

gcmd="goal -w ${WALLET}"

ACCOUNT=$(${gcmd} account list|awk '{ print $3 }')

# Succeed in creating app that approves transactions with arg[0] == 'hello'
APPID=$(${gcmd} app create --creator ${ACCOUNT} --approval-prog ${DIR}/tealprogs/argcheck.teal --global-byteslices 0 --global-ints 0 --local-byteslices 1 --local-ints 0 --app-arg-b64 "aGVsbG8=" --clear-prog <(echo 'int 1') | grep Created | awk '{ print $6 }')

# Application call with no args should fail
EXPERROR='rejected by ApprovalProgram'
RES=$(${gcmd} app call --app-id $APPID --from $ACCOUNT || true)
if [[ $RES != *"${EXPERROR}"* ]]; then
    date '+app-create-test FAIL call with no args should fail %Y%m%d_%H%M%S'
fi

# Application call with arg0 == "write" should fail before we opt in
RES=$(${gcmd} app call --app-id $APPID --app-arg-b64 "d3JpdGU=" --from $ACCOUNT || true)
EXPERROR='not opted in'
if [[ $RES != *"${EXPERROR}"* ]]; then
    date '+app-create-test FAIL writing state should fail if account has not opted in %Y%m%d_%H%M%S'
fi

# Should succeed to opt in with first arg hello
${gcmd} app optin --app-id $APPID --from $ACCOUNT --app-arg-b64 "aGVsbG8="

# Write should now succeed
${gcmd} app call --app-id $APPID --app-arg-b64 "d3JpdGU=" --from $ACCOUNT

# Check should now succeed with value "bar"
${gcmd} app call --app-id $APPID --app-arg-b64 "Y2hlY2s=" --app-arg-b64 "YmFy" --from $ACCOUNT

# Should succeed to close out with first arg hello
${gcmd} app closeout --app-id $APPID --from $ACCOUNT --app-arg-b64 "aGVsbG8="

# Write/opt in in one tx should succeed
${gcmd} app optin --app-id $APPID --from $ACCOUNT --app-arg-b64 "d3JpdGU="

# Check should still succeed
${gcmd} app call --app-id $APPID --app-arg-b64 "Y2hlY2s=" --app-arg-b64 "YmFy" --from $ACCOUNT

# Delete application should still succeed
${gcmd} app delete --app-id $APPID --app-arg-b64 "aGVsbG8=" --from $ACCOUNT

# Check should fail since we can't find program to execute
RES=$(${gcmd} app call --app-id $APPID --app-arg-b64 "Y2hlY2s=" --app-arg-b64 "YmFy" --from $ACCOUNT || true)
EXPERROR='only clearing out is supported'
if [[ $RES != *"${EXPERROR}"* ]]; then
    date '+app-create-test FAIL app call should fail if app has been deleted %Y%m%d_%H%M%S'
fi

# Clear should still succeed with arbitrary args
${gcmd} app clear --app-id $APPID --app-arg-b64 "YXNkZg==" --from $ACCOUNT
