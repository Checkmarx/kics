package Cx

CxPolicy [ result ] {
   document := input.document
   metadata := document[i].metadata
   kind := document[i].kind
   check_kind(kind)
   
   labels := metadata.labels
   label_name := "k8s-app"
   labels[label_name] == "kubernetes-dashboard"
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey":      sprintf("metadata.name=%s", [metadata.name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.labels[%s] has not kubernetes-dashboard deployed", [metadata.name, label_name]),
                "keyActualValue": 	sprintf("metadata.name=%s.labels[%s] has kubernetes-dashboard deployed", [metadata.name, label_name])
              }
}

CxPolicy [ result ] {
   document := input.document
   metadata := document[i].metadata
   kind := document[i].kind
   check_kind(kind)
   
   rules := document[i].rules[_].resourceNames[_]
   
   contains(rules, "kubernetes-dashboard")
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey":      sprintf("metadata.name=%s.rules", [metadata.name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("None of the metadata.name=%s.rules has kubernetes-dashboard deployed", [metadata.name]),
                "keyActualValue": 	sprintf("One of the metadata.name=%s.rules has kubernetes-dashboard deployed", [metadata.name])
              }
}

CxPolicy [ result ] {
   document := input.document
   metadata := document[i].metadata
   kind := document[i].kind
   check_kind(kind)
   
   roleRef := document[i].roleRef.name
   
   contains(roleRef, "kubernetes-dashboard")
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey":      sprintf("metadata.name=%s.roleRef", [metadata.name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.roleRef has kubernetes-dashboard deployed", [metadata.name]),
                "keyActualValue": 	sprintf("metadata.name=%s.roleRef has kubernetes-dashboard deployed", [metadata.name])
              }
}

check_kind(kind) {
	kind == "Secret"
}

check_kind(kind) {
	kind == "ServiceAccount"
}

check_kind(kind) {
	kind == "Deployment"
}

check_kind(kind) {
	kind == "Service"
}

check_kind(kind) {
	kind == "Role"
}

check_kind(kind) {
	kind == "RoleBinding"
}