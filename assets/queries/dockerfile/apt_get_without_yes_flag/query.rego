package Cx

CxPolicy [ result ] {
  runCmd := input.document[i].command[name][_]
  isRunCmd(runCmd) 
  
  value := runCmd.Value
  count(value) == 1 #command is in a single string

  cmd := value[0]

  searchIndex := indexof(cmd,"apt-get")

  searchIndex != -1

  aptGetCmd := trimCmdEnd(substring(cmd,searchIndex+8,count(cmd)-searchIndex-8))

  not hasYesFlag(aptGetCmd)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM={{%s}}.{{%s}}", [name, runCmd.Original]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'%s' uses '-y' flag to avoid user manual input", [runCmd.Original]),
                "keyActualValue": 	sprintf("'%s' does not use '-y' flag to avoid user manual input", [runCmd.Original])
              }
}

CxPolicy [ result ] {
  runCmd := input.document[i].command[name][_]
  isRunCmd(runCmd) 
  
  value := runCmd.Value
  count(value) > 1 #command is in several tokens
  
  aptGetIdx := getAptGetIdx(value)
  aptGetIdx != -1
  aptGetCmdLastIdx := getCmdLastIdx(value,aptGetIdx)

  not checkYesFlag(value,aptGetIdx,aptGetCmdLastIdx)

  cmdFormatted := replace(runCmd.Original,"\"","'")

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM={{%s}}.{{%s}}", [name, runCmd.Original]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'%s' uses '-y' flag to avoid user manual input", [cmdFormatted]),
                "keyActualValue": 	sprintf("'%s' does not use '-y' flag to avoid user manual input", [cmdFormatted])
              }
}

isRunCmd(com) = true{
  com.Cmd == "run"
} else = false

trimCmdEnd(cmd) = trimmed {
  termOps := ["&&","||","|","&",";"]

  splitStr := split(cmd," ")
  some i, j
      splitStr[i] == termOps[j] 
      indexTerm := indexof(cmd,termOps[j])
      trimmed := substring(cmd,0,count(cmd) - indexTerm)
} else = cmd

hasYesFlag(arg) {
  flags := ["-y","-yes","--assume-yes"]
  contains(arg,flags[_])
} else = false

getAptGetIdx(value) = idx {
  some i
    value[i] == "apt-get"
    idx := i+1
} else = -1

getCmdLastIdx(arr,initCmdIdx) = idx {
  termOps := ["&&","||","|","&",";"]
  some i
    i > initCmdIdx
    arr[i] == termOps[i]
    idx := i-1
} else = count(arr)-1

checkYesFlag(cmd,start,end) {
  some i
    i >= start 
    i <= end
    hasYesFlag(cmd[i])
} else = false