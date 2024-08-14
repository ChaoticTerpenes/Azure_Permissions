# Azure_Permissions
Place for storing specific policies not configurable by default using the Azure interface. 

## Create a Resource Group Role
- Create a custom role by using the `customRoleDefinition.json` file within the `resource_groups` folder and running the below command:
```bash
az role definition create --role-definition customRoleDefinition.json
```

## Create a Policy
- Using the `policyDefinition.json` file within the `resource_groups` folder and run the below command:
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
- Using the `AzurePermissions.sh` file in the `resource_groups` folder and run the below command:
```bash
AzurePermissions.sh -user [user_email_address]
```