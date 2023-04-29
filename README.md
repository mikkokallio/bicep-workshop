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
- See https://learn.microsoft.com/en-us/azure/cloud-shell/features#pre-installed-tools for a list of tools that the Cloud Shell has pre-installed.

## Task 0.3: Create resource group

If working in a shared subscription, it's important that each participant has a resource group with a unique name. Replace the example with something based on your name, e.g. `rg-workshop-mkallio`.

`az group create --location westeurope --name rg-workshop-alastname`

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
|Child resources|   |   |
|Dependent resources| |
|Preview with what-if|``| |
|Comments|``| |
|Comment blocks||   |

## Task 1.1: Create storage account resource

- Check out [https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks?pivots=deployment-language-bicep](https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep). There exists for each resource type a similar definition.
- Go to https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/3-define-resources and copy the first resource template you see on the page (a storage account).
- Go back to the Cloud Shell and paste the template into `main.bicep`.
- Change the name of the storage account into something unique, for example `workshopstorage[yourname]`, where you replace `[yourname]` with your initials or full name, for example. We'll learn later how to make a resource name unique automatically.
- Transpile the bicep into ARM using `bicep build main.bicep`.
- Note: You can ignore the warning. We'll learn how to use variables later!
- Note: Transpiling the file manually is not required when deploying Bicep. We do it here just to show what happens under the hood every time you deploy.
- View the new file with `cat main.json`.
- Deploy the resource with `az deployment group create --template-file main.bicep`.
- Note: If you didn't set the default rg earlier, you need to include the `--resource-group` switch with the rg name. The same applies to all later deployment commands.
- Check the deployed resources in portal, with `az storage account list --output table` or otherwise.
- To view the deployment `az deployment group list --output table`.

## Task 1.2: Modify the resource

- Change the symbolic name of the resource `storageAccount` to `sa`. This is a common naming convention for storage accounts.
- Try deploying the same template again without any other changes. What happens?
- Add a blob storage under the  subnet to `main.bicep`. Watch out for overlapping address spaces!
- Preview deployment with `az deployment group what-if --template-file main.bicep`.
- If the changes look ok, run the deployment.
- Change the names of all the subnets in some consistent way and re-deploy.

## Task 1.3: Delete a resource

- Apply comments to a resource. You can use // for one line at a time or comment out a whole block with /* */
- Note: If you're familiar with Java, C#, it's easy to remember the comments work the same way.
- Deploy again. What happens?
- Read this article. What is needed to actually delete a resource?
- After figuring out how to delete the resources, remove the comments and re-deploy the resource.
- Change the location into something else than westeurope and re-reploy using the same mode as above. Does it work?
- Change location back to westeurope.

## Task 1.4: Rollback a deployment

https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/rollback-on-error

## Task 1.5: Work with existing resources

az deployment group list --output table

# Unit 2: Refactor code to improve maintainbility

- Model solution for Unit 1: ADD LINK

|Feature|Syntax|Notes|
|---|---|---|
|Variables|``||
|Parameters|   |   |
|Combined strings| |
|Descriptions|`@description('The name of the storage account to deploy.')`<br>`param storageAccountName string`
|Decorators|```@allowed([</br>'nonprod'</br>'prod'<br/>])<br>param environmentType string```|   |

## Task 2.1: Parametrize location

- Familiarize yourself with how variables and parameters work in Bicep: https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/5-add-flexibility-parameters-variables
- Create a string parameter location with the value `westeurope`.
- Everywhere in the code, replace the string "westeurope" with the parameter name.
- Try changing to param location string = 'westus3' and deploy. Use what if. What happens?
- param location string = resourceGroup().location

## Task 2.2: Add descriptions to make the code easier to read
- Add descriptions to your params using the `@description` decorator.
- Make code more readable but also provide guidance during deployment.
- Test deployment to see this.
- Command to view these from CLI?

## Task 2.3: Dependent resources -- add a VM to the vnet

This task involves creating a resource that is dependent on another.
- Create a VM using this template (add link)
- Check that parameters are in place.
- Deploy to check the VM is created in the right subnet.
- Add descriptions where applicable. (From here on, do this every time you add new params, resources, etc.)

## Task 2.3: Add resource name prefix to all names
- Add another string param prefix and give it a value, such as "workshop".
- Use the combined string syntax ${} to automatically insert that value into resource names. For example, a VM's name should after this change be `vm-workshop-01`.

## Task 2.4: Add storage with a unique string in its name
- Add to `main.bicep` a storage account. You can use the template e.g. in this article: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/file#resources
- param storageAccountName string = uniqueString(resourceGroup().id)
- param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
- Make sure your storage account's name uses a unique string. After deployment, check out the resulting resource.
- If you didn't deploy a file share already as a sub-resource, do that now.

## Task 2.5: Add prod/nonprod parameter with @allowed decorator

- Add a parameter for environment type after the previous parameters. Use the @allowed decorator as shown in the table.
- Add a variable ^var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'^
- Now add a second variable (e.g. one that changes VM name?) using the ternary operator and embedding that with the combined string syntax.
- Deploy the template as usual.
- Deploy again adding `--parameters environmentType=nonprod` to the command.

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


- Create a new module for private link/endpoint?

# Unit 4: Using modules from a private registry

- Model solution for Unit 3: ADD LINK

Replace custom modules with ones from the global template library.

# Unit 5: Tips and some advanced ways to optimize templates

## Task x.x.: Convert an arm template to Bicep
- Create e.g. a vnet in Azure
- View the ARM template
- Use command to convert

- TBA

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


# To be checked
- What's this: The configuration value of bicep.use_binary_from_path has been set to 'false'.
- Anatomy of template/module, slide vs article. Symbolic names vs Azure names, etc.
- dependencies: https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/3-define-resources
