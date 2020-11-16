package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_api_gateway_stage[name]
  
  not resource.client_certificate_id
  


  result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("aws_api_gateway_stage[%s].client_certificate_id", [name]),
                "issueType":		    "MissingAttribute",
                "keyExpectedValue": "Attribute 'client_certificate_id' is set",
                "keyActualValue": 	"Attribute 'client_certificate_id' is undefined"
            }
}
