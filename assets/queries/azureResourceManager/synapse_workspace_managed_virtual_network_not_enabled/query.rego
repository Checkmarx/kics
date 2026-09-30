package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Synapse/workspaces"
	res := get_res(doc, value, path)

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": res.sk,
		"issueType": res.it,
		"keyExpectedValue": res.kev,
		"keyActualValue": res.kav,
		"searchLine": res.sl,
	}
}

get_res(doc, value, path) = res {
    not common_lib.valid_key(value.properties, "managedVirtualNetwork")
    
    res := {
        "sk": sprintf("%s.name=%s", [common_lib.concat_path(path), value.name]),
        "it": "MissingAttribute",
        "kev": "resource with type 'Microsoft.Synapse/workspaces' should have 'managedVirtualNetwork' defined and set to 'default'",
        "kav": "resource with type 'Microsoft.Synapse/workspaces' doesn't have 'managedVirtualNetwork' defined",
        "sl": common_lib.build_search_line(path, [])
    }
} else = res {
    [mvn_val, mvn_val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.managedVirtualNetwork)
	mvn_val != "default"

    res := {
        "sk": sprintf("%s.name=%s.properties.managedVirtualNetwork", [common_lib.concat_path(path), value.name]),
        "it": "IncorrectValue",
        "kev": sprintf("resource with type 'Microsoft.Synapse/workspaces' should have 'managedVirtualNetwork' %s set to 'default'", [mvn_val_type]),
        "kav": sprintf("resource with type 'Microsoft.Synapse/workspaces' has 'managedVirtualNetwork' set to '%s'", [mvn_val]),
        "sl": common_lib.build_search_line(path, ["properties", "managedVirtualNetwork"])
    }
}