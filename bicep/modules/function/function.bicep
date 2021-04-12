param suffix string
param location string
param appInsightKey string
param appInsightCnx string
param strFuncName string
param strFuncId string
param strFileName string
param strFileId string
param sqlCnxString string


var planName = 'func-plan-${suffix}'

resource appplan 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: planName
  location: location
  properties: {
  }
  sku: {
    Tier: 'Dynamic'
    Name: 'Y1'
  }
}

resource function 'Microsoft.Web/sites@2018-11-01' = {
  name: 'func-${suffix}'
  location: location
  kind: 'functionapp'
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'          
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightCnx
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${strFuncName};AccountKey=${listKeys(strFuncId, '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'FileStr'
          value: 'DefaultEndpointsProtocol=https;AccountName=${strFileName};AccountKey=${listKeys(strFileId, '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'SqlCnxString'
          value: sqlCnxString
        }                      
      ]
    }
    serverFarmId: appplan.id
    clientAffinityEnabled: false
  }
}

output functionName string = function.name
output functionId string = function.id
