package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[name]
  wget := getWget(resource[_])
  curl := getCurl(resource[_])
  count(curl) > 0
  count(wget) > 0

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM={{%s}}.RUN={{%s}}",[ name, curl[0].Original]),
                "issueType":		"RedundantAttribute",
                "keyExpectedValue": "Exclusively using 'wget' or 'curl'",
                "keyActualValue": 	"Using both 'wget' and 'curl'"
              }
}

getWget(cmd) = wget {
	cmd.Cmd == "run"
    wget := [x | contains(cmd.Value[_], "wget "); x := cmd]
}

getCurl(cmd) = curl {
	cmd.Cmd == "run"
    curl := [x | contains(cmd.Value[_], "curl "); x := cmd]
}

