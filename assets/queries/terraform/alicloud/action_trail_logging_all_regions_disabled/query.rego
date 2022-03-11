package Cx
import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_actiontrail_trail[name]
    
    possibilities := {"event_rw", "oss_bucket_name", "trail_region"}
    not common_lib.valid_key(resource, possibilities[p])
    
    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_actiontrail_trail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' is set.",[possibilities[p]]),
		"keyActualValue": sprintf("'%s' is not set.",[possibilities[p]]),
        "searchline": common_lib.build_search_line(["resource", "alicloud_actiontrail_trail", name], []),
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_actiontrail_trail[name]
    
    p := {"event_rw", "trail_region"}
    resource[p[f]] != "All"
    
    
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_actiontrail_trail[%s].%s", [name, p[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' is set to All", [p[f]]),
		"keyActualValue": sprintf("'%s' is not set to All", [p[f]]),
        "searchline": common_lib.build_search_line(["resource", "alicloud_actiontrail_trail", name, p[f]], []),
	}
}
