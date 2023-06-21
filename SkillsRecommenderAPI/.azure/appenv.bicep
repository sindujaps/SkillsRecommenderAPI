// Create Azure Container App Environment
@description('Name of the Container App Environment')
param name string

@description('Provide a location for the Container App Environment.')
param location string

@description('Provide the id for the log analytics workspace.d')
param logAnalyticsId string

// Managed container environment
resource environment 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: name
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: reference(logAnalyticsId, '2022-10-01').customerId
        sharedKey: listKeys(logAnalyticsId, '2022-10-01').primarySharedKey
      }
    }
  }
}

output appEnvironmentId string = environment.id
