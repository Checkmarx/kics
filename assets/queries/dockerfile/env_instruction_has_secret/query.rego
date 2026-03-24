package Cx

secret_env_patterns := {
	"password", "passwd", "pwd", "secret", "api_key", "apikey",
	"token", "private_key", "auth_key", "access_key", "secret_key",
	"encryption_key", "db_pass", "database_password", "app_secret"
}

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
