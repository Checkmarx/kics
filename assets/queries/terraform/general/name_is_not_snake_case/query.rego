package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# IMPROVED VERSION: Reduces False Positives by considering naming context and legitimate exceptions
CxPolicy[result] {
	doc := input.document[i]
	res_type := doc.resource[type]
	res_type[name]
	not is_snake_case(name)
	
	# Only flag if this resource name should follow snake_case
	should_enforce_snake_case(type, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": type,
		"resourceName": tf_lib.get_resource_name(res_type, name),
		"searchKey": sprintf("resource.%s.%s", [type, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "User-defined resource names should follow snake_case pattern",
		"keyActualValue": sprintf("'%s' is not in snake_case", [name]),
		"searchLine": common_lib.build_search_line(["resource", type, name], []),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	module := doc.module[name]
	not is_snake_case(name)
	
	# Only flag if this module name should follow snake_case
	should_enforce_module_snake_case(name, module)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Local module names should follow snake_case pattern",
		"keyActualValue": sprintf("'%s' is not in snake_case", [name]),
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

# Helper function: Determine if resource name should enforce snake_case
should_enforce_snake_case(resource_type, name) {
	# Flag resources that are clearly user-defined and should follow conventions
	is_user_defined_resource(resource_type)
	
	# But exclude legitimate exceptions
	not is_legitimate_naming_exception(name)
}

# Helper function: Check if resource type is user-defined (not external service names)
is_user_defined_resource(resource_type) {
	# Most AWS resources are user-defined
	startswith(resource_type, "aws_")
	
	# Exclude resources that often have external naming requirements
	not is_external_naming_resource(resource_type)
}

is_user_defined_resource(resource_type) {
	# Google Cloud resources
	startswith(resource_type, "google_")
	not is_external_naming_resource(resource_type)
}

is_user_defined_resource(resource_type) {
	# Azure resources
	startswith(resource_type, "azurerm_")
	not is_external_naming_resource(resource_type)
}

# Helper function: Check if resource type often has external naming requirements
is_external_naming_resource(resource_type) {
	# Resources that often need to match external service conventions
	external_naming_resources := {
		"aws_iam_role_policy_attachment",  # AWS managed policy names
		"aws_iam_policy_attachment",       # AWS managed policy names
		"aws_route53_record",              # DNS names follow different conventions
		"aws_acm_certificate",             # Domain names
		"aws_cloudfront_distribution",     # CDN configurations
		"aws_api_gateway_method",          # HTTP methods
		"aws_lambda_permission",           # AWS service principals
		"google_dns_record_set",           # DNS names
		"azurerm_dns_a_record",           # DNS names
		"kubernetes_namespace",            # K8s naming conventions
		"kubernetes_service_account"       # K8s naming conventions
	}
	resource_type == external_naming_resources[_]
}

# Helper function: Check for legitimate naming exceptions
is_legitimate_naming_exception(name) {
	# Single word names are often acceptable
	is_single_word(name)
}

is_legitimate_naming_exception(name) {
	# Very short names (≤4 chars) are often acceptable
	count(name) <= 4
}

is_legitimate_naming_exception(name) {
	# Common abbreviations that are widely accepted
	common_abbreviations := {
		"vpc", "sg", "lb", "alb", "nlb", "rds", "ec2", "s3", "iam", 
		"acm", "api", "cdn", "dns", "ssl", "tls", "kms", "sns", "sqs"
	}
	lower(name) == common_abbreviations[_]
}

is_legitimate_naming_exception(name) {
	# Names with version identifiers
	re_match(`^[a-z]+v[0-9]+$`, lower(name))
}

# Helper function: Check if name is a single word (all lowercase, no separators)
is_single_word(name) {
	not contains(name, "_")
	not contains(name, "-")
	count(name) <= 12  # Reasonable length for single words
	# Must be all lowercase to be considered a valid single word
	name == lower(name)
}

# Helper function: Determine if module name should enforce snake_case
should_enforce_module_snake_case(name, module) {
	# Only enforce on local modules (not external registry/git/http)
	not is_external_module(module)
	not is_legitimate_naming_exception(name)
}

# Helper function: Check if module is external (git/http, not registry)
is_external_module(module) {
	common_lib.valid_key(module, "source")
	source := module.source
	
	# Git modules
	startswith(source, "git::")
}

is_external_module(module) {
	common_lib.valid_key(module, "source")
	source := module.source
	
	# HTTP modules (not terraform registry)
	startswith(source, "http")
	not contains(source, "terraform-")
}

is_snake_case(path) {
	re_match(`^([a-z][a-z0-9]*)(_[a-z0-9]+)*$`, path)
}
