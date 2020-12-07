package Cx

CxPolicy [ result ] {
   
  resource := input.document[i].Resources[name]
  
  not resource.Properties.VersioningConfiguration.Status == "Enabled"  
  
  
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	     sprintf("Resources.%s.Properties.VersioningConfiguration.Status", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "S3 bucket versioning is enabled",
                "keyActualValue": 	"S3 bucket versioning is not enabled"
            }
}



