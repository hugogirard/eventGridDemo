param functionId string
param location string
param strFileId string
param strName string

module events 'modules/eventGrid/event.bicep' = {
  name: 'events'
  params: {
    functionId: functionId
    location: location
    storageId: strFileId
    strName: strName
  }
}
