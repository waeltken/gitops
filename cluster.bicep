param clusterName string
param vmSize string = 'standard_d2s_v3'

resource aks 'Microsoft.ContainerService/managedClusters@2021-07-01' = {
  name: clusterName
  location: resourceGroup().location
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
    aadProfile: {
      managed: false
    }
    podIdentityProfile: {
      enabled: true
    }
  }
}
