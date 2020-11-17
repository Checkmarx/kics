package Cx

CxPolicy [ result ] {
  data := input.document[i].data.google_compute_instance[appserver]
  data.can_ip_forward == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("google_compute_instance[%s]", [appserver]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'can_ip_forward' is false or Attribute 'can_ip_forward' is undefined",
                "keyActualValue": 	"Attribute 'can_ip_forward' is true"
              }
}