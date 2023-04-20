# bicep-workshop

# Unit 0: Preparations

## Task 0.1: Check readiness in cloud shell

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

## Task 0.3: Create resource group

If working in a shared subscription, it's important that each participant has a resource group with a unique name. Replace the example with something based on your name, e.g. `rg-workshop-mkallio`.

`az group create --location westeurope --name rg-workshop-alastname`

Note: Normally, it's a good practice to group together resources in resource groups according to their lifecycles: "Resources that live together and die together." However, to keep things simple, we're using a single resource group for all resources. (Later workshops may include using a larger scope.)

Optional: Set the rg as default. `az config set defaults.group=rg-workshop-alastname`.

# Unit 1: Basic operations: Create, modify, and destroy resources

## Task 1.1: Create network

- Go to https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/scenarios-virtual-networks.
- Check out also https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks?pivots=deployment-language-bicep
- Read about why it's better to create subnets within the vnet definition and not as child resources.
- Copy-paste the first template example on the page into `main.bicep`.
- Transpile the bicep into ARM using `bicep build main.bicep`.
- Note: You can ignore the warning. We'll learn how to use variables later!
- Note: Transpiling the file manually is not required when deploying Bicep. We do it here just to show what happens under the hood every time you deploy.
- View the new file with `cat main.json`.
- Deploy the resource with `az deployment group create --template-file main.bicep`.
- Note: If you didn't set the default rg earlier, you need to include the `--resource-group` switch with the rg name. The same applies to all later deployment commands.
- Check the deployed resources in portal, with `az network vnet list` or otherwise.
- To view the deployment `az deployment group list --output table`.

## Task 1.2: Modify the resource

- First, try deploying the same template again without any changes. What happens?
- Add a third subnet to `main.bicep`. Watch out for overlapping address spaces!
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

## Task 1.3: Add a VM to the vnet

This task involves creating a resource that is dependent on another.

## Task 1.4: Work with existing resources

az deployment group list --output table

# Unit 2: Refactor code to improve maintainbility
## Task 2.1: Parametrize location

- Familiarize yourself with how variables and parameters work in Bicep: https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/5-add-flexibility-parameters-variables
- Create a string parameter location with the value `westeurope`.
- Everywhere in the code, replace the string "westeurope" with the parameter name.
- Try changing to param location string = 'westus3' and deploy. Use what if. What happens?
- param location string = resourceGroup().location

## Task 2.2: Add resource name prefix to all names
- Add another string param prefix and give it a value, such as "workshop".
- Use the combined string syntax ${} to automatically insert that value into resource names. For example, a VM's name should after this change be `vm-workshop-01`.

## Task 2.2: Add storage with a unique string in its name
- Add to `main.bicep` a storage account. You can use the template e.g. in this article: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/file#resources
- param storageAccountName string = uniqueString(resourceGroup().id)
- param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
- Make sure your storage account's name uses a unique string. After deployment, check out the resulting resource.
- If you didn't deploy a file share already as a sub-resource, do that now.

# Unit 3: Modularizing

# Unit 4: Using modules from a private registry
## Allowed param
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

## Conditional statement (ternary operator)

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'



## Convert an arm template to Bicep
- Create e.g. a vnet in Azure
- View the ARM template
- Use command to convert

## 
- Define the parameter as 
https://learn.microsoft.com/en-us/azure/templates/
az configure --defaults group=[sandbox resource group name]
What's this: The configuration value of bicep.use_binary_from_path has been set to 'false'.

- Symbolic names vs Azure names

- dependencies: https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/3-define-resources
- some slide should go over all the concepts like symbolic names.
