package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Lambda::Permission"
	resource.Properties.Action != "lambda:InvokeFunction"

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.Action", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Action' should be lambda:InvokeFunction ", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Action' is not lambda:InvokeFunction", [name]),
	}
}
