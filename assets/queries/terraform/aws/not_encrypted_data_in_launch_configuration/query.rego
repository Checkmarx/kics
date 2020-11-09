package Cx

CxPolicy [ result ] {
	enc := input.file[i].data.aws_launch_configuration[name][block].encrypted
    enc == false
    not contains(block, "ephemeral")
    contains(block, "block_device")

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_launch_configuration[%s].%s.encrypted", [name, block]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'%s.encrypted' is equal 'true'", [block]),
                "keyActualValue": 	sprintf("'%s.encrypted' is equal 'false'", [block]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
