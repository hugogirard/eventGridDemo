param storageId string
param functionId string
param location string
param strName string

var topicName = '${strName}-${guid(subscription().subscriptionId)}'


resource systemTopic 'Microsoft.EventGrid/systemTopics@2020-10-15-preview' = {
  name: topicName
  location: location
  properties: {
    source: storageId
    topicType: 'Microsoft.Storage.StorageAccounts'
  }
}

resource eventSubs 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2020-10-15-preview' = {
  name: '${topicName}/ToAzureFuncSubs'
  dependsOn: [
    systemTopic
  ]
  properties: {
    destination: {
      properties: {
        resourceId: '${functionId}/functions/ProcessFile'
      }
      endpointType: 'AzureFunction'
    }
    filter: {
      includedEventTypes: [
        'Microsoft.Storage.BlobCreated'
        'Microsoft.Storage.BlobRenamed'
      ]
      enableAdvancedFilteringOnArrays: true
      advancedFilters: [
        {
          values: [
            'containers/customer/'
            'containers/jobs/'
          ]
          operatorType: 'StringContains'
          key: 'Subject'
        }        
      ]
    }
    eventDeliverySchema: 'EventGridSchema'    
  }
}
