package Cx

secret_env_patterns := {
	"password", "passwd", "pwd", "secret", "api_key", "apikey",
	"token", "private_key", "auth_key", "access_key", "secret_key",
	"encryption_key", "db_pass", "database_password", "app_secret"
}

# Legacy form: ENV key value (two separate tokens)
CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "env"
	count(resource.Value) >= 2

	env_key := lower(resource.Value[0])
	env_val := resource.Value[1]

	contains(env_key, secret_env_patterns[_])
	env_val != ""
	not startswith(env_val, "$")
	not startswith(env_val, "${")
	not env_val == "changeme"
	not env_val == "placeholder"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ENV '%s' should not contain a hardcoded secret value; use BuildKit secrets or a runtime secrets manager", [resource.Value[0]]),
		"keyActualValue": sprintf("ENV '%s' appears to contain a hardcoded secret value", [resource.Value[0]]),
	}
}

# Modern form: ENV key=value (single token, must split on "=")
CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "env"
	count(resource.Value) == 1

	kv := split(resource.Value[0], "=")
	count(kv) >= 2

	env_key := lower(kv[0])
	env_val := concat("=", array.slice(kv, 1, count(kv)))

	contains(env_key, secret_env_patterns[_])
	env_val != ""
	not startswith(env_val, "$")
	not env_val == "changeme"
	not env_val == "placeholder"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ENV '%s' should not contain a hardcoded secret value; use BuildKit secrets or a runtime secrets manager", [kv[0]]),
		"keyActualValue": sprintf("ENV '%s' appears to contain a hardcoded secret value", [kv[0]]),
	}
}
