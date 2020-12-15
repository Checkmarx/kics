package Cx

CxPolicy [ result ] {
  document := input.document
  resource = document[i].Resources[name]
  resource.Type == "AWS::Route53::HostedZone"
  
  not check_resources_type(document[i].Resources)
   
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s", [name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s has RecordSet", [name]),
                "keyActualValue": 	sprintf("Resources.%s has not RecordSet", [name])
              }
}

check_resources_type(resource) {
  resource[_].Type == "AWS::Route53::RecordSet"
}