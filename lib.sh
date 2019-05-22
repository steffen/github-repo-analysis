END_CURSOR='null'

IFS='/' read -ra REPOSITORY <<< "$1"

REPOSITORY_OWNER=${REPOSITORY[0]}
REPOSITORY_NAME=${REPOSITORY[1]}

# Check if `jq` is installed
# Needed for parsing JSON output
CheckJQ()
{
  # See if jq is in the path
  WHICH_JQ=$(which jq)

  # Check the shell return
  if [ $? -ne 0 ]; then
    echo "ERROR: Failed to find 'jq' in the path!"
    echo ""
    echo "See install instructions here:"
    echo "https://stedolan.github.io/jq/download/"
    echo ""
    echo "Once installed, please run this script again."
    exit 1
  fi
}

CheckJQ

if [ -e "$BASE_DIR/.env" ]; then
    . "$BASE_DIR/.env"
else
    echo "ERROR: Please create a '.env' file (by copying '.env.sample')"
    exit 1
fi