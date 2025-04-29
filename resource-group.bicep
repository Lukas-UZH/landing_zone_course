targetScope = 'subscription'

@description('The location of the resource group to create.')
param location string = 'switzerlandnorth'

param stage string = 'dev'

resource myrg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  location: location
  name: 'rg-course-01-${stage}'
  properties: {}
  tags: {
    stage: stage
    project: 'bicep-training'
    owner: 'lukas'
    'hidden-title': 'my hidden title'
  }
}

resource myrg_new 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  location: location
  name: 'rg-course-02-${stage}'
  properties: {}
  tags: {
    stage: stage
    project: 'bicep-training'
    owner: 'lukas'
    'hidden-title': 'my hidden title02'
  }
}
