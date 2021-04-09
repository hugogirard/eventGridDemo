param suffix string
param location string

resource workspace 'microsoft.operationalinsights/workspaces@2020-10-01' = {
  name: 'workspace-${suffix}'
  location: location
}

resource appinsight 'microsoft.insights/components@2020-02-02-preview' = {
  name: 'app-insight-${suffix}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspace.id
  }
}


output key string = appinsight.properties.InstrumentationKey
output cnxstring string = appinsight.properties.ConnectionString
