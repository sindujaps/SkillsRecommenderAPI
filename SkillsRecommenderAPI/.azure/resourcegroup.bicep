targetScope = 'subscription'

@description('Provide a location for the resource group.')
param location string

@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your resource group')
param rgName string

resource symbolicname 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}
