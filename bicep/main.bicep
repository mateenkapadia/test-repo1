// Set the target scope for the deployment to 'subscription'
targetScope = 'subscription'
// Define parameters for the deployment
param resourceGroupName string 
param location string = deployment().location
param storageAccountName string
param keyVaultName string
param appServicePlanName string
param appWebAppName string
param storageAccConnStringSecretName string
param env string

//create resource group
resource rgDefaultResource 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

//create other resources
module resourcesModule 'modules/resources.bicep' = {
  name: 'resourcesModule'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rgDefaultResource
  ]
  params:{
    //general params
    env: env
    resourceGroupName:resourceGroupName
    //storage account params
    storageAccountName: storageAccountName
    location: location
    //Keyvault params
    keyVaultName: keyVaultName
    storageAccConnStringSecretName: storageAccConnStringSecretName
    //App Service Plan params
    appServicePlanName: appServicePlanName
    appWebAppName: appWebAppName
  }
}
