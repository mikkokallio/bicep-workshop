# Unit 3: Modular re-use

|Feature|Syntax|Notes|
|---|---|---|
|Module references|`module sa 'modules/sa.bicep' = { ... }`||
|Module outputs|`output appServiceAppName string = appServiceApp.name`|Put this at the end of a module.|

## Task 3.1: Restructuring the project
- Create sub-folder `modules` under the folder where you have `main.bicep`.
- In the new folder, create the following three new files `sa.bicep`, `app.bicep`, and `sql.bicep`.

## Task 3.2: Create a module for the storage account
- Before you start, familiarize yourself with the concept of modules in Bicep: https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/7-group-related-resources-modules
- Also look at examples in https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/8-exercise-refactor-template-modules?pivots=cli.
- Move the storage resource from `main.bicep` to the `sa.bicep`.
- Add parameters for any values that are not defined locally. (Hint: You'll probably need two or three params.)
- Go back to `main.bicep` and add a reference to that module using the syntax given in the above article. Remember to supply values for any parameters the module uses!
- When you add modules to `main.bicep`, you can use as symbolic names the same names you are using in the files without file endings, in other words, storage is `sa`, SQL server is `sql` and App Service is `app`.
- Run what-if to see what gets changed, if anything, then deploy.
- Check deployments in your resource group. What do you notice?

## Task 3.3: Modularize the SQL server

Let's modularize the SQL server and while doing so, also add integration with a Key Vault. This article might also be useful: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/key-vault-parameter?tabs=azure-cli. The key vault should exist in a separate rg, and it should have template deployment enabled with `az keyvault update  --name ExampleVault --enabled-for-template-deployment true`.

- Like with the storage account above, move the SQL server and its database to `sql.bicep`.
- Move also the secure parameters to the module.
- If any parameters the resources need are missing, add them too.
- Add a module definition in `main.bicep`. Again, include all parameters that the module uses.
- Test that syntax is correct with what-if.
- Uncomment the key vault that was added earlier in Task 1.6.
- In the module reference for `sql`, replace the values of `administratorLogin` and `administratorLoginPassword` with `kv.getSecret('sqlAdmin')` and `kv.getSecret('sqlPassword')`, respectively.
- The two parameters added in this task are currently not needed, but you might need them later. So comment them out for now.
- As a reminder: https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/5-how-secure-parameter

## Task 3.4: Modularize the App Service

- You know the drill! Modularize the App Service plan and the app within it. Remember to do the same kind of things you did for the storage account and SQL server.

## Task 3.5: Use a loop to clone resources
- Read about arrays and looping in https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/loops#array-elements.
- Use a similar array loop as in the example, but instead of applying it to a storage accounts, use it to create two or more file shares inside the existing storage account. Make it so that the `sa` module accepts an array as a parameter and deploys one file share for each item in the array.
- Define the parameter's default value in `main.bicep`. Make sure that one of the strings in the array is `files`. (We'll use that in the next exercise.)

## Task 3.6: Mount the file share

Let's mount the file share in the storage account to the App Service app. The following template is a rather convoluted way to achieve this, but in some cases, some trickery is required to make Bicep do what you want.

- In Azure Portal, go to the storage account and insert a text file at the root of file share within that account.
- Read about Bicep outputs in https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/outputs?tabs=azure-powershell.
- In `sa.bicep`, add an output for the whole storage account (i.e. not just its id or some other property.)
- In the `app` module, add the following resource to the app:
```
resource mount 'Microsoft.Web/sites/config@2021-01-15' = {
  name: '${appServiceApp.name}/azurestorageaccounts'
  properties: {
    'files': {
      type: 'AzureFiles'
      shareName: 'files'
      mountPath: '/mounts/folder'
      accountName: storageName      
      accessKey: listKeys(storageAccount.resourceId, storageAccount.apiVersion).keys[0].value
    }
  }
}
```
- Add to the module definition of `app` as well as the module itself a parameter `storageAccount`. It should get its value from the storage account's outputs.
- Also add a parameter for `storageName` if it didn't exist.
- In Azure Portal, open the app and check in **Configuration > Path mappings** that the mount is visible.
- Then navigate to **Development Tools > Console** in the left menu.
- In the shell, go to `C:\mounts\folder\` and check if you can see the file you added.
- Having both the storage account's name and the account itself as parameters seems like a complicated way to do things? Is there a better way?
- The property `shareName` is hard-coded. Try to also parametrize that.

[<<< Previous](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_2.md) [Next >>>](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_4.md)
