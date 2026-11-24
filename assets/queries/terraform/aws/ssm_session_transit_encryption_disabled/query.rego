package Cx

import future.keywords.in

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

is_unevaluated(content) {
	is_string(content)
	startswith(content, "${")
}

# Tokenize the unevaluated object without treating quoted strings or comments
# as structure. Count delimiters to distinguish object members from nested keys.
hcl_tokens(content) = tokens {
	matches := regex.find_all_string_submatch_n(`"(?:\\.|[^"\\])*"|/\*[\s\S]*?\*/|(?://|#)[^\r\n]*|[\p{L}\p{N}_-]+|[^\s]`, content, -1)
	tokens := [token |
		token := matches[_][0]
		not startswith(token, "#")
		not startswith(token, "//")
		not startswith(token, "/*")
	]
}

hcl_depth(tokens, index) = depth {
	prefix := array.slice(tokens, 0, index)
	opens := [token | token := prefix[_]; token in {"{", "[", "("}]
	closes := [token | token := prefix[_]; token in {"}", "]", ")"}]
	depth := count(opens) - count(closes)
}

inputs_closed_before(tokens, start, index) {
	some i
	tokens[i] == "}"
	i > start
	i < index
	hcl_depth(tokens, i) == 2
}

has_kms_key_id(content) {
	prefix := regex.find_n(`^\$\{jsonencode\s*\(\s*`, content, 1)[0]
	tokens := hcl_tokens(trim_prefix(content, prefix))
	tokens[0] == "{"

	some inputs, key
	tokens[inputs] in {"inputs", "\"inputs\""}
	tokens[inputs + 1] in {"=", ":"}
	hcl_depth(tokens, inputs) == 1
	start := inputs + 2
	tokens[start] == "{"

	tokens[key] in {"kmsKeyId", "\"kmsKeyId\""}
	key > start
	tokens[key + 1] in {"=", ":"}
	hcl_depth(tokens, key) == 2
	not inputs_closed_before(tokens, start, key)
	tokens[key + 2] != "null"
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ssm_document[name]

	resource.document_type == "Session"

	not is_unevaluated(resource.content)

	content := common_lib.get_policy(resource.content)
    not common_lib.valid_key(content, "inputs")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ssm_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ssm_document[%s].content", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'inputs' should be defined and not null",
		"keyActualValue": "'inputs' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssm_document", name, "content"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ssm_document[name]

	resource.document_type == "Session"

	not is_unevaluated(resource.content)

	content := common_lib.json_unmarshal(resource.content)
    not common_lib.valid_key(content.inputs, "kmsKeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ssm_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ssm_document[%s].content", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'inputs.kmsKeyId' should be defined and not null",
		"keyActualValue": "'inputs.kmsKeyId' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssm_document", name, "content"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ssm_document[name]

	resource.document_type == "Session"

	is_unevaluated(resource.content)
	not has_kms_key_id(resource.content)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ssm_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ssm_document[%s].content", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'inputs.kmsKeyId' should be defined and not null",
		"keyActualValue": "'inputs.kmsKeyId' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssm_document", name, "content"], []),
	}
}
