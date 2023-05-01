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

## Task 2.6: Use a parameter file

Parameter files were mentioned earlier. Let's try using one!

- See https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/4-how-use-parameter-file-with-bicep?pivots=cli for an example of a parameter file.
- In the Cloud Shell, create a new file `main.parameters.json` and copy-paste the example into it.
- The file now has parameters `appServicePlanInstanceCount`, `appServicePlanSku`, and `cosmosDBAccountLocations`. However, currently you only need `productName`, so you can remove the last two parameters from the file and modify the first one so that the parameter's name and value correspond to what is needed.
- Deploy using the parameter file, so the command changes like this: `az deployment group create --template-file main.bicep --parameters main.parameters.json`.
- If you add any new parameters in later exercises that would be useful to insert automatically, update the parameter file.

## Task 2.7: Add a database and secure its secrets

Let's add a SQL db, along with secure parameters. This article https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/6-exercise-create-use-parameter-files?pivots=cli explains some relevant concepts and gives examples. 

- Add two new parameters: `sqlAdmin` and `sqlPassword`. Both are strings.
- Add a description for each parameter.
- Also add the `@secure()` decorator. These two parameters are secrets and therefore need this decorator. Note that you can stack multiple decorators on top of each other, adding a new line for each one.
- Run a what-if. How does the new decorator affect things?
- Now add the SQL server and database. You can use the following template:
```
resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: 'sql-${productName}'
  location: location
  properties: {
    administratorLogin: sqlAdmin
    administratorLoginPassword: sqlPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: 'db-${productName}'
  location: location
  sku: {
    name: 'standard'
    tier: 'standard'
  }
}
```
- Test deployment. Note: The deployment may now take several minutes because of the SQL server.

[<<< Previous](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_1.md) [Next >>>](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_3.md)
