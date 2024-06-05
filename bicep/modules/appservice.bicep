param resourceGroupName string
param location string
param tiername string = 'F1'  //S1
param tier string = 'Free' //Standard
param zoneRedundant string = 'false' //'true' //Can you true only if premium or isolated tier
param appServicePlanName string
param appWebAppName string

//Code to enable App Insights
/* resource AppInsightsResource 'Microsoft.Insights/components@2020-02-02' = {
  name:  'AppInsights-${appWebAppName}'
  location: location
  kind: 'web'
  properties: {    
    Application_Type: 'web'
  }    
}
 */

resource appServicePlanResource 'Microsoft.Web/serverfarms@2021-01-01' = {
  name: '${resourceGroupName}-${appServicePlanName}'
  location: location
  kind: 'linux'
  properties:{
    reserved: true
    zoneRedundant: zoneRedundant
  }  
  sku: {
    name: tiername
    tier: tier
  }   
}

resource webAppResource 'Microsoft.Web/sites@2021-01-01' = {
  name: appWebAppName
  location: location
  properties: {
    serverFarmId: appServicePlanResource.id
    httpsOnly: true
    siteConfig: {
      //Add App Insights to the this app
      // appSettings: [
      //   {
      //     name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      //     value: AppInsightsResource.properties.InstrumentationKey
      //   }
      // ]
      javaVersion: '17'
      javaContainer: 'JAVA'
      javaContainerVersion: 'SE'  
      linuxFxVersion: 'JAVA|17-java17'
      ftpsState: 'Disabled'   
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}


/* param scriptFilePath string
param scriptOutputPath string

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2021-01-01' = {
  name: 'createAzureAdApp'
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity': {}
    }
  }
  properties: {
    azCliVersion: '2.26.1'
    scriptContent: '${fileContent(scriptFilePath)}'
    arguments: '-a ${clientAppName}  --output-path ${scriptOutputPath}'
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
    storageAccountSettings: {
      storageAccountName: storageAccountName
      storageAccountKey: listKeys(resourceId('Microsoft.Storage/storageAccounts', storageAccountName), '2019-06-01').keys[0].value
    }
    primaryScriptUri: 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.resources/deploymentScripts/AzureCLI/scripts/prepare_ase.sh'
    supportingScriptUris: [
      'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.resources/deploymentScripts/AzureCLI/scripts/prepare_ase.sh'
    ]
  }
} */
