package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::ECS::Service"
  properties := resource.Properties

  object.get(properties, "DeploymentConfiguration", "undefined") == "undefined"

   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s.Properties.DeploymentConfiguration is defined", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.DeploymentConfiguration is undefined", [name])
              }
}

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::ECS::Service"
  properties := resource.Properties

  not checkContent(properties.DeploymentConfiguration)

   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.DeploymentConfiguration", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.DeploymentConfiguration has at least 1 task running", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.DeploymentConfiguration must have at least 1 task running", [name])
              }
}

checkContent(deploymentConfiguration) {
	object.get(deploymentConfiguration, "MaximumPercent", "undefined") != "undefined"
}

checkContent(deploymentConfiguration) {
	object.get(deploymentConfiguration, "MinimumHealthyPercent", "undefined") != "undefined"
}

checkContent(deploymentConfiguration) {
	object.get(deploymentConfiguration, "DeploymentCircuitBreaker", "undefined") != "undefined"
}
