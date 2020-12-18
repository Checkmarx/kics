package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::ECS::TaskDefinition"
  contDef := resource.Properties.ContainerDefinitions[_]
  object.get(contDef, "HealthCheck", "not found") == "not found"
  searchkey := createSearchKey(name, contDef)
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    searchkey,
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("'%s.Properties.ContainerDefinitions' contains 'HealthCheck' property",[name]),
                "keyActualValue": 	sprintf("'%s.Properties.ContainerDefinitions' doesn't contain 'HealthCheck' property", [name])
              }
}

createSearchKey(a, b) = search{
	not b.Name.Ref
    search := sprintf("Resources.%s.Properties.ContainerDefinitions.Name=%s", [a, b.Name])
}

createSearchKey(a, b) = search{
	b.Name.Ref
    search := sprintf("Resources.%s.Properties.ContainerDefinitions.Name=%s", [a, b.Name.Ref])
}