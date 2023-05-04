# Unit 4: Extra exercises

## Task 4.1.: Convert an ARM template to Bicep
- Create a resource in Azure without using Bicep (e.g. through the portal).
- View the resource's ARM (json) template.
- Read about how to convert from json to Bicep: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/decompile?tabs=azure-cli
- Store the json in a file and run the conversion as instructed in the article.
- Clean up the resulting Bicep file. There may be a lot of definitions included.
- Test deploying the resource again with a different name from the template and check if you get an identical resource.

## Task 4.2: Use a parameter file

In Task 2.1, it was mentioned that it's possible to use a parameter file. Let's try using one!

- See https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/4-how-use-parameter-file-with-bicep?pivots=cli for an example of a parameter file.
- In the Cloud Shell, create a new file `main.parameters.json` and copy-paste the example into it.
- The file now has parameters `appServicePlanInstanceCount`, `appServicePlanSku`, and `cosmosDBAccountLocations`. However, the parameters you need are different, for example `productName`. So change and/or remove the existing parameters in the json and use such parameters that are needed in your deployment.
- Deploy using the parameter file, so the command changes like this: `az deployment group create --template-file main.bicep --parameters main.parameters.json`.

## Task 4.3: Using modules from a registry

We won't be deploying from a registry today, but feel free to read about how that works in practice: https://learn.microsoft.com/en-us/training/modules/share-bicep-modules-using-private-registries/6-use-module-from-registry

[<<< Previous](https://github.com/mikkokallio/bicep-workshop/blob/main/docs/unit_3.md) [Next >>>](https://github.com/mikkokallio/bicep-workshop/blob/main/README.md)
