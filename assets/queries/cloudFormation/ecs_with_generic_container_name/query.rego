package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::ECS::TaskDefinition"
  contDef := resource.Properties.ContainerDefinitions[_]
  contDef.Name.Ref == "simple-app"

   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.ContainerDefinitions", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.ContainerDefinitions contains name equals to %s", [name, contDef.Name.Ref]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.ContainerDefinitions contains name equals to simple-app", [name])
              }
}
