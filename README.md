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
