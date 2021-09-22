param clusterName string

resource aks 'Microsoft.ContainerService/managedClusters@2021-07-01' = {
  name: clusterName
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'calico'
    }
    agentPoolProfiles: [
      {
        name: 'default'
        count: 3
      }
    ]
    aadProfile: {
      managed: true
    }
    podIdentityProfile: {
      enabled: true
    }
  }
}
