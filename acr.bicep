param location string = resourceGroup().location
param projectName string = 'acrlmalin'
// param tags 'my-tag'
param adminPrincipalId string = '658cb70c-2f44-4a3f-a650-c4671f65eb00'
param userPrincipalId string = '199c47e3-c60b-4efc-b2de-d8d35d7a4201'

var abbrs = loadJsonContent('abbreviations.json')
var roles = loadJsonContent('azure-roles.json')

// Create container registry
resource registry 'Microsoft.ContainerRegistry/registries@2024-11-01-preview' = {
  name: '${abbrs.containerRegistryRegistries}${uniqueString(projectName)}'
  location: location
  // tags: tags
  sku: {
    name: 'Basic' // Choose a different SKU if needed.
                  // Consider making this a parameter if you need more flexibility.
  }
  properties: {}
}

// Assign the 'AcrPush', 'AcrDelete', and 'AcrPull' roles to the admin principal.
resource registryPushAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(registry.id, adminPrincipalId, 'push')
  scope: registry
  properties: {
    principalId: adminPrincipalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roles.AcrPush)
  }
}

resource registryDeleteAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(registry.id, adminPrincipalId, 'delete')
  scope: registry
  properties: {
    principalId: adminPrincipalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roles.AcrDelete)
  }
}

resource registryPullAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(registry.id, adminPrincipalId, 'pull')
  scope: registry
  properties: {
    principalId: adminPrincipalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roles.AcrPull)
  }
}

resource registryPullAssignment2 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(registry.id, adminPrincipalId, 'pull2')
  scope: registry
  properties: {
    principalId: userPrincipalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roles.AcrPull)
  }
}

// // Create a user-assigned managed identity.
// // This identity can be used to pull images from the container registry.
// resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
//   name: '${abbrs.managedIdentityUserAssignedIdentities}cr-${uniqueString(projectName)}'
//   location: location
//   // tags: tags
// }

// // Assign the 'AcrPull' role to the managed identity.
// resource registryPullAssignmentManagedIdentity 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(registry.id, '-pull')
//   scope: registry
//   properties: {
//     principalId: identity.properties.principalId
//     principalType: 'ServicePrincipal'
//     roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roles.AcrPull)
//   }
// }

output registryName string = registry.name
