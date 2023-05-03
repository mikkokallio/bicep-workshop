param storageAccountName string
param storageAccountSkuName string
param location string

resource sa 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
    resource service 'fileServices' = {
    name: 'default'

    resource share 'shares' = {
      name: 'files'
    }
  }
}

output sa object = sa
