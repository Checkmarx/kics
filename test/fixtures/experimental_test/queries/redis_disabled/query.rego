package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_elasticache_cluster[name]
	resource.engine != "redis"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elasticache_cluster",
		"resourceName": get_specific_resource_name(resource, "aws_elasticache_cluster", name),
		"searchKey": sprintf("resource.aws_elasticache_cluster[%s].engine", [name]),
		"searchLine": build_search_line(["resource", "aws_elasticache_cluster", name, "engine"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_elasticache_cluster[%s].engine should have Redis enabled", [name]),
		"keyActualValue": sprintf("resource.aws_elasticache_cluster[%s].engine doesn't enable Redis", [name]),
		"remediation": json.marshal({
			"before": "memcached",
			"after": "redis"
		}),
		"remediationType": "replacement",
	}
}

get_specific_resource_name(resource, resourceType, resourceDefinitionName) = name {
	field := resourceFieldName[resourceType]
	name := resource[field]
} else = name {
	name := get_resource_name(resource, resourceDefinitionName)
}

get_resource_name(resource, resourceDefinitionName) = name {
	name := resource["name"]
} else = name {
	name := resource["display_name"]
}  else = name {
	name := resource.metadata.name
} else = name {
	prefix := resource.name_prefix
	name := sprintf("%s<unknown-sufix>", [prefix])
} else = name {
	name := get_tag_name_if_exists(resource)
} else = name {
	name := resourceDefinitionName
}

build_search_line(path, obj) = resolvedPath {
	resolveArray := [x | pathItem := path[n]; x := convert_path_item(pathItem)]
	resolvedObj := [x | objItem := obj[n]; x := convert_path_item(objItem)]
	resolvedPath = array.concat(resolveArray, resolvedObj)
}

convert_path_item(pathItem) = convertedPath {
	is_number(pathItem)
	convertedPath := sprintf("%d", [pathItem])
} else = convertedPath {
	convertedPath := sprintf("%s", [pathItem])
}

get_tag_name_if_exists(resource) = name {
	name := resource.tags.Name
} else = name {
	tag := resource.Properties.Tags[_]
	tag.Key == "Name"
	name := tag.Value
} else = name {
	tag := resource.Properties.FileSystemTags[_]
	tag.Key == "Name"
	name := tag.Value
} else = name {
	tag := resource.Properties.Tags[key]
	key == "Name"
	name := tag
} else = name {
	tag := resource.spec.forProvider.tags[_]
	tag.key == "Name"
	name := tag.value
} else = name {
	tag := resource.properties.tags[key]
	key == "Name"
	name := tag
}

resourceFieldName = {
	"google_bigquery_dataset": "friendly_name",
	"alicloud_actiontrail_trail": "trail_name",
	"alicloud_ros_stack": "stack_name",
	"alicloud_oss_bucket": "bucket",
	"aws_s3_bucket": "bucket",
	"aws_msk_cluster": "cluster_name",
	"aws_mq_broker": "broker_name",
	"aws_elasticache_cluster": "cluster_id",
}
