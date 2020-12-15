package Cx

CxPolicy [ result ] {
  resource := input.document[i].command
  from := splitFrom(resource)
  fromCommand := from[_]
  fromCommand[_].Cmd == "from"
  wget := getWget(fromCommand[_])
  curl := getCurl(fromCommand[_])
  count(curl) > 0
  count(wget) > 0

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM=%s.RUN=%s",[ fromCommand[0].Value[0], curl[0].Value[0]]),
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

splitFrom(cmdList) = sliceCmdList {
    fromIte :=  [x | x := checkFrom(cmdList[i], i)]
    sliceCmdList := [x | x := slice(cmdList, fromIte, fromIte[j], j, count(fromIte))]
}
checkFrom(cmd, i) = x {
    cmd.Cmd == "from"
    x := i
}
slice(cmdList, fromIte, s, i, countIte) = cmdListSlice {
    countIte == 1
    cmdListSlice := cmdList
}
slice(cmdList, fromIte, s, i, countIte) = cmdListSlice {
    not countIte == 1
    i == 0
    cmdListSlice := array.slice(cmdList, s, fromIte[1])
}
slice(cmdList, fromIte, s, i, countIte) = cmdListSlice {
    not countIte == 1
    not i == 0
    i == (countIte-1)
    cmdListSlice := array.slice(cmdList, s, count(cmdList))
}
slice(cmdList, fromIte, s, i, countIte) = cmdListSlice {
    not countIte == 1
    not i == 0
    not i == (countIte-1)
    cmdListSlice := array.slice(cmdList, s, fromIte[i+1])
}