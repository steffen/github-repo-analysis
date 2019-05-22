#!/bin/bash

BASE_DIR=$(pwd)
. "$BASE_DIR/lib.sh"

query='"query":"query ($owner: String!, $name: String!) { \n  repository(owner: $owner, name: $name) {\n    diskUsage\n  }\n }"'
variables="\"variables\":{\"owner\":\"$REPOSITORY_OWNER\",\"name\":\"$REPOSITORY_NAME\"}"

REQUEST_RESPONSE=$(curl -s -X POST \
--url $GITHUB_GRAPHQL_URL \
--header "Authorization: Bearer $GITHUB_PAT" \
--header "content-type: application/json" \
--data "{ $query, $variables }")

# Check the shell return
if [ $? -ne 0 ]; then
  echo "ERROR! Failed to gather data from GitHub!"
  exit 1
fi

# DEBUG show request response
if [ $DEBUG -eq 1 ]; then
  echo "DEBUG --- REQUEST RESPONSE: $REQUEST_RESPONSE"
fi


diskUsage=$(echo $REQUEST_RESPONSE | jq -r '.data.repository.diskUsage')
echo "Disk usage: $(expr $diskUsage / 1024) MiB"
