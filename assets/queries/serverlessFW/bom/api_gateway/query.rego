package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

CxPolicy[result] {
	document := input.document[i]
	provider := document.provider
	apiGateway := provider.apiGateway

	accessibility := get_resource_accessibility(apiGateway)

	bom_output = {
		"resource_type": "Serverless Function",
		"resource_name": provider.apiName,
		"resource_accessibility": accessibility.accessibility,
		"resource_encryption": "unknown",
		"resource_vendor": upper(sfw_lib.get_provider_name(document)),
		"resource_category": "API",
	}

	final_bom_output := common_lib.get_bom_output(bom_output, accessibility.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("provider.apiGateway", []),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["provider", "apiGateway"], []),
		"value": json.marshal(final_bom_output),
	}
}

get_resource_accessibility(api) = info {
	policy := get_statement(api.resourcePolicy)
	common_lib.any_principal(policy)
	common_lib.is_allow_effect(policy)
	info := {"accessibility": "public", "policy": policy}
} else = info {
	policy := get_statement(api.resourcePolicy)
	info := {"accessibility": "hasPolicy", "policy": policy}
} else = info {
	info := {"accessibility": "unknown", "policy": ""}
}

get_statement(policy) = st {
	is_object(policy)
	st = policy
} else = st {
	is_array(policy)
	st = policy[_]
}
