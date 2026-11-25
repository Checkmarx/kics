package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	not is_aurora(properties)
	cf_lib.isCloudFormationFalse(properties.MultiAZ)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.MultiAZ", [cf_lib.getPath(path),name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("The RDS DBInstance '%s' should have Multi-Availability Zone enabled", [name]),
		"keyActualValue": sprintf("The RDS DBInstance '%s' has MultiAZ value set to false", [name]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::RDS::DBInstance"
	properties := resource.Properties
	not is_aurora(properties)
	not common_lib.valid_key(properties, "MultiAZ")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path),name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("The RDS DBInstance '%s' should have Multi-Availability Zone enabled", [name]),
		"keyActualValue": sprintf("The RDS DBInstance '%s' MultiAZ property is undefined and by default disabled", [name]),
	}
}

# MultiAZ doesn't apply to Aurora instances, their Availability Zones are managed by the DB cluster
is_aurora(properties) {
	startswith(lower(properties.Engine), "aurora")
} else {
	# DBClusterIdentifier alone doesn't imply Aurora (Multi-AZ DB clusters aren't Aurora clusters),
	# so it is only trusted when the Engine isn't a known non-Aurora engine (e.g. it is a Ref/parameter)
	has_cluster(properties)
	not is_non_aurora_engine(properties)
}

is_non_aurora_engine(properties) {
	non_aurora_engines[lower(properties.Engine)]
}

has_cluster(properties) {
	common_lib.valid_key(properties, "DBClusterIdentifier")
	properties.DBClusterIdentifier != ""
	not is_no_value(properties.DBClusterIdentifier)
}

# the YAML parser resolves '!Ref AWS::NoValue' to a plain string, JSON keeps the {"Ref": ...} object
is_no_value(value) {
	value == "AWS::NoValue"
} else {
	value == {"Ref": "AWS::NoValue"}
}

# Engine valid values for AWS::RDS::DBInstance that are not Aurora
non_aurora_engines := {
	"custom-oracle-ee", "custom-oracle-ee-cdb", "custom-oracle-se2", "custom-oracle-se2-cdb",
	"custom-sqlserver-ee", "custom-sqlserver-se", "custom-sqlserver-web", "custom-sqlserver-dev",
	"db2-ae", "db2-ce", "db2-se", "mariadb", "mysql",
	"oracle-ee", "oracle-ee-cdb", "oracle-se2", "oracle-se2-cdb", "postgres",
	"sqlserver-dev-ee", "sqlserver-ee", "sqlserver-se", "sqlserver-ex", "sqlserver-web",
}
