package Cx

import data.generic.common as commonLib

# search for harcoded secrets by looking for their values with a special chars and length
CxPolicy[result] {
	docs := input.document[_]

	[path, value] = walk(docs)
	is_string(value)
	checkObjects := prepare_object(path[minus(count(path), 1)], value)
	checkObject := checkObjects[_]
	check_vulnerability(checkObject)
	allPath := [x | merge_path(path[i]) != ""; x := merge_path(path[i])]
	result := {
		"documentId": docs.id,
		"searchKey": resolve_path(checkObject, allPath, value),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "Hardcoded secret key should not appear in source",
		"keyActualValue": value,
	}
}

merge_path(pathItem) = item {
	not is_string(pathItem)
	item := ""
} else = item {
	clearParse := ["playbooks", "tasks", "command", "original"]
	commonLib.equalsOrInArray(clearParse, lower(pathItem))
	item := ""
} else = item {
	contains(pathItem, ".")
	item := sprintf("{{%s}}", [pathItem])
} else = item {
	item := pathItem
}

resolve_path(obj, path, value) = resolved {
	obj.id != ""
	resolved := sprintf("FROM=%s.{{%s}}", [concat(".", path), obj.id])
} else = resolved {
	resolved := sprintf("%s=%s", [concat(".", path), value])
}

prepare_object(key, value) = obj {
	#dockerfile
	key == "Original"
	args := split(value, " ")
	obj := [x | x := create_docker_object(args[_], value)]
} else = obj {
	obj := [{
		"key": key,
		"value": value,
		"id": "",
	}]
}

create_docker_object(value, original) = obj {
	contains(value, "=")
	splitted := split(value, "=")
	count(splitted) > 1
	k := splitted[0]
	is_string(k)
	v := concat("", array.slice(splitted, 1, count(splitted)))
	obj := {
		"key": k,
		"value": replace(v, "\"", ""),
		"id": original,
	}
}

check_vulnerability(correctStrings) {
	# password in url
	count(regex.find_n("^[a-zA-Z]{3,10}://[^/\\s:@]{3,20}:[^/\\s:@]{3,20}@.{1,100}[\"'\\s]*", correctStrings.value, -1)) > 0
	true
} else {
	# slack webhook
	count(regex.find_n("^https://hooks.slack.com/services/T[a-zA-Z0-9_]{8}/B[a-zA-Z0-9_]{8}/[a-zA-Z0-9_]{24}", correctStrings.value, -1)) > 0
} else {
	# teams webhook
	count(regex.find_n("^https://[a-zA-Z0-9_]{1,24}\\.webhook\\.office\\.com/webhookb2/[a-zA-Z0-9-]+(@[a-zA-Z0-9-]+)?/IncomingWebhook/[a-zA-Z0-9]+/[a-zA-Z0-9-]+", correctStrings.value, -1)) > 0
}
