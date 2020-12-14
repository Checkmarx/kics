package Cx

CxPolicy [ result ] {
   document := input.document
   resource = document[i].Resources[name]
   resource.Type == "AWS::SageMaker::NotebookInstance"
   
   not check_resources_type(document[i].Resources)
   
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s", [name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s has VPC", [name]),
                "keyActualValue": 	sprintf("Resources.%s has not VPC", [name])
              }
}

check_resources_type(resource) {
   resource[_].Type == "AWS::EC2::VPC"
}