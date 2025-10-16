package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	app := resource[resources[m]][name]

	not common_lib.valid_key(app, "site_config")

	result := {
		"documentId": doc.id,
		"resourceType": resources[m],
		"resourceName": tf_lib.get_resource_name(app, name),
		"searchKey": sprintf("%s[%s]", [resources[m], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s[%s].site_config' should be defined and not null", [resources[m], name]),
		"keyActualValue": sprintf("'%s[%s].site_config' is undefined or null", [resources[m], name]),
		"searchLine": common_lib.build_search_line(["resource", resources[m], name], []),
		"remediation": "site_config {\n\t\thttp2_enabled = true\n\t}",
		"remediationType": "addition",
	}
}
