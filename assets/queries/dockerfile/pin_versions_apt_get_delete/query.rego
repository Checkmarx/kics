package Cx

CxPolicy [ result ] {

    resource := input.document[i].command[name][install]
    resource.Cmd == "run"
    command := resource.Value[0]
	
    contains(resource.Value[0], "apt-get install")
    
    not hasClean(resource.Value[0],install)
    
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "After using apt-get install, it is needed to delete apt-get lists",
                "keyActualValue": 	"After using apt-get install, the apt-get lists were not deleted"
              }
}

hasClean(resourceValue,install) = true {

	listCommands := split(resourceValue, "&& ")
    
	startswith(listCommands[install],"apt-get install")
    
    some clean
    	startswith(listCommands[clean],"apt-get clean")

    some remove
    startswith(listCommands[remove],"rm -rf")
    
    install < clean
    clean < remove
}
