# Bicep workshop

This is a 1-day workshop to illustrate the fundamental concepts and syntax of Bicep, and to learn how deploy resources with Bicep templates on the command-line.

## Target architecture

ADD PICTURE HERE



## Contents

- [Unit 0: Preparations](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_0.md)
- [Unit 1: Create, modify, and destroy resources](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_1.md)
- [Unit 2: Refactor code to improve maintainability](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_2.md)
- [Unit 3: Modular re-use](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_3.md)
- [Unit 4](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_4.md)
- [Unit 5](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_5.md)


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
