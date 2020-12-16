package Cx

CxPolicy [ result ] {
  instruction := input.document[i].command[_]

  from := splitFrom(input.document[i].command)
  fromCommand := from[j]

  fromCommand[k].Cmd == "run"
  
  contains(fromCommand[k].Value[0], "pip install")
  not contains(fromCommand[k].Value[0], " -r ")
  not regex.match(`pip\s+install\s+(--[a-z]+\s+)*(-[a-zA-z]{1}\s+)*\s*[^- || --][A-Za-z0-9_-]+=(.+)`, fromCommand[k].Value[0])

  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("FROM=%v.RUN=%s", [fromCommand[0].Value[0], fromCommand[k].Value[0]]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": "RUN instruction with 'pip install <package>' should use package pinning form 'pip install <package>=<version>'",
    "keyActualValue": sprintf("RUN instruction %s does not use package pinning form", [fromCommand[k].Value[0]])
  } 
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
