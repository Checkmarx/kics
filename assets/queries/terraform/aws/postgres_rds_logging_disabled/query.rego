package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
    # Case of log_statement and/or log_min_duration_statement undefined
	resource := input.document[i].resource.aws_db_parameter_group[name]
	
    undefined_parameters_message = get_undefined_parameters(resource)
    undefined_parameters_message != "none"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_parameter_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_parameter_group.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_db_parameter_group's log_statement and log_min_duration_statement should be defined",
		"keyActualValue": sprintf("aws_db_parameter_group's %s undefined", [undefined_parameters_message]),
        "searchLine": common_lib.build_search_line(["resource", "aws_db_parameter_group", name], []),
	}
}

CxPolicy[result] {
    # Case of log_statement or log_min_duration_statement with wrong value(s)
	resource := input.document[i].resource.aws_db_parameter_group[name]

    wrong_values_message = get_wrong_values(resource.parameter)
    one_wrong_value(wrong_values_message)
    extra_path = get_extra_path(wrong_values_message,resource.parameter)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_parameter_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_parameter_group.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_db_parameter_group's log_statement and log_min_duration_statement should be set to 'all' and '1'",
		"keyActualValue": sprintf("aws_db_parameter_group's %s the wrong value", [wrong_values_message]),
        "searchLine": common_lib.build_search_line(["resource", "aws_db_parameter_group", name, extra_path[0],extra_path[1],extra_path[2]], []),
	}
}

CxPolicy[result] {
    # Case of log_statement and log_min_duration_statement with wrong value(s)
	resource := input.document[i].resource.aws_db_parameter_group[name]

    wrong_values_message = get_wrong_values(resource.parameter)
    wrong_values_message == "both"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_parameter_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_parameter_group.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_db_parameter_group's log_statement and log_min_duration_statement should be set to 'all' and '1'",
		"keyActualValue": "aws_db_parameter_group's log_statement and log_min_duration_statement are not set or both have the wrong value",
        "searchLine": common_lib.build_search_line(["resource", "aws_db_parameter_group", name], []),
	}
}

get_undefined_parameters(resource) = "log_statement and log_min_duration_statement are" {
    not common_lib.valid_key(resource,"parameter")
} else = "log_statement and log_min_duration_statement are" {
    not log_statement_defined(resource.parameter) 
    not log_min_duration_statement_defined(resource.parameter)
} else = "log_statement is" {
    not log_statement_defined(resource.parameter) 
} else = "log_min_duration_statement is" {
    not log_min_duration_statement_defined(resource.parameter)
} else = "none"

log_statement_defined(parameters) {
    parameters[_].name == "log_statement"
}

log_min_duration_statement_defined(parameters) {
    parameters[_].name == "log_min_duration_statement"
}

get_wrong_values(parameters) = "both"{
    # Case of both values wrong
    parameters[i1].name == "log_statement"
    parameters[i1].value != "all"
    parameters[i2].name == "log_min_duration_statement"
    parameters[i2].value != "1"
} else = "log_statement has" {
    parameters[i1].name == "log_statement"
    parameters[i1].value != "all"
} else = "log_min_duration_statement has" {
    parameters[i2].name == "log_min_duration_statement"
    parameters[i2].value != "1"
} else = "none"


get_extra_path(statement,parameters) = path {
    parameters[index].name == split(statement," ")[0]
    path = ["parameter", index , "value"]
}

one_wrong_value(wrong_values_message) = true {
    wrong_values_message != "none"
    wrong_values_message != "both"
} else = false


