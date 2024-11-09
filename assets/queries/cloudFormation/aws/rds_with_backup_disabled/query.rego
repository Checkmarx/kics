package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	to_number(resource.Properties.BackupRetentionPeriod) == 0

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.BackupRetentionPeriod", [cf_lib.getPath(path), name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.BackupRetentionPeriod' should not equal to zero", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.BackupRetentionPeriod' is equal to zero", [name]),
	}
}
