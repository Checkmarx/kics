package Cx

CxPolicy [ result ] {
  resource := input.document[i]
  readVerbs := [ "get", "watch", "list" ]

  resource.kind == "Role"
  resource.rules[_].resources[_] == "secrets"

  some j,k
  resource.rules[_].verbs[j] == readVerbs[k]

  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.rules.verbs", [resource.metadata.name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": "Roles should not be allowed to send read verbs to 'secrets' resources",
    "keyActualValue": sprintf("Roles should not be allowed to send read verbs to 'secrets' resources, verbs found: [%v]", [concat(", ", resource.rules[_].verbs)])
  }
}

CxPolicy [ result ] {
  resource := input.document[i]
  readVerbs := [ "get", "watch", "list" ]

  resource.kind == "ClusterRole"
  resource.rules[_].resources[_] == "secrets"

  some j,k
  resource.rules[_].verbs[j] == readVerbs[k]

  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.rules.verbs", [resource.metadata.name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": "ClusterRoles should not be allowed to send read verbs to 'secrets' resources",
    "keyActualValue": sprintf("ClusterRoles should not be allowed to send read verbs to 'secrets' resources, verbs found: [%v]", [concat(", ", resource.rules[_].verbs)])
  }
}
