# Change these four parameters as needed for your own environment
export STORAGE_ACCOUNT_NAME=mystorageaccount$RANDOM
export RESOURCE_GROUP=labResourceGroup
export LOCATION=eastus
export FILE_SHARE_NAME=aksshare
export ACR_NAME=$(az acr list --query "[0].name" | tr -d '\n[]"')
export ACR_LOGIN_SERVER=$(az acr list --query "[].loginServer" | tr -d ' \n[]" ')

# Create a resource group
az group create --name $RESOURCE_GROUP --LOCATION $LOCATION

# Create a storage account
az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP -l $LOCATION --sku Standard_LRS

# Export the connection string as an environment variable, this is used when creating the Azure file share
export AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP -o tsv)

# Create the file share
az storage share create -n $FILE_SHARE_NAME --connection-string $AZURE_STORAGE_CONNECTION_STRING

# Get storage account key
STORAGE_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)

# Echo storage account name and key
echo Storage account name: $STORAGE_ACCOUNT_NAME
echo Storage account key: $STORAGE_KEY

sed -i 's/ACR_LOGIN_SERVER/$ACR_LOGIN_SERVER/g' app.yaml
