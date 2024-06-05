# main.bicep -

This Bicep file deploys a set of Azure resources to the specified subscription.
It creates a resource group, storage account, key vault, and an app service plan with a web app.

**Parameters:**

- resourceGroupName: The name of the resource group to be created.
- location: The location where the resources will be deployed. Defaults to the deployment location.
- storageAccountName: The name of the storage account to be created.
- keyVaultName: The name of the key vault to be created.
- appServicePlanName: The name of the app service plan to be created.
- appWebAppName: The name of the web app to be created.
- storageAccConnStringSecretName: The name of the secret in the key vault to store the storage account connection string.
- env: The environment for the deployment.

**Modules:**

- resourcesModule: Deploys additional resources using the 'resources.bicep' module.

**Resources:**

- rgDefaultResource: Creates the resource group.

**Dependencies:**

- resourcesModule depends on rgDefaultResource.

**Command line to trigger the automation script:**

>az deployment sub create --subscription "e664dba5-4e05-4192-b2c7-f8fcef07f7b1" --name sscmx-deployment --location northeurope --template-file main.bicep --parameters parameters-dev.json --parameters env=temp

# resources.bicep -

This Bicep file is used to deploy various Azure resources for the CBAM project.
It creates a storage account, a key vault, and an app service.

**Parameters:**

- storageAccountName: The name of the storage account to be created.
- location: The Azure region where the resources will be deployed.
- keyVaultName: The name of the key vault to be created.
- storageAccConnStringSecretName: The name of the secret in the key vault that will store the storage account connection string.
- appServicePlanName: The name of the app service plan to be created.
- appWebAppName: The name of the app service to be created.
- env: The environment for the resources (e.g., dev, prod).
- resourceGroupName: The name of the resource group where the resources will be deployed.

**Modules:**

- storageAccountModule: Creates a storage account using the 'storage.bicep' module.

  - Parameters:
    - storageAccountName: The name of the storage account.
    - location: The Azure region where the storage account will be created.
    - env: The environment for the storage account.

- keyVaultModule: Creates a key vault using the 'keyVault.bicep' module.

  - Parameters:
    - keyVaultName: The name of the key vault.
    - location: The Azure region where the key vault will be created.
    - storageAccountName: The name of the storage account.
    - storageAccConnStringSecretName: The name of the secret in the key vault that will store the storage account connection string.
    - env: The environment for the key vault.
  - Dependencies:
    - storageAccountModule: Depends on the storage account module.

- appServiceModule: Creates an app service using the 'appService.bicep' module.
  - Parameters:
    - appServicePlanName: The name of the app service plan.
    - location: The Azure region where the app service will be created.
    - appWebAppName: The name of the app service.
    - resourceGroupName: The name of the resource group.
  - Dependencies:
    - storageAccountModule: Depends on the storage account module.


# storage.bicep

  Creates a storage account resource in Azure.

  **Parameters:**

  - storageAccountName: The name of the storage account.
  - location: The Azure region where the storage account will be created.
  - minimumTlsVersion: The minimum TLS version supported by the storage account. Default is 'TLS1_2'.
  - StorageReplication: The replication type for the storage account. Default is 'Standard_LRS'.
  - StorageKind: The kind of storage account to create. Default is 'StorageV2'.
  - env: The environment in which the storage account is being created.

# keyvault.bicep
 
  This Bicep file creates a key vault and configures its properties.
  It also references an existing storage account and passes its connection string as a secret to the key vault.

  **Parameters:**
  - keyVaultName: The name of the key vault to create.
  - location: The location where the key vault will be deployed.
  - storageAccountName: The name of the existing storage account to reference.
  - KeyVaultType: The type of the key vault. Default value is 'standard'.
  - storageAccConnStringSecretName: The name of the secret that will hold the storage account connection string.
  - env: The environment in which the key vault is being deployed.
  - appWebAppName: The app service name which would be able to access the KeyVault

  **Resources:**
  - keyVaultResource: Creates a new key vault with the specified properties. The access policies determines the get access to the app service
  - storageAccountResource: References an existing storage account.
  - keyVaultSecretsModule: Deploys a module that sets the storage account connection string as a secret in the key vault.

  **Dependencies:**
  - keyVaultResource: Depends on the successful creation of the key vault before deploying the module.

  **Note:** The storage account connection string is constructed using the name and key of the storage account.

# keyvault_secrets.bicep

  This Bicep file defines the deployment of a Key Vault secret in Azure.

**Parameters:**
    - keyVaultName: The name of the existing Key Vault resource.
    - storageAccConnStringSecretName: The name of the secret to be created in the Key Vault.
    - storageAccConnStringSecretValue: The value of the secret to be stored in the Key Vault.

  **Resources:**
    - keyVaultResource: An existing Key Vault resource.
    - secret: A secret resource within the Key Vault, storing the connection string.

  **Note:** The @secure() attribute on the 'storageAccConnStringSecretValue' parameter indicates that the value should be treated as sensitive and encrypted.

# appservice.bicep

  This Bicep code deploys an Azure App Service Plan and an associated Web App.

  **Parameters:**
  - resourceGroupName (string): The name of the resource group where the resources will be deployed.
  - location (string): The Azure region where the resources will be deployed.
  - tier (string): The pricing tier for the App Service Plan. Default value is 'Free'.
  - tiername (string): The name of the pricing tier. Default value is 'F1'.
  - appServicePlanName (string): The name of the App Service Plan.
  - appWebAppName (string): The name of the Web App.

  **Resources:**
  - appServicePlanResource: Deploys an Azure App Service Plan with the specified name, location, and pricing tier.
  - webAppResource: Deploys an Azure Web App with the specified name, location, and associated App Service Plan.

  # parameters-dev.json
  
  **Same for uat and prod**

  The following parameters are used by Bicep scripts to create the resources in Azure
  - resourceGroupName - This is the name of the resource group that will get created
  - storageAccountName - The name of the storage account that will be used by CBAM
  - keyVaultName - The name of the KeyVault that will be used by the application
  - storageAccConnStringSecretName - The name of the secret which will have the connection to the storage account. The Java application should use this secret name to connect to the storage
  - appServicePlanName - The name of app service plan in Azure
  - appWebAppName - The name of the web application in Azure 