# Azure_Permissions (*HAS NOT BEEN TESTED*)
The below code is intended to provide a user the ability to create a resource group and read from another existing resource group. This user will only be allowed to delete the resource group that they created and nothing else. 

## Create a Resource Group Role
- Create a custom role by updating the `customRoleDefinition.json` file on line 16 with your Azure SubscriptionId and running the below command:
```bash
az role definition create --role-definition customRoleDefinition.json
```

## Create a Policy
- Using the `policyDefinition.json` file run the below command:
```bash
az policy definition create --name 'AllowResourceGroupDeletionByCreator' --rules 'policyDefinition.json' --params '{
  "userObjectId": {
    "type": "String",
    "metadata": {
      "description": "The object ID of the user",
      "displayName": "User Object ID",
      "strongType": "PrincipalId"
    }
  }
}'
```

## Assinging a User to the Role
- Using the `AzurePermissions.sh` file run the below command:
```bash
AzurePermissions.sh -user [user_email_address]
```

*Note: The AzurePermissions.sh script has been hardcoded to allow read access to a resource group called `ObscureWeb-images` 