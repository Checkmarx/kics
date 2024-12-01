package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties
	billingMode := properties.BillingMode
	not containsBilling(["PROVISIONED", "PAY_PER_REQUEST"], billingMode)

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.BillingMode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.BillingMode should not be 'PROVISIONED' or 'PAY_PER_REQUEST'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.BillingMode is 'PROVISIONED' or 'PAY_PER_REQUEST'", [name]),
	}
}

containsBilling(array, elem) {
	lower(array[_]) == lower(elem)
}
