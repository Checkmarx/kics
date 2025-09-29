package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Improved rule: Only enforces snake_case on user-defined resources 
# and excludes legitimate exceptions

CxPolicy[result] {
	doc := input.document[i]
	res_type := doc.resource[type]
	res_type[name]
	not is_snake_case(name)
	
	# Only enforce on user-defined AWS/GCP/Azure resources
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
	
	# Only enforce on local modules, not external registry modules
	should_enforce_module_snake_case(doc.module[name])

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

# Determine if snake_case should be enforced for this resource
should_enforce_snake_case(resourceType, name) {
	# Only enforce on user-defined AWS/GCP/Azure resources
	is_user_defined_resource(resourceType)
	
	# Exclude resources with external naming requirements
	not has_external_naming_requirements(resourceType)
	
	# Exclude legitimate exceptions
	not is_legitimate_exception(name)
}

# Check if this is a user-defined resource type that should follow snake_case
is_user_defined_resource(resourceType) {
	# AWS resources
	startswith(resourceType, "aws_")
} else {
	# GCP resources
	startswith(resourceType, "google_")
} else {
	# Azure resources
	startswith(resourceType, "azurerm_")
}

# Check if resource type has external naming requirements
has_external_naming_requirements(resourceType) {
	# DNS and certificate resources often have external naming constraints
	dns_resources := {
		"aws_route53_record", "aws_route53_zone", 
		"google_dns_record_set", "google_dns_managed_zone",
		"azurerm_dns_a_record", "azurerm_dns_zone"
	}
	resourceType == dns_resources[_]
} else {
	# Certificate resources
	cert_resources := {
		"aws_acm_certificate", "google_compute_ssl_certificate", 
		"azurerm_key_vault_certificate"
	}
	resourceType == cert_resources[_]
} else {
	# API Gateway and similar resources
	api_resources := {
		"aws_api_gateway_rest_api", "aws_api_gateway_resource",
		"google_cloud_run_service"
	}
	resourceType == api_resources[_]
}

# Check for legitimate naming exceptions
is_legitimate_exception(name) {
	# Short names (4 chars or less) - often abbreviations
	count(name) <= 4
} else {
	# Common abbreviations that are acceptable
	common_abbreviations := {"vpc", "sg", "rds", "iam", "s3", "ec2", "elb", "alb", "nlb"}
	lower(name) == common_abbreviations[_]
} else {
	# Single words up to 10 characters
	count(name) <= 10
	not contains(name, "_")
	not contains(name, "-")
} else {
	# Version identifiers
	contains(name, "v1") 
} else {
	contains(name, "v2")
}

# Check if module snake_case should be enforced
should_enforce_module_snake_case(module) {
	# Only enforce on local modules
	not is_external_module(module)
}

# Check if this is an external module that shouldn't be subject to snake_case
is_external_module(module) {
	common_lib.valid_key(module, "source")
	# Terraform Registry modules
	startswith(module.source, "terraform-aws-modules/")
} else {
	common_lib.valid_key(module, "source")
	# Other registry modules
	contains(module.source, "registry.terraform.io")
} else {
	common_lib.valid_key(module, "source")
	# GitHub modules
	startswith(module.source, "github.com")
} else {
	common_lib.valid_key(module, "source")
	# Git modules
	startswith(module.source, "git::")
}

is_snake_case(path) {
	re_match(`^([a-z][a-z0-9]*)(_[a-z0-9]+)*$`, path)
}
