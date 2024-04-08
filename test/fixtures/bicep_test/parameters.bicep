@description('This is a test param with secure declaration.')
@secure()
param projectName string = 'test'

@description('This is a test int param declaration.')
param numberNodes int = 2

@description('This is a test bool param declaration.')
param isNumber bool = true

@description('This is a test middle string param declaration.')
param middleString string = 'teste-${numberNodes}${isNumber}-teste'
