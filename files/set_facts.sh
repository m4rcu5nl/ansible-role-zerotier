#!/bin/bash
FACTS_DIR='/etc/ansible/facts.d'
FACT_FILE="${FACTS_DIR}/zerotier.fact"
NODE_STATUS=($(zerotier-cli status))
NETWORKS=$(zerotier-cli listnetworks | tail -n+2)

function file_content {
    if [ ! -z "$NETWORKS" ]; then
        network_count=$(echo $NETWORKS |wc -l)
        counter=1

        echo "{"
        echo "  \"node_id\":\"${NODE_STATUS[2]}\","
        echo "  \"networks\": {"
        while read -r; do
            network=($REPLY)
            echo "    \"${network[2]}\": {"
            echo "        \"status\":\"${network[5]}\","
            echo "        \"device\":\"${network[7]}\""

            if [ "$counter" -eq "$network_count" ]; then
                echo "    }"
            else
                echo "    },"
            fi
            ((counter++))
        done <<< $NETWORKS
        echo "  }"
        echo "}"
    else
        echo "{\"node_id\":\"${NODE_STATUS[2]}\",\"networks\":{}}"
    fi
}

if [ ! -d "$FACTS_DIR" ]; then
    mkdir -p $FACTS_DIR
fi

file_content > $FACT_FILE


# TO-DO
# Handle different states than "OK". Other statuses can mess up positions.
