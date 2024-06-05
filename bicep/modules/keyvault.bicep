param keyVaultName string
param location string
param storageAccountName string
param KeyVaultType string = 'standard'
param storageAccConnStringSecretName string
param env string
param appWebAppName string

resource webAppResource 'Microsoft.Web/sites@2021-01-01' existing = {
  name: appWebAppName
}

// create a new key vault in bicep
resource keyVaultResource 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: KeyVaultType
    }     
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enablePurgeProtection: true
    networkAcls: env == 'temp' ? {
      bypass: 'None'
      defaultAction: 'Allow'
    } : {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    accessPolicies: [
      {
        objectId:  webAppResource.identity.principalId  // This is the objectId of our managed identity
        tenantId: subscription().tenantId
        permissions: {
          secrets: ['get']
        }
      }
    ]
  }
}

resource storageAccountResource 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

module keyVaultSecretsModule 'keyvault_secrets.bicep' = {
  name: 'keyVaultSecretsModule'
  params: {
    keyVaultName: keyVaultName
    storageAccConnStringSecretName: storageAccConnStringSecretName    
    storageAccConnStringSecretValue: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountResource.name};AccountKey=${storageAccountResource.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
   }
  dependsOn: [
    keyVaultResource
  ]
}
