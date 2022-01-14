package Cx

CxPolicy[result] {
	document := input.document[i]
	some webAclName
	document.Resources[webAclName].Type == "AWS::WAF::WebACL"
	webAcl := document.Resources[webAclName]

	webAcl.Properties.DefaultAction.Type == "ALLOW"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.DefaultAction.Type", [webAclName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DefaultAction.Type should not be ALLOW", [webAclName]),
		"keyActualValue": sprintf("Resources.%s.Properties.DefaultAction.Type is set to ALLOW", [webAclName]),
	}
}
