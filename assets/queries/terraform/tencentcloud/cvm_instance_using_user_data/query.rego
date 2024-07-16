package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

check_user_datas(mdata) {
	count(regex.find_n(`secretId\s*=|TENCENTCLOUD_SECRET_ID\s*=|secretKey\s*=|TENCENTCLOUD_SECRET_KEY\s*=`, mdata, -1)) > 0
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.tencentcloud_instance[name]

	decoded := base64.decode(resource.user_data)
	check_user_datas(decoded)

	result := {
		"documentId": doc.id,
		"resourceType": "tencentcloud_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_instance[%s].user_data", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_instance[%s] should be using 'cam_role_name' to assign a role with permissions", [name]),
		"keyActualValue": sprintf("tencentcloud_instance[%s].user_data is being used to configure API secret keys", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.tencentcloud_instance[name]

	dataRaw := resource.user_data_raw
	check_user_datas(dataRaw)

	result := {
		"documentId": doc.id,
		"resourceType": "tencentcloud_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_instance[%s].user_data", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_instance[%s] should be using 'cam_role_name' to assign a role with permissions", [name]),
		"keyActualValue": sprintf("tencentcloud_instance[%s].user_data is being used to configure API secret keys", [name]),
	}
}
