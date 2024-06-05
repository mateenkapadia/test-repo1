param keyVaultName string
param storageAccConnStringSecretName string
@secure()
param storageAccConnStringSecretValue string

resource keyVaultResource 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

// add connection string to key vault
resource secretResource 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVaultResource
  name: storageAccConnStringSecretName
  properties: {
    value: storageAccConnStringSecretValue
  }
}
