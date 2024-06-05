param storageAccountName string
param location string
param minimumTlsVersion string = 'TLS1_2'
param StorageReplication string = 'Standard_LRS'
param StorageKind string = 'StorageV2'
param env string


resource storageAcctResource 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: StorageReplication
  }
  kind: StorageKind
  properties: {
    isHnsEnabled: true
    minimumTlsVersion: minimumTlsVersion
    allowBlobPublicAccess: env == 'temp' ? true : false
    networkAcls: env == 'temp' ? null : {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
  }  
}
