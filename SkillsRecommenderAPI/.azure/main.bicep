targetScope = 'subscription'

// Only certain locations can house an Azure Container App
@allowed([
  'northcentralusstage'
  'westcentralus'
  'eastus'
  'westeurope'
  'jioindiawest'
  'northeurope'
  'canadacentral'
  'eastus2'
  'westus'
])
@description('Provide a location for your resources. Options: westus, northcentralusstage, westcentralus, eastus, westeurope, jioindiawest, northeurope, canadacentral, eastus2')
param location string = 'westus'

@minLength(5)
@maxLength(50)
@description('Provide a group prefix for your resources. Requirements: 5-50 characters, alphanumeric, no special characters, no spaces.')
param groupPrefix string 

@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your resource group. Requirements: 5-50 characters, alphanumeric, no special characters, no spaces.')
param rgName string = groupPrefix

var fullRG_Name = '${groupPrefix}-${rgName}'
var laWorkSpaceName = '${groupPrefix}-loganalyticsworkspace'
var appInsightsName = '${groupPrefix}-appinsights'
var containerAppEnvName = '${groupPrefix}-containerappenvironment'
var containerAppName = '${groupPrefix}-containerapp'
var containerRegistryName = '${groupPrefix}regis'

// Create resource group
module rgModule 'resourcegroup.bicep' = {
  name: fullRG_Name
  params: {
    location: location
    rgName: fullRG_Name
  }
}

module laWorkspaceModule 'loganalytics.bicep' = {
  name: laWorkSpaceName
  dependsOn: [ rgModule ]
  scope: resourceGroup(rgModule.name)
  params: {
    name: laWorkSpaceName
    location: location
  }
}

module appInsightsModule 'insights.bicep' = {
  name: appInsightsName
  dependsOn: [ rgModule, laWorkspaceModule ]
  scope: resourceGroup(rgModule.name)
  params: {
    appInsightsName: appInsightsName
    location: location
    logAnalyticsId: laWorkspaceModule.outputs.logAnalyticsId
  }
}

module containerAppEnvironment 'appenv.bicep' = {
  name: containerAppEnvName
  dependsOn: [ rgModule, laWorkspaceModule ]
  scope: resourceGroup(rgModule.name)
  params: {
    name: containerAppEnvName
    location: location
    logAnalyticsId: laWorkspaceModule.outputs.logAnalyticsId
  }
}

module containerApp 'app.bicep' = {
  name: containerAppName
  dependsOn: [ rgModule, containerAppEnvironment ]
  scope: resourceGroup(rgModule.name)
  params: {
    name: containerAppName
    location: location
    acaName: containerAppName
    acrName: containerRegistryName
    containerAppEnvId: containerAppEnvironment.outputs.appEnvironmentId
  }
}

output rgName string = rgModule.name
