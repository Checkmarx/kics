package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::TaskDefinition"
	contDef := resource.Properties.ContainerDefinitions[idx]
	not common_lib.valid_key(contDef, "HealthCheck")

    getkey := cf_lib.createSearchKey(contDef)
    searchkey := sprintf("Resources.%s.Properties.ContainerDefinitions.%v.Name%s", [name,idx,getkey])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
        "searchKey": searchkey,
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ContainerDefinitions' should contain 'HealthCheck' property", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.ContainerDefinitions' doesn't contain 'HealthCheck' property", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "ContainerDefinitions"], [idx, "Name","Ref" ]),
	}
}
