package Cx


CxPolicy [ result ] {
  projectIam := input.document[i].resource.google_project_iam_member[name]
  startswith(projectIam.member, "serviceAccount:")
  contains(projectIam.role, "roles/iam.serviceAccountAdmin")
 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_project_iam_member[%s].role", [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("google_project_iam_member[%s].role is not admin", [name]),
				        "keyActualValue": sprintf("google_project_iam_member[%s].role is admin", [name]),
              }
}


CxPolicy [ result ] {
  projectIam := input.document[i].resource.google_project_iam_member[name]
  inArray(projectIam.members,"serviceAccount:")
  contains(projectIam.role, "roles/iam.serviceAccountAdmin")
  

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_project_iam_member[%s].role", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("google_project_iam_member[%s].role is not admin", [name]),
				        "keyActualValue": sprintf("google_project_iam_member[%s].role is admin", [name]),
              }
}


inArray(array, elem) = true {
startswith(array[_],elem)
}
