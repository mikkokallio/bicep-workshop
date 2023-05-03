param location string
param appServiceName string
param appServicePlanSkuName string
param storageName string
param storageAccount object

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: 'plan-${appServiceName}'
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-${appServiceName}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

resource mount 'Microsoft.Web/sites/config@2021-01-15' = {
  name: '${appServiceApp.name}/azurestorageaccounts'
  properties: {
    'files': {
      type: 'AzureFiles'
      shareName: 'files'
      mountPath: '/mounts/folder'
      accountName: storageName      
      accessKey: listKeys(storageAccount.resourceId, storageAccount.apiVersion).keys[0].value
    }
  }
}
