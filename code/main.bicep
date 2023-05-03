@maxLength(9)
@description('Name of the product used in resource names.')
param productName string = 'prodxyz84'

@description('The target Azure region where the resources are deployed.')
param location string = resourceGroup().location

/*@secure()
param sqlAdmin string*/

/*@secure()
param sqlPassword string*/

@allowed([
  'dev'
  'test'
  'prod'
])
param environmentType string = 'dev'

var storageAccountSkuName = (environmentType != 'dev') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType != 'dev') ? 'P2V3' : 'F1'

@description('Unique name for storage account.')
var storageAccountName = 'sa${productName}${uniqueString(resourceGroup().id)}'

@description('Unique name for App Service.')
var appServiceName = '${productName}-${environmentType}-${uniqueString(resourceGroup().id)}'

module sa 'modules/sa.bicep' = {
  name: 'sa'
  params: {
    location: location
    storageAccountName: storageAccountName
    storageAccountSkuName: storageAccountSkuName
  }
}

module sql 'modules/sql.bicep' = {
  name: 'sql'
  params: {
    location: location
    productName: productName
    sqlAdmin: kv.getSecret('sqlAdmin')
    sqlPassword: kv.getSecret('sqlPassword')
  }
}

module app 'modules/app.bicep' = {
  name: 'app'
  params: {
    location: location
    appServiceName: appServiceName
    appServicePlanSkuName: appServicePlanSkuName
    storageAccount: sa.outputs.sa
    storageName: storageAccountName
  }
}

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: 'kv-workshop-0205'
  scope: resourceGroup('rg-keyvault')
}
