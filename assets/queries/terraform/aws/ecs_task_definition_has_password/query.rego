package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_ecs_task_definition[name]
  resourceDefenition = resource.container_definitions
  resourceJson = json.unmarshal(resourceDefenition)
  env = resourceJson.containerDefinitions[_].environment[_]
  contains(upper(env.name), upper("password"))

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s", [env.name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "'container_definitions.environment.name' dosen't have value password",
                "keyActualValue": 	"'container_definitions.environment.name' has value password"
              }
}

