# Unit 3: Modular re-use

- Model solution for Unit 2: ADD LINK

|Feature|Syntax|Notes|
|---|---|---|
|Module outputs|`output appServiceAppName string = appServiceAppName`|Put this at the end of a module.|
|Module references|   |   |
|Child resources|resource::subresource|   |

- Read: https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/7-group-related-resources-modules
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/outputs?tabs=azure-powershell
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/child-resource-name-type
- https://learn.microsoft.com/en-us/training/modules/create-composable-bicep-files-using-modules/2-create-use-bicep-modules?tabs=visualizer

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

## Task 3.2: Modularize the SQL server

Let's modularize the SQL server and while doing so, also add integration with a Key Vault. This article might also be useful: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/key-vault-parameter?tabs=azure-cli. The key vault should exist in a separate rg, and it should have template deployment enabled with `az keyvault update  --name ExampleVault --enabled-for-template-deployment true`.

- Like with the storage account above, move the SQL server and its database to `sql.bicep`.
- Copy also the secure parameters to the module. Do not remove them from `main.bicep` just yet!
- If any parameters the resources need are missing, add them too.
- Add a module definition in `main.bicep`. Again, include all parameters that the module uses.
- Test that syntax is correct with what-if.
- Uncomment the key vault that was added earlier in Task 1.6.
- In the module reference for `sql`, replace the values of `administratorLogin` and `administratorLoginPassword` with `kv.getSecret('sqlAdmin')` and `kv.getSecret('sqlPassword')`, respectively.
- The two parameters added in this task are currently not needed, but you might need them later. So comment them out for now.
- As a reminder: https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/5-how-secure-parameter

## Task 3.3: Modularize the App Service

- TBA

## Task 3.4: Mount the file share

- TBA. Outputs.
- In `sa.bicep`, add an output for share's id.

output childAddressPrefix string = VNet1::VNet1_Subnet1.properties.addressPrefix


[<<< Previous](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_2.md) [Next >>>](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_4.md)
