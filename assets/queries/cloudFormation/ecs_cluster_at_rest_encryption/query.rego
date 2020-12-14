package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources
  elem = resource[key]
  elem.Type == "AWS::ECS::Service"
  clustername = elem.Properties.Cluster
  taskdefinitionkey = elem.Properties.TaskDefinition
  taskDefinition = resource[taskdefinitionkey]
  
  count(taskDefinition.Properties.ContainerDefinitions)>0
  taskDefinition.Properties.Volumes[j].EFSVolumeConfiguration.TransitEncryption == "DISABLED"
  
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s", [key]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": sprintf("Resources.%s.%s.Properties.Volumes[%s].EFSVolumeConfiguration.TransitEncryption should be enabled",[key,taskdefinitionkey,j]),
                "keyActualValue": 	sprintf("Resources.%s.%s.Properties.Volumes[%s].EFSVolumeConfiguration.TransitEncryption is disabled", [key,taskdefinitionkey,j])
              }
}


package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources
  elem = resource[key]
  elem.Type == "AWS::ECS::Service"
  clustername = elem.Properties.Cluster
  taskdefinitionkey = elem.Properties.TaskDefinition
  taskDefinition = resource[taskdefinitionkey]
  
  count(taskDefinition.Properties.ContainerDefinitions)>0
  taskDefinition.Properties.Volumes[j].EFSVolumeConfiguration.TransitEncryption == "DISABLED"
  
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s", [key]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": sprintf("Resources.%s.%s.Properties.Volumes[%s].EFSVolumeConfiguration.TransitEncryption should be enabled",[key,taskdefinitionkey,j]),
                "keyActualValue": 	sprintf("Resources.%s.%s.Properties.Volumes[%s].EFSVolumeConfiguration.TransitEncryption is disabled", [key,taskdefinitionkey,j])
              }
}