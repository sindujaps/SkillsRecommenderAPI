@minLength(5)
@maxLength(50)
@description('Provide a name for the log analytics workspace')
param name string

@description('Provide a location for the log analytics workspace.')
param location string

// Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

@description('Output the log analytics id for later use')
output logAnalyticsId string = logAnalyticsWorkspace.id
