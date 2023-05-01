# Unit 1: Basic operations: Create, modify, and destroy resources

|Feature|Syntax|Notes|
|---|---|---|
|Resources|`resource sa 'Microsoft.Storage/storageAccounts@2022-09-01' = { ... }`||
|Dependent resources|`serverFarmId: appServicePlan.id`|Requires using a reference to another resource.|
|Child resources|   |Can be defined within the parent or outside it as a separate resource.|
|Preview with what-if|`az deployment group what-if --template-file main.bicep`||
|Single line comments|`// This is a comment`| |
|Multiline comments|`/* This comment can span multiple lines */`||
|Existing resources|`resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' existing = { ... }`|Resources can exist in a different rg.|

## Task 1.1: Create storage account resource

- Check out https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep. There exists for each resource type a similar definition.
- Go to https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/3-define-resources and copy the first resource template you see on the page (a storage account).
- Go back to the Cloud Shell and paste the template into `main.bicep`.
- Change the name of the storage account into something unique, for example `workshopstorage[yourname]`, where you replace `[yourname]` with your initials or full name, for example. We'll learn later how to make a resource name unique automatically.
- Transpile the bicep into ARM using `bicep build main.bicep`.
- Note: You can ignore the warning. We'll learn how to use variables later!
- Note: Transpiling the file manually is not required when deploying Bicep. We do it here just to show what happens under the hood every time you deploy.
- View the new file with `cat main.json`.
- As mentioned, we don't need the json file, so delete it with `rm main.json`.
- Deploy the resource with `az deployment group create --template-file main.bicep`.
- Note: If you didn't set the default rg earlier, you need to include the `--resource-group` switch with the rg name. The same applies to all later deployment commands.
- Check the deployed resources in portal, with `az storage account list --output table` or otherwise.
- To view the deployment `az deployment group list --output table`.

## Task 1.2: Modify the resource

- Change the symbolic name of the resource from `storageAccount` to `sa`. This is a common naming convention for storage accounts.
- Try deploying the same template again without any other changes. What happens?
- On your local machine create a text file `sample.txt` using Notepad or similar editor.
- In Azure portal, navigate to the storage account and create a blob container, and upload the local file to the container.
- Change the replication of the storage account from LRS to GRS. Hint: You need to change a value under `sku`. It's easy to guess how to change the value, but you can use the resource definition article linked above to check possible values.
- Preview deployment with `az deployment group what-if --template-file main.bicep`.
- If the changes look ok, run the deployment, using the same command as in Task 1.1.
- If there were files in that storage account when you change the replication from LRS to GRS, would those files be affected?

## Task 1.3: Add comments and delete a resource

- Apply comments to a resource. You can use `//` for one line at a time or comment out a whole block with `/* */`. Try adding, for example `// To be changed!` at the end of the `location` line. Deploy or run what-if. What happens? Change the comment so that it works.
- Note: If you're familiar with programming languages like Java or C#, it's easy to remember the comments work the same way.
- Change the location of the storage account to `westeurope`. Deploy again or run what-if. What happens?
- Comment out the resource definition. In other words, put `/* */` around the whole code block that defines the storage account. If you now deploy the template, does the resource get deleted?
- Read this article https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-modes. What is needed to actually delete a resource that is not in the template (or is commented out)?
- After successfully deleting the resources, remove the comments and re-deploy the template with all resources.
- Change the location into something else than `westeurope` and re-reploy using the same mode as above. Does it work?
- Change the location back to `westeurope`.

## Task 1.4: Add dependent resources

This task involves creating a resource that is dependent on another.

- Add to `main.bicep` an app service plan and app using the templates in https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/3-define-resources.
- Observe the syntax. How does one of the resources reference the other?
- Change the `name` of each new resource to `appla-xyz344n` and `app-xyz123213`, respectively.
- Change the symbolic names of the two new resources to `xxx` and `yyy`, respectively. Deploy or run what-if. What happens? If any errors occur, fix references so that the code works again and you're able to deploy it.
- Change the locations of both resources to `westeurope` and deploy. What happens?
- Change the names of the resources to `xxx` and `yyy`, respectively, and change the locations of both resources to `westeurope`. After these changes, deploy. What happens?
- Add a file share to the storage account using the same mechanism as the app service plan and app above. You can use the following code:
```
resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-04-01' = {
  name: '${sa.name}/default/fileshare'
}
```

## Task 1.5: Use a child resource within a resource

It's possible to define child resources also within the parent resource, which means it's not necessary to use a reference to establish the parent-child relationship.

- Change the file share from a dependent resource defined outside the storage account to a child resource defined within the parent resource. See https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/child-resource-name-type#within-parent-resource.
- If you use a different name for the file share when you change it from an externally defined resource to an internal one, the older one is not automatically deleted, so you must use the complete mode or otherwise delete it.

## Task 1.6: Work with existing resources

Sometimes, it's necessary to refer to existing resources outside the scope of your deployment. You might, for example, use a secret from an key vault that is in its own resource group.

- See https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/existing-resource for syntax examples.
- Add a key vault to the template using the `existing` syntax. The key vault's name is `kv-shared` and it's in the `rg-keyvault` resource group. In other words, you need to use the right value for `scope` to target the correct key vault.
- Hint: The sample code in the above article uses a resource group as a scope, but the resource group is refered to with a variable. Since we haven't introduced variables yet, use a string literal instead, i.e. you need to put the rg's name in single quotes `'like-this'`.
- Note that this task doesn't create or change any resources. Consider this task complete if you can deploy the template with the existing resource without errors.
- You can comment out the key vault definition with `/* */` so it won't generate warnings during deployments. We'll use it again later!

[<<< Previous](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_0.md) [Next >>>](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_2.md)
