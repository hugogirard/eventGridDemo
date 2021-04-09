param suffix string
param location string

resource filestr 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'str${suffix}'
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  tags: {
    'description' : 'filesstorage'
  }
  properties: {
    isHnsEnabled: true
  }
}

resource containerfile 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${filestr.name}/default/customer'  
}

resource funcstr 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'fnc${suffix}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: {
    'description': 'azurefunction'
  }
}

output strfuncName string = funcstr.name
output strFuncId string = funcstr.id
output strFileName string = filestr.name
output strFileId string = filestr.id
