@description('Name of the Container App')
param name string

@description('Provide a location for the Container App.')
param location string

@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your Azure Container Registry')
param acrName string

@minLength(5)
@maxLength(50)
@description('Provide a name for your Azure Container App')
param acaName string = 'aca${uniqueString(subscription().id)}'

@description('Provide a tier of your Azure Container Registry.')
param acrSku string = 'Basic'

@description('Default image to deploy to container app')
param containerImage string = 'mcr.microsoft.com/mcr/hello-world:latest'

@description('Port to expose')
param port int = 80

@description('Id for Container App Environment resource')
param containerAppEnvId string

// Container Registry
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: true
  }
}

// Container app
resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: name
  location: location
  properties: {
    managedEnvironmentId: containerAppEnvId
    configuration: {
      ingress: {
        external: true
        targetPort: port
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      registries: [
        {
          server: containerRegistry.name
          username: containerRegistry.properties.loginServer
          passwordSecretRef: 'container-registry-password'
        }
      ]
      secrets: [
        {
          name: 'container-registry-password'
          value: containerRegistry.listCredentials().passwords[0].value
        }
      ]
    }
    template: {
      containers: [
        {
          name: acaName
          image: containerImage
          env: [
            {
              name: 'PORT'
              value: string(port)
            }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1.0Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 2
      }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
output containerAppId string = containerApp.id
output containerRegistryId string = containerRegistry.id
output containerRegistryLoginServer string = containerRegistry.properties.loginServer
