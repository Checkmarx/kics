@description('This is a test var declaration.')
var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'

@description('This is a test var declaration.')
var nicName = 'myVMNic'
