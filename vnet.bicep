param rgLocation string = resourceGroup().location


resource scusvnet1 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: 'scusvnet1'
  location: rgLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
  }
}

resource scusnsg2spk1 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'scusnsg2spk1'
  location: rgLocation
}

resource scusnsg3spk2 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'scusnsg3spk2'
  location: rgLocation
}

resource scussnet1gw 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  parent: scusvnet1
  name: 'GatewaySubnet'
  properties: {
    addressPrefixes: [
      '10.0.0.0/26'
    ]
  }
}

resource scussnet2spk1 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  parent: scusvnet1
  name: 'scussnet2spk1'
  properties: {
    addressPrefix: '10.0.0.64/26'
    networkSecurityGroup: {
      id: scusnsg2spk1.id
    }
      
  }
}

resource scussnet3spk2 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  parent: scusvnet1
  name: 'scussnet3spk2'
  properties: {
    addressPrefix: '10.0.0.128/26'
    networkSecurityGroup: {
      id: scusnsg3spk2.id 
    }
  }
}
