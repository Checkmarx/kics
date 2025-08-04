package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {  
	# Case of field not being defined
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::EC2::LaunchTemplate"
	template_data := elem.Properties.LaunchTemplateData
	path := check_valid_path(template_data,key)
	not path.value

    
	result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(resource, key), 
		"searchKey": sprintf("Resources.%s.Properties.LaunchTemplateData%s", [key,path.path_tail]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LaunchTemplateData.BlockDeviceMappings.Ebs.Encrypted should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.LaunchTemplateData%s is not defined.", [key,path.path_tail]),
		"searchLine": common_lib.build_search_line(path.searchLine,[]),
	}
}

CxPolicy[result] {  
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::EC2::LaunchTemplate"
	template_data := elem.Properties.LaunchTemplateData
	path := check_valid_path(template_data,key)
	path.value

	cf_lib.isCloudFormationFalse(template_data.BlockDeviceMappings.Ebs.Encrypted)
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(resource, key), 
		"searchKey": sprintf("Resources.%s.Properties.LaunchTemplateData.BlockDeviceMappings.Ebs.Encrypted", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LaunchTemplateData.BlockDeviceMappings.Ebs.Encrypted should be set to true", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.LaunchTemplateData.BlockDeviceMappings.Ebs.Encrypted is set to false.", [key]),
		"searchLine": common_lib.build_search_line(path.searchLine,[]),
	}
}

check_valid_path(template_data,key) = path {
	common_lib.valid_key(template_data.BlockDeviceMappings[i].Ebs,"Encrypted")
	path := {
		"value": true,
		"searchLine": ["Resources",key,"Properties","LaunchTemplateData","BlockDeviceMappings",i,"Ebs","Encrypted"],
		"path_tail": ".BlockDeviceMappings[%s].Ebs.Encrypted"
	}
} else = path {
	common_lib.valid_key(template_data.BlockDeviceMappings[i],"Ebs")
	path := {
		"value": false,
		"searchLine": ["Resources",key,"Properties","LaunchTemplateData","BlockDeviceMappings",i,"Ebs"],
		"path_tail": ".BlockDeviceMappings.Ebs"
	}
} else = path {
	common_lib.valid_key(template_data,"BlockDeviceMappings")
	path := {
		"value": false,
		"searchLine": ["Resources",key,"Properties","LaunchTemplateData","BlockDeviceMappings"],
		"path_tail": ".BlockDeviceMappings"
	}
} else = path {
	path := {
		"value": false,
		"searchLine": ["Resources",key,"Properties","LaunchTemplateData"],
		"path_tail": ""
	}
} 


