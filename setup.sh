# Change these four parameters as needed for your own environment
STORAGE_ACCOUNT_NAME=mystorageaccount$RANDOM
RESOURCE_GROUP=labResourceGroup
LOCATION=eastus
FILE_SHARE_NAME=aksshare

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

kubectl create secret generic azure-secret \
    --from-literal=azurestorageaccountname=$STORAGE_ACCOUNT_NAME \
    --from-literal=azurestorageaccountkey=$STORAGE_KEY
