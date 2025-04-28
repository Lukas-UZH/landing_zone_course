param stage string = 'dev'
param location string = resourceGroup().location

module mystorageAccount 'br/public:avm/res/storage/storage-account:0.19.0' = {
  name: 'mystorageAccountDeployment'
  params: {
    // Required parameters
    name: 'stuzhlmalincontract${stage}'
    // Non-required parameters
    kind: 'BlobStorage'
    location: location
    skuName: 'Standard_LRS'
  }
}
