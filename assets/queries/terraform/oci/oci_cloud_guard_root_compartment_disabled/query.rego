package Cx

# REGLA 1: No existe ningún recurso 'oci_cloud_guard_configuration'.
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
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Resource 'oci_cloud_guard_configuration' should exist to enable Cloud Guard",
		"keyActualValue": "Resource 'oci_cloud_guard_configuration' is missing",
	}
}

# REGLA 2: Cloud Guard existe, pero su 'status' no es 'ENABLED'.
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

# REGLA 3: Cloud Guard existe y está habilitado, pero no en el compartimento raíz.
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