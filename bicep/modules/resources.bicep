// Define parameters for the deployment
param storageAccountName string
param location string
param keyVaultName string
param storageAccConnStringSecretName string
param appServicePlanName string
param appWebAppName string
param env string
param resourceGroupName string

// Create a storage account
module storageAccountModule 'storage.bicep' = {
  name: 'storageAccountModule'
  params: {
    storageAccountName: storageAccountName
    location: location
    env: env
  }
}

// Create an app service plan & web app
module appServiceModule 'appservice.bicep' = {
  name: 'appServiceModule'
  params: {
    appServicePlanName: appServicePlanName
    location: location
    appWebAppName: appWebAppName
    resourceGroupName: resourceGroupName
  }
  dependsOn: [
    storageAccountModule
  ]
}

// Create a key vault
module keyVaultModule 'keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    keyVaultName: keyVaultName
    location: location
    storageAccountName: storageAccountName
    storageAccConnStringSecretName: storageAccConnStringSecretName
    env: env
    appWebAppName: appWebAppName
  }
  dependsOn: [
    storageAccountModule
    appServiceModule
  ]
}


