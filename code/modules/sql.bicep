param location string
@secure()
param sqlAdmin string
@secure()
param sqlPassword string
param productName string

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
