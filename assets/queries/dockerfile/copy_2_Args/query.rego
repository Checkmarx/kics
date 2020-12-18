package Cx

CxPolicy [ result ] {

    resource := input.document[i].command[name][_]
    
    resource.Cmd == "copy"
    
    command := resource.Value
    
    numElems := count(command)
    numElems > 2
    
  	not endswith(command[numElems - 1],"/")

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM={{%s}}.COPY={{%s}}", [name, resource.Value[0]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "When copy has more than two arguments, the last one should end with a slash",
                "keyActualValue": 	"Copy has more than two arguments and the last one does not ends with a slash"
              }
}