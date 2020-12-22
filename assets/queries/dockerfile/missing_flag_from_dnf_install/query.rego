package Cx

CxPolicy [ result ] {
	resource := input.document[i].command[name][_]

  resource.Cmd == "run"
 	
  values := resource.Value[0]
	commands = split(values,"&&")
    
  some k
    hasInstallCommandWithoutFlag(commands[k])
    not hasYesFlag(commands[k])
    
	result := {
    			    "documentId": 		input.document[i].id,
              "searchKey": 	    sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
              "issueType":		 "IncorrectValue",
              "keyExpectedValue": "When running `dnf install`, `-y` or `--asumme-yes` switch is set to avoid build failure ",
              "keyActualValue": 	 sprintf("Command `FROM={{%s}}.RUN={{%s}}` doesn't have the `-y` or `--asumme-yes` switch set",[name,trim_space(commands[k])])
            }
}

hasInstallCommandWithoutFlag(command){
	commandList = [
		    "install", 
        "groupinstall", 
        "localinstall",
        "reinstall",
        "in",
        "rei"
        ]
        
  contains(command, "dnf")
	contains(command, commandList[_])
}

hasYesFlag(command){
	contains(command, "-y")
}

hasYesFlag(command){
	contains(command, "--assume-yes")
}