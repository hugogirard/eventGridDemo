param location string

@secure()
param adminUsername string

@secure()  
param adminPassword string

var suffix = uniqueString(resourceGroup().id)

module str 'modules/storage/storage.bicep' = {
  name: 'str'
  params: {
    location: location
    suffix: suffix
  }
}

module insight 'modules/appinsight/insight.bicep' = {
  name: 'insight'
  params: {
    location: location
    suffix: suffix
  }
}

module sql 'modules/sql/sql.bicep' = {
  name: 'sql'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername    
  }
}

module function 'modules/function/function.bicep' = {
  name: 'func'
  params: {
    appInsightCnx: insight.outputs.cnxstring
    appInsightKey: insight.outputs.key
    location: location
    sqlCnxString: sql.outputs.sqlCnxString
    strFuncId: str.outputs.strFuncId
    strFuncName: str.outputs.strfuncName
    strFileId: str.outputs.strFileId
    strFileName: str.outputs.strFileName
    suffix: suffix
  }
}

output functionName string = function.outputs.functionName
output functionId string = function.outputs.functionId
output storageId string = str.outputs.strFileId
output storageName string = str.outputs.strFileName
