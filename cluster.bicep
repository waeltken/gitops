param clusterName string
param vmSize string = 'standard_d2s_v3'
param location string  = resourceGroup().location

resource aks 'Microsoft.ContainerService/managedClusters@2021-07-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'calico'
    }
    agentPoolProfiles: [
      {
        name: 'default'
        count: 3
        vmSize: vmSize
        mode: 'System'
      }
    ]
    podIdentityProfile: {
      enabled: true
    }
  }
}
