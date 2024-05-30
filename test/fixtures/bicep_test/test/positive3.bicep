resource security_contact 'Microsoft.Security/securityContacts@2020-01-01-preview' = {
  name: 'security contact'
  properties: {
    emails: 'sample@email.com'
    phone: '9999999'
    alertNotifications: {
      minimalSeverity: 'High'
    }
    notificationsByRole: {
      state: 'On'
      roles: ['Owner']
    }
  }
}
