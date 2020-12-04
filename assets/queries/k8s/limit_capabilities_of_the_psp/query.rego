package Cx

CxPolicy [ result ] {
   metadata := input.document[i].metadata
   spec := input.document[i].spec
   requiredDropCapabilities := object.get(spec, "requiredDropCapabilities", "undefined") != "undefined"
   not requiredDropCapabilities 
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey":      sprintf("metadata.name=%s.spec", [metadata.name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("metadata.name=%s.spec.requiredDropCapabilities is defined", [metadata.name]),
                "keyActualValue": 	sprintf("metadata.name=%s.spec.requiredDropCapabilities is undefined", [metadata.name])
              }
}