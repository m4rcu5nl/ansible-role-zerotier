#!/bin/bash
FACTS_DIR='/etc/ansible/facts.d'
FACT_FILE="${FACTS_DIR}/zerotier.fact"
NODE_STATUS=($(zerotier-cli status))
NETWORKS=$(zerotier-cli listnetworks | tail -n+2)

function file_content {
    if [ ! -z "$NETWORKS" ]; then
        echo "{"
        echo "  \"node_id\":\"${NODE_STATUS[2]}\","
        echo "  \"networks\": ["
        while read -r; do
            network=($REPLY)
            echo "    {"
            echo "    \"id\":\"${network[2]}\","
            echo "    \"status\":\"${network[5]}\""
            echo "    }"
        done <<< $NETWORKS
        echo "  ]"
        echo "}"
    else
        echo "{\"node_id\":\"${NODE_STATUS[2]}\"}"
    fi
}

if [ ! -d "$FACTS_DIR" ]; then
    mkdir -p $FACTS_DIR
fi

file_content > $FACT_FILE


# TO-DO
# Consider something that hadles JSON better than Bash does
# The above will fail when it runs in to more than 1 network
