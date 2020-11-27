package Cx

CxPolicy [ result ] {
    document := input.document[i]

    containers := document.spec.containers
    
    lengthContainers := count(containers)
    
    count({x | containers[x]; object.get(containers[x]["resources"]["limits"], "cpu", "undefined") != "undefined" }) != lengthContainers


	result := {
                "documentId": 		input.document[i].id,
                "issueType":		"MissingAttribute",
                "searchKey": 	    "containers",
                "keyExpectedValue": "All containers have CPU limits",
                "keyActualValue": 	"All or some containers have not CPU limits"
              }
}