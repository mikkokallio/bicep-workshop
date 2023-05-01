# bicep-workshop

# Target architecture

ADD PICTURE HERE

# Unit 0: Preparations

## Task 0.1: Check readiness in cloud shell

- In Azure portal ([portal.azure.com](https://portal.azure.com/)), type `subscriptions` in the search box and open the Subscriptions view.
- Check that you can see `sub-bicep-training-sandbox`.
- Open the cloud shell by clicking the `>_` button.
- If running the cloud shell for the first time in that environment, a storage account is created to store your files.
- Run `az account show --output table`.
- In the output, check which subscription has the `IsDefault` value set as `true`. Before deploying anything it's good to make sure you are using the right environment!
- Change the sandbox to your default with `az account set --subscription "sub-bicep-training-sandbox"`.
- (Optional) Clone this repo in your cloud shell using `git clone` and the string from the **Code** dropdown.

## Task 0.2: Test basic Linux commands

- Create a new folder `mkdir bicep-workshop`.
- Go to the folder `cd bicep-workshop`. (Note: You can use tab for completion.)
- Create an empty file with `touch main.bicep`.
- List folder contents with `ls`.
- Open the file with `nano main.bicep`, enter some text, save with Ctrl+O, and exit with Ctrl+X.
- View file contents with `cat main.bicep`.
- Open the file with `code main.bicep`, enter some text, save with Ctrl+S, and exit with Ctrl+Q.
- View file contents with `cat main.bicep`.
- Run `code .` to open the editor with the file explorer shown on the left.
- See https://learn.microsoft.com/en-us/azure/cloud-shell/using-cloud-shell-editor for more information about the Cloud Shell Editor.
- See https://learn.microsoft.com/en-us/azure/cloud-shell/features#pre-installed-tools for a list of tools that the Cloud Shell has pre-installed.

## Task 0.3: Create resource group (rg)

When working in a shared subscription, it's important that each participant has a resource group with a unique name. Replace the example with something based on your name, e.g. `rg-workshop-mkallio`.

- Run `az group create --location westeurope --name rg-workshop-alastname` to create a resource group.
- Check in portal that the rg got deployed to the right subscription.

Note: Normally, it's a good practice to group together resources in resource groups according to their lifecycles: "Resources that live together and die together." However, to keep things simple, we're using a single resource group for all resources. (Later workshops may include using a larger scope.)

Optional: Set the rg as default. `az config set defaults.group=rg-workshop-alastname`.

## Task 0.4: Check resource providers

Some resource providers are registered by default. Other resource providers are registered automatically when you take certain actions. When you create a resource through the portal, the resource provider is typically registered for you. When you deploy an Azure Resource Manager template or Bicep file, resource providers defined in the template are registered automatically. However, if a resource in the template creates supporting resources that aren't in the template, such as monitoring or security resources, you need to manually register those resource providers.

- In Azure portal, go to `sub-bicep-training-sandbox`.
- For more information, see https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types

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

# Unit 2: Refactor code to improve maintainability

- Model solution for Unit 1: ADD LINK

|Feature|Syntax|Notes|
|---|---|---|
|Variables|`var appServicePlanName = 'plan-productx'`||
|Parameters|`param appServiceAppName string`||
|Combined strings|`'plan-${productName}'` | |
|Unique strings|`uniqueString(resourceGroup().id)`||
|Descriptions|`@description('The name of the storage account to deploy.')`<br>`param storageAccountName string`
|Decorators|```@allowed([</br>'nonprod'</br>'prod'<br/>])<br>param environmentType string```|   |

## Task 2.1: Parametrize location

- Add the line `param productName string` at the top of `main.bicep`. Deploy the template. What happens?
- Deploy again this time using `az deployment group create --template-file main.bicep --parameters productName='productx'`. What changes?
- Familiarize yourself with how variables and parameters work in Bicep: https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/5-add-flexibility-parameters-variables
- Using the same principles as above, create a string parameter `location` with the value `westeurope`. Run what-if, and observe how `location` is treated differently from `productName` because it has a default value.
- Everywhere in the code, replace the string literal `'westeurope'` with the parameter name. Run what-if. There should be no changes.
- Finally, change the line to `param location string = resourceGroup().location`.
The above tasks showed how it's possible to provide parameter values in several different ways: by manually inserting parameter values, giving parameter values as arguments, and using default values. Additionally, it's possible to use a parameter file. Read more about it here: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameter-files

## Task 2.2: Add descriptions to make the code easier to read
- Read about decorators in https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters#decorators and read especially https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters#description to understand how description decorators are used.
- Add a description to the `location` parameter as shown in the article. Write a description that describes what the parameter does. This makes the code more readable and can provide guidance during deployment.
- Add a description also for the `productName` parameter. Run what-if and when you're asked to supply a value for the parameter, type `?`. What do you see?
- You can now give the `productName`, so you don't have to specify it each time you deploy.
- Add descriptions also for resources in your template.
- When adding new parameters, resources, etc. in later parts of the workshop, add descriptions also for them.

## Task 2.3: Use combined strings

In the previous task, we defined a product name parameter. Let's start using it in resource names. Combined strings are a very useful feature to make naming things (and referring to them) easier, and can be used to enforce naming conventions if the user gets to choose only one part of the name.

- If your `productName` is something generic like `'productx'`, change it to something more unique to avoid overlapping names.
- Change the name of your App Service plan to `'plan-${productName}'`.
- Similarly, change the name of the app that uses that plan to include the product name.
- Deploy. Assuming the plan name changes, the template now deploys a new plan, so delete the previous one if necessary.

## Task 2.4: Change storage and app names to unique strings

Some resource types (such as storage accounts) require names that are globally unique, which means that you can't deploy a resource if its name is identical to any resource of the same type, regardless of who deployed it and in what subscription. Using unique strings helps with this limitation.
- Add this: `param storageAccountName string = 'saproductx${uniqueString(resourceGroup().id)}'`.
- Observe the syntax used in that line. It contains both a combined string (see previous task) and a `uniqueString()` function. The function also takes an argument, the rg's id.
- Change the storage account to use the parameter. Deploy.
- Check the resulting resource running `az storage account list --output table` or view the resource in the portal. As before, since your storage account name changed, you now have two accounts unless you ran the command in the complete mode.
- Also make the app service app's name unique in a similar fashion.

**Note:** `uniqueString()` is a function in Bicep. As a concept, this is similar to functions/methods in programming languages. Bicep has dozens of built-in functions that can be used to make the code more flexible and re-usable.
- Browse https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions for a few minutes.

## Task 2.5: Using variables, conditions and more decorators

- In https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/5-add-flexibility-parameters-variables, scroll down to **Selecting SKUs for resources**. Read how the `@allowed` decorator works.
- Add to `main.bicep` the environment type parameter as in the example, except include three allowed values: `dev`, `test`, and `prod`.
- Add also the variables `storageAccountSkuName` and `appServicePlanSkuName` as in the example, except make it so that the `Standard_LRS` and `F1` SKUs are used in a dev environment, otherwise use GRS and P2V3. You may find it useful to use the inequality operator `!=`.
- Change the `name` value under `sku` in both the storage account and app service plan to use the new variables.
- Using combined strings, add the environment type to the resource names of the App Service plan and the app, so that the resulting name could be, for example `plan-prod-projectx` when deploying with `prod` selected.
- Test deploying the template with different values. Running in the complete mode ensures that other versions of the resources are removed.
- Also add a `@maxLength` decorator for the `productName` parameter. Limit the length to 13 characters.
- See also https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/3-exercise-add-parameters-with-decorators?pivots=cli for information on usage.

## Task 2.6: Using a parameter file

Parameter files were mentioned earlier. Let's try using one!

- See https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/4-how-use-parameter-file-with-bicep?pivots=cli for an example of a parameter file.
- In the Cloud Shell, create a new file `main.parameters.json` and copy-paste the example into it.
- The file now has parameters `appServicePlanInstanceCount`, `appServicePlanSku`, and `cosmosDBAccountLocations`. However, currently you only need `productName`, so you can remove the last two parameters from the file and modify the first one so that the parameter's name and value correspond to what is needed.
- Deploy using the parameter file, so the command changes like this: `az deployment group create --template-file main.bicep --parameters main.parameters.json`.
- If you add any new parameters in later exercises that would be useful to insert automatically, update the parameter file.

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
- 
## Task 3.1: Create a module for the storage account
- Create sub-folder `modules` under the folder where you have `main.bicep`.
- In the new folder, create a new file `storage.bicep`.
- Move the storage resource from `main.bicep` to the new file.
- Add parameters for any values that are not defined locally. (Hint: You'll probably need two params.)
- Go back to `main.bicep` and add a reference to that module. Remember to supply values for any parameters the module uses!
- Run what-if to see what gets changed, then deploy.
- Add an output for share's id.

output childAddressPrefix string = VNet1::VNet1_Subnet1.properties.addressPrefix

## Task 3.2: Modularize the vnet
- Make a module from the vnet. Remember to output the vnet, its subnets, or just one subnet so you can reference them in the VM!
- If you output all subnets, note that the type is `array`, not `[]` or `string[]`.
- Consider how the reference to subnet(s) and the id must change in the VM definition.
- Deploy to test the changes.

## Task 3.3.: Modularize the VM
- Make a module from the VM. Include the NIC in the same module because it's essentially part of the same thing.
- Consider how you must again change the reference to the subnet.
- Deploy to test changes.

## Task 3.4: Working with key vault

- As a reminder: https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/5-how-secure-parameter

# Unit 4: Using modules from a private registry

- Model solution for Unit 3: ADD LINK

Replace custom modules with ones from the global template library.

# Unit 5: Extra exercises

## Task 5.1.: Convert an arm template to Bicep
- Create e.g. a vnet in Azure
- View the ARM template
- Use command to convert

## Task 5.2: Use a parameter file

In Task 2.1, it was mentioned that it's possible to use a parameter file. Revisit the article and switch to using a parameter file.

# Clean-up

- When you're done, you can delete the resource group that you used for deploying resources. That removes not only the rg but also any resources.
- Switch subscription back?

# To be added

## Task x.x.: Conditional statement (ternary operator)
`var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'`
`var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'`

## Task x.x: Conditions (boolean & expression)
- TBA

## Task x.x: Loops, i and [item, item2, item3]
- TBA

## Task 1.6: Rollback a deployment

https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/rollback-on-error

## Task 2.3: Add resource name prefix to all names
- Add another string param prefix and give it a value, such as "workshop".
- Use the combined string syntax ${} to automatically insert that value into resource names. For example, a VM's name should after this change be `vm-workshop-01`.

# To be checked
- What's this: The configuration value of bicep.use_binary_from_path has been set to 'false'.
- Anatomy of template/module, slide vs article. Symbolic names vs Azure names, etc.
- dependencies: https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/3-define-resources
