package Cx

CxPolicy [ result ] {
  command := input.document[i].command[_]

  from := splitFrom(input.document[i].command)
  fromCommand := from[w]

  fromCommand[j].Cmd == "run"
  arrCmds := split(fromCommand[j].Value[0], " ")
  contains(fromCommand[j].Value[0], "apk upgrade")

  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("FROM=%s.RUN=%s.apk[upgrade]", [fromCommand[0].Value[0], arrCmds[0]]),
    "issueType": "InvalidAttribute",
    "keyExpectedValue": sprintf("RUN command '%s' should not have apk upgrade instruction", [fromCommand[j].Value[0]]),
    "keyActualValue": sprintf("RUN '%s' has apk upgrade instruction", [fromCommand[j].Value[0]])
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
