package Cx

CxPolicy [ result ] {
  resource := input.document[i].command
  from := splitFrom(resource)
  fromCommand := from[_]
  cmdInst := [x | x:= checkCmd(fromCommand[_])]
  count(cmdInst) > 1
  

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM=%s.ENTRYPOINT=%s", [fromCommand[0].Value[0], cmdInst[count(cmdInst)-1].Value[0]]),
                "issueType":		"RedundantAttribute",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "There is only one ENTRYPOINT instruction",
                "keyActualValue": 	sprintf("There are %d ENTRYPOINT instructions", [count(cmdInst)])
              }
}

checkCmd(cmd) = cd {
	cmd.Cmd == "entrypoint"
    cd := cmd
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