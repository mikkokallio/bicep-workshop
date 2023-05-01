# Unit 4: Extra exercises

## Task 4.1.: Convert an ARM template to Bicep
- Create a resource in Azure without using Bicep (e.g. through the portal).
- View the resource's ARM (json) template.
- Read about how to convert from json to Bicep: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/decompile?tabs=azure-cli
- Store the json in a file and run the conversion as instructed in the article.
- Use command to convert

## Task 4.2: Use a parameter file

In Task 2.1, it was mentioned that it's possible to use a parameter file. Let's try using one!

- See https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/4-how-use-parameter-file-with-bicep?pivots=cli for an example of a parameter file.
- In the Cloud Shell, create a new file `main.parameters.json` and copy-paste the example into it.
- The file now has parameters `appServicePlanInstanceCount`, `appServicePlanSku`, and `cosmosDBAccountLocations`. However, currently you only need `productName`, so you can remove the last two parameters from the file and modify the first one so that the parameter's name and value correspond to what is needed.
- Deploy using the parameter file, so the command changes like this: `az deployment group create --template-file main.bicep --parameters main.parameters.json`.
- If you add any new parameters in later exercises that would be useful to insert automatically, update the parameter file.

## Task 4.3: Using modules from a registry

We won't be deploying from a registry today, but feel free to read about how that works in practice: https://learn.microsoft.com/en-us/training/modules/share-bicep-modules-using-private-registries/6-use-module-from-registry

[<<< Previous](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_3.md) [Next >>>](https://github.com/mikkokallio/bicep-workshop/blob/main/README.md)
