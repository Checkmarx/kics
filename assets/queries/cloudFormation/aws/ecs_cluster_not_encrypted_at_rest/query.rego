package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {  
	# Case of undefined field(s) during path checking 
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
		"keyExpectedValue": sprintf("Resources.%s.Properties.LaunchTemplateData.BlockDeviceMappings.Ebs.Encrypted should be defined and true", [key]),
		"keyActualValue": sprintf("%s is not defined.", [path.missing_resource]),
		"searchLine": common_lib.build_search_line(path.searchLine,[]),
	}
}

CxPolicy[result] {  
	# Case of "encrypted" defined but set to false
	resource := input.document[i].Resources
	elem := resource[key]
	elem.Type == "AWS::EC2::LaunchTemplate"
	template_data := elem.Properties.LaunchTemplateData
	path := check_valid_path(template_data,key)
	path.value

	cf_lib.isCloudFormationFalse(template_data.BlockDeviceMappings[path.index].Ebs.Encrypted)
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": elem.Type,
		"resourceName": cf_lib.get_resource_name(resource, key), 
		"searchKey": sprintf("Resources.%s.Properties.LaunchTemplateData.BlockDeviceMappings.Ebs.Encrypted", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LaunchTemplateData.BlockDeviceMappings.Ebs.Encrypted should be defined and true", [key]),
		"keyActualValue": "Encrypted is set to false.",
		"searchLine": common_lib.build_search_line(path.searchLine,[]),
	}
}

check_valid_path(template_data,key) = path {
	common_lib.valid_key(template_data.BlockDeviceMappings[i].Ebs,"Encrypted")
	path := {
		"value": true,
		"searchLine": ["Resources",key,"Properties","LaunchTemplateData","BlockDeviceMappings",i,"Ebs","Encrypted"],
		"path_tail": sprintf(".BlockDeviceMappings[%d].Ebs.Encrypted",[i]),
		"index": i
	}
} else = path {
	common_lib.valid_key(template_data.BlockDeviceMappings[i],"Ebs")
	path := {
		"value": false,
		"searchLine": ["Resources",key,"Properties","LaunchTemplateData","BlockDeviceMappings",i,"Ebs"],
		"path_tail": sprintf(".BlockDeviceMappings[%d].Ebs.Encrypted",[i]),
		"missing_resource": "Encrypted"
	}
} else = path {
	common_lib.valid_key(template_data,"BlockDeviceMappings")
	path := {
		"value": false,
		"searchLine": ["Resources",key,"Properties","LaunchTemplateData","BlockDeviceMappings"],
		"path_tail": ".BlockDeviceMappings[x].Ebs",
		"missing_resource": "Ebs"
	}
} else = path {
	path := {
		"value": false,
		"searchLine": ["Resources",key,"Properties","LaunchTemplateData"],
		"path_tail": ".BlockDeviceMappings",
		"missing_resource": "BlockDeviceMappings"
	}
} 


