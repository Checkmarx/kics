package Cx
{{ range $rule := . }}
{{ if eq $rule.IssueType "IncorrectValue" }} {{ $paths := $rule.ResourcePaths }}
CxPolicy [ result ] {
    resource := input.document[i].{{ $rule.ResourceType }}
    resource.{{ $paths.SearchPath }} == "{{ $rule.ActualValue }}"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("{{ $paths.PathWithVars }}", [{{ $paths.Vars }}]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'{{ $paths.Path }}' is equal '{{ $rule.ExpectedValue }}'",
                "keyActualValue": 	"'{{ $paths.Path }}' is equal '{{ $rule.ActualValue }}'"
              }
}
{{ end }}
{{ end }}
