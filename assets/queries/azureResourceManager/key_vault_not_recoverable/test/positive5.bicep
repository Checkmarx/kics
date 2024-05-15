param vaults_pgs_bot_prod_name int = 5

resource vaults_pgs_bot_prod_name_resource 'Microsoft.KeyVault/vaults@2016-10-01' = {
  name: vaults_pgs_bot_prod_name
  location: 'westeurope'
  tags: {
    ProjectCodeBU: 'UKMUMD'
    ApplicationName: 'PGS HR Chatbot'
    ProjectCodePGDS: 'PRJ0024896'
    CostCentreBU: 'UKMUMD'
    DataClassification: 'General'
    BusinessUnit: 'PGS'
    Owner: 'Pru UK Andover Innovation Team'
    Contact: 'andover2@prudential.co.uk'
    CostCentrePGDS: 'ITBUEXP'
    Criticality: 'Low'
  }
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: 'aa42167d-6f8d-45ce-b655-d245ef97da66'
    accessPolicies: [
      {
        tenantId: 'aa42167d-6f8d-45ce-b655-d245ef97da66'
        objectId: 'f3e7baf5-8d66-4fb2-b7aa-7b7484309df6'
        permissions: {
          keys: [
            'Get'
            'Create'
            'Delete'
            'List'
            'Update'
            'Import'
            'Backup'
            'Restore'
            'Recover'
          ]
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
            'Backup'
            'Restore'
            'Recover'
          ]
          certificates: [
            'Get'
            'Delete'
            'List'
            'Create'
            'Import'
            'Update'
            'DeleteIssuers'
            'GetIssuers'
            'ListIssuers'
            'ManageContacts'
            'ManageIssuers'
            'SetIssuers'
          ]
          storage: [
            'delete'
            'deletesas'
            'get'
            'getsas'
            'list'
            'listsas'
            'regeneratekey'
            'set'
            'setsas'
            'update'
          ]
        }
      }
      {
        tenantId: 'aa42167d-6f8d-45ce-b655-d245ef97da66'
        objectId: '1033a977-ffdc-4359-869a-b673d075f128'
        permissions: {
          keys: []
          secrets: [
            'Get'
          ]
          certificates: []
          storage: []
        }
      }
      {
        tenantId: 'aa42167d-6f8d-45ce-b655-d245ef97da66'
        objectId: '13be5d2d-6e1f-4667-add4-02d2d1142ac5'
        permissions: {
          keys: []
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
            'Backup'
            'Restore'
            'Recover'
            'Purge'
          ]
          certificates: []
          storage: []
        }
      }
      {
        tenantId: 'aa42167d-6f8d-45ce-b655-d245ef97da66'
        objectId: 'e56a2de8-a788-415f-b10f-14bfd3000e1d'
        permissions: {
          keys: [
            'Get'
            'List'
            'Update'
            'Create'
            'Import'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
            'Decrypt'
            'Encrypt'
            'UnwrapKey'
            'WrapKey'
            'Verify'
            'Sign'
            'Purge'
          ]
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
            'Purge'
          ]
          certificates: [
            'Get'
            'List'
            'Update'
            'Create'
            'Import'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
            'ManageContacts'
            'ManageIssuers'
            'GetIssuers'
            'ListIssuers'
            'SetIssuers'
            'DeleteIssuers'
            'Purge'
          ]
        }
      }
    ]
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
  }
}
