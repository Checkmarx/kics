package Cx

CxPolicy [ result ] {

    resource := input.document[i].command[name][com]
    resource.Cmd == "from"
    
    count(resource.Value) == 3
    resource.Value[1] == "as"
    
    nameAlias := resource.Value[2]
    
    some alias
    	aliasResource := input.document[i].command[name][alias]
    	aliasResource != resource 
        aliasResource.Cmd == "from"
        count(aliasResource.Value) == 3
        aliasResource.Value[0] == resource.Value[0]
        aliasResource.Value[2] == nameAlias
        
        
    	

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s", [resource.Original]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "Different froms cant have the same alias defined",
                "keyActualValue": 	"Different froms have the same alias defined"
              }
}