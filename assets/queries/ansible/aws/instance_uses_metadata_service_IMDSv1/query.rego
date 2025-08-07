package Cx

import data.generic.common as common_lib
	
modules := {"amazon.aws.ec2_instance"}

CxPolicy[result] {
    doc := input.document[i]
	resource := doc.playbooks[j][modules[type]]
	name := doc.playbooks[j].name

    is_metadata_service_enabled(resource)

    res := http_tokens_undefined(resource, type, j, name)
	
    result := {
        "documentId": input.document[i].id,
        "resourceType": modules[type],
        "resourceName": name,
        "searchKey": res["sk"],
        "searchLine": res["sl"],
        "issueType": "MissingAttribute",
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
    }
}

CxPolicy[result] {
    doc := input.document[i]
	resource := doc.playbooks[j][modules[type]]
	name := doc.playbooks[j].name

    is_metadata_service_enabled(resource)

    common_lib.valid_key(resource, "metadata_options")
	common_lib.valid_key(resource.metadata_options, "http_tokens")
	not resource.metadata_options.http_tokens == "required"

    result := {
        "documentId": input.document[i].id,
        "resourceType": modules[type],
        "resourceName": name,
        "searchKey": sprintf("name={{%s}}.{{%s}}.metadata_options.http_tokens", [name, modules[type]]),
        "searchLine": common_lib.build_search_line(["playbooks", j, modules[type], "metadata_options", "http_tokens"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'%s.metadata_options.http_tokens' should be defined to 'required'", [modules[type]]),
        "keyActualValue": sprintf("'%s.metadata_options.http_tokens' is not defined to 'required'", [modules[type]]),
    }
}


is_metadata_service_enabled (resource) {
    common_lib.valid_key(resource, "metadata_options")
    common_lib.valid_key(resource.metadata_options, "http_endpoint")
    resource.metadata_options.http_endpoint == "enabled"
} else {
    not common_lib.valid_key(resource, "metadata_options")
} else {
    common_lib.valid_key(resource, "metadata_options")
    not common_lib.valid_key(resource.metadata_options, "http_endpoint")
}

http_tokens_undefined(ec2, name, t, task) = res {
    not common_lib.valid_key(ec2, "metadata_options")
    res := {
        "kev": sprintf("'%s.metadata_options' should be defined with 'http_tokens' field set to 'required'", [modules[name]]),
        "kav": sprintf("'%s.metadata_options' is not defined", [modules[name]]),
        "sk": sprintf("name={{%s}}.{{%s}}", [task, modules[name]]),
        "sl": common_lib.build_search_line(["playbooks", t, modules[name]], []),
    }
} else = res {
    common_lib.valid_key(ec2, "metadata_options")
    not common_lib.valid_key(ec2.metadata_options, "http_tokens")

    res := {
        "kev": sprintf("'%s.metadata_options.http_tokens' should be defined to 'required'", [modules[name]]),
        "kav": sprintf("'%s.metadata_options.http_tokens' is not defined", [modules[name]]),
        "sk": sprintf("name={{%s}}.{{%s}}.metadata_options", [task, modules[name]]),
        "sl": common_lib.build_search_line(["playbooks", t, modules[name], "metadata_options"], []),
    }
} 
