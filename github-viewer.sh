#!/bin/bash

BASE_DIR=$(pwd)
. "$BASE_DIR/lib.sh"

REQUEST_RESPONSE=$(curl -s -X POST -H "Authorization: Bearer $GITHUB_PAT" -H "content-type: application/json" \
--data "{\"query\":\"query {\n  viewer {\n    login\n    databaseId\n  }\n}\n\"}" \
$GITHUB_GRAPHQL_URL)

# Check the shell return
if [ $? -ne 0 ]; then
  echo "ERROR! Failed to gather data from GitHub!"
  exit 1
fi

# DEBUG show request response
if [ $DEBUG -eq 1 ]; then
  echo "DEBUG --- REQUEST RESPONSE: $REQUEST_RESPONSE"
fi

echo "Username: $(echo $REQUEST_RESPONSE | jq .[] | jq -r '.viewer.login')"
echo "User ID: $(echo $REQUEST_RESPONSE | jq .[] | jq -r '.viewer.databaseId')"
