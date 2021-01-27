package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "Alexa::ASK::Skill"
	is_string(resource.Properties.AuthenticationConfiguration.RefreshToken) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AuthenticationConfiguration.RefreshToken", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.RefreshToken' is string", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.RefreshToken' is not a string", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "Alexa::ASK::Skill"
	refreshToken := resource.Properties.AuthenticationConfiguration.RefreshToken
	not startswith(refreshToken, "{{resolve:secretsmanager:")
	not startswith(refreshToken, "{{resolve:ssm-secure:")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AuthenticationConfiguration.RefreshToken", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.RefreshToken' starts with '{{resolve:secretsmanager:' or starts with '{{resolve:ssm-secure:'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.RefreshToken' does not start with '{{resolve:secretsmanager:' or with '{{resolve:ssm-secure:'", [name]),
	}
}
