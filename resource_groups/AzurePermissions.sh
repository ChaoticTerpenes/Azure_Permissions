#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -user user@example.com"
    exit 1
}

# Parse input arguments
while getopts "user:" opt; do
    case ${opt} in
        user)
            USER_EMAIL=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

# Check if user email is provided
if [ -z "$USER_EMAIL" ]; then
    usage
fi

# Get the user's object ID
USER_OBJECT_ID=$(az ad user show --id $USER_EMAIL --query objectId --output tsv)

if [ -z "$USER_OBJECT_ID" ]; then
    echo "User not found: $USER_EMAIL"
    exit 1
fi

# Define the subscription ID (Replace with your subscription ID)
SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Define the resource group that requires read access
RESOURCE_GROUP="ObscureWeb-images"

# Assign the custom role to the user
az role assignment create --assignee $USER_OBJECT_ID --role "Resource Group Creator and VM Deployer" --scope /subscriptions/$SUBSCRIPTION_ID

# Assign the policy to the user
az policy assignment create --policy 'AllowResourceGroupDeletionByCreator' --params "{
    \"userObjectId\": {
        \"value\": \"$USER_OBJECT_ID\"
    }
}" --scope /subscriptions/$SUBSCRIPTION_ID

# Assign Reader role to the user for the specific resource group
az role assignment create --assignee $USER_OBJECT_ID --role "Reader" --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP

echo "Permissions assigned successfully to $USER_EMAIL"