package Cx

CxPolicy [ result ] {
   document := input.document
   metadata := document[i].metadata
   spec := document[i].spec 
   containers := spec.containers
   images = object.get(containers[c], "image", "undefined") != "undefined" 
   not images
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.containers.name=%s", [metadata.name, containers[c].name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("metadata.name=%s.spec.containers.name=%s.image is defined", [metadata.name, containers[c].name]),
                "keyActualValue": 	sprintf("metadata.name=%s.spec.containers.name=%s.image is undefined", [metadata.name, containers[c].name])
              }
}

CxPolicy [ result ] {
   document := input.document
   metadata := document[i].metadata
   spec := document[i].spec 
   containers := spec.containers
   images = containers[c].image
   check_content(images)	
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.containers[%d].image", [metadata.name, c]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("metadata.name=%s.spec.containers[%d].image is not null, empty or latest", [metadata.name, c]),
                "keyActualValue": 	sprintf("metadata.name=%s.spec.containers[%d].image is null, empty or latest", [metadata.name, c])
              }
}

check_content(images) {	
	images == ""
}

check_content(images) {	
	images == "latest"
}

check_content(images) {	
	images == null
}