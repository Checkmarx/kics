resource roleDef 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: 'roleDef'
  properties: {
    roleName: 'my-custom-role'
    description: 'This is a custom role'
    permissions: [
      {
        actions: ['*']
      }
    ]
    assignableScopes: [subscription().id]
  }
}
