package Cx

secret_env_patterns := {
	"password", "passwd", "pwd", "secret", "api_key", "apikey",
	"token", "private_key", "auth_key", "access_key", "secret_key",
	"encryption_key", "db_pass", "database_password", "app_secret"
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "env"

	env_entry := resource.Value[_]
	parts := split(env_entry, "=")
	count(parts) >= 2

	env_key := lower(parts[0])
	env_val := concat("=", array.slice(parts, 1, count(parts)))

	contains(env_key, secret_env_patterns[_])
	env_val != ""
	not startswith(env_val, "$")
	not startswith(env_val, "\${")
	not env_val == "changeme"
	not env_val == "placeholder"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.ENV {{%s}}", [name, parts[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ENV '%s' should not contain a hardcoded secret value; use BuildKit secrets or a runtime secrets manager", [parts[0]]),
		"keyActualValue": sprintf("ENV '%s' appears to contain a hardcoded secret value", [parts[0]]),
	}
}
