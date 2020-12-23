package Cx

CxPolicy [ result ] {
  document := input.document
  resource = document[i].Resources[name]
  resource.Type == "AWS::Batch::JobDefinition"
  properties := resource.Properties
  properties.ContainerProperties.Privileged == true  
  
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties.ContainerProperties.Privileged", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.ContainerProperties.Privileged is false", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.ContainerProperties.Privileged is true", [name])
              }
}
