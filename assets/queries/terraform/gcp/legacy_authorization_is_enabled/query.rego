package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.google_container_cluster[primary]
  resource.enable_legacy_abac == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_container_cluster[%s].enable_legacy_abac", [primary]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'enable_legacy_abac' is false",
                "keyActualValue": 	"Attribute 'enable_legacy_abac' is true"
              }
}