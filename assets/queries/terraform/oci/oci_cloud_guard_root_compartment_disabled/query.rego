package Cx

# RULE 1: Does not exist ningún resource 'oci_cloud_guard_configuration'.
CxPolicy[result] {
	doc := input.document[i]
	_ := doc.provider.oci

	all_cloud_guards := [cg |
		cg := input.document[_].resource.oci_cloud_guard_configuration[_]
	]

	count(all_cloud_guards) == 0

	result := {
		"documentId": doc.id,
		"searchKey": "provider.oci",
		"searchLine": common_lib.build_search_line(["provider", "oci"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Resource 'oci_cloud_guard_configuration' should exist to enable Cloud Guard",
		"keyActualValue": "Resource 'oci_cloud_guard_configuration' is missing",
	}
}

# RULE 2: Cloud Guard Exists, but su 'status' no es 'ENABLED'.
CxPolicy[result] {
	cg := input.document[i].resource.oci_cloud_guard_configuration[cg_name]

	cg.status != "ENABLED"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.oci_cloud_guard_configuration.%s.status", [cg_name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'status' attribute should be 'ENABLED'",
		"keyActualValue": sprintf("'status' attribute is '%s'", [cg.status]),
	}
}

# RULE 3: Cloud Guard Exists y is enabled, but no en el compartimento raíz.
CxPolicy[result] {
	cg := input.document[i].resource.oci_cloud_guard_configuration[cg_name]

	cg.status == "ENABLED"
	not contains(lower(cg.compartment_id), "tenancy")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.oci_cloud_guard_configuration.%s.compartment_id", [cg_name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'compartment_id' should be the tenancy (root compartment) OCID",
		"keyActualValue": "'compartment_id' is not the tenancy OCID",
	}
}