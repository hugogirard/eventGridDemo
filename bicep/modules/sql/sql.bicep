@secure()
param adminUsername string

@secure()  
param adminPassword string

var suffix = uniqueString(resourceGroup().id)
var name = concat('sqlserver-','-',suffix)
var dbname = 'logger'
var location = resourceGroup().location

resource server 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: name
  location: location
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
  }
}

resource database 'Microsoft.Sql/servers/databases@2019-06-01-preview' = {
  name: concat(server.name,'/',dbname)
  dependsOn: [
    server
  ]
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
}

resource firewallAzureIps 'Microsoft.Sql/servers/firewallRules@2020-08-01-preview' = {
  name: '${server.name}/AllowAllWindowsAzureIps'
  dependsOn: [
    server  
  ]
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

output sqlCnxString string = 'Server=tcp:${server.properties.fullyQualifiedDomainName},1433;Initial Catalog=${dbname};Persist Security Info=False;User ID=${adminUsername};Password=${adminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
