#!/usr/bin/env bash

SSH_PRIV_KEY_LOCATION="$1"
ANSIBLE_PLAYBOOK_USER="$2"
IP_ADDRESS="$3"
ANSIBLE_RELAYOR_PLAYBOOK_PATH="$4"

export ANSIBLE_HOST_KEY_CHECKING="False"

for _ in $(seq 1 40); do
    ssh -o BatchMode=yes \
        -o ConnectTimeout=3 \
        -o StrictHostKeyChecking=no \
        -i "${SSH_PRIV_KEY_LOCATION}" \
        "${ANSIBLE_PLAYBOOK_USER}"@"${IP_ADDRESS}" \
        'echo "SSH OK"'
    if [ $? == 0 ]; then
        break
    else
        sleep 5
    fi
done

ansible-playbook \
    --user "${ANSIBLE_PLAYBOOK_USER}" \
    --private-key "${SSH_PRIV_KEY_LOCATION}" \
    --inventory "${IP_ADDRESS}," \
    "${ANSIBLE_RELAYOR_PLAYBOOK_PATH}"

exit $?
