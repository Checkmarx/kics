package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources
  elem := resource[key]
  elem.Type == "AWS::ECS::Service"
  clustername := elem.Properties.Cluster
  taskdefinitionkey := elem.Properties.TaskDefinition
  taskDefinition := resource[taskdefinitionkey]
  
  count(taskDefinition.Properties.ContainerDefinitions)>0
  taskDefinition.Properties.Volumes[j].EFSVolumeConfiguration.TransitEncryption == "DISABLED"
  
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.Volumes",[taskdefinitionkey]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption should be enabled",[taskdefinitionkey,j]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.Volumes[%d].EFSVolumeConfiguration.TransitEncryption is disabled", [taskdefinitionkey,j])
              }
}
