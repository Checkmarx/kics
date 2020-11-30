package Cx

CxPolicy [ result ] {
   spec := input.document[i].spec 
   containers := spec.containers
   images = object.get(containers[c], "image", "undefined") != "undefined" 
   not images
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d].image", [c]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("spec.containers[%d].image is defined", [c]),
                "keyActualValue": 	sprintf("spec.containers[%d].image is undefined", [c])
              }
}

CxPolicy [ result ] {
   spec := input.document[i].spec 
   containers := spec.containers
   images = containers[c].image
   check_content(images)	
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d].image", [c]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("spec.containers[%d].image is not null, empty or latest", [c]),
                "keyActualValue": 	sprintf("spec.containers[%d].image is null, empty or latest", [c])
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