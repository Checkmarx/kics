package generic.pulumi

import data.generic.common as common_lib

getResourceName(resource, logicName) = name {
	resourceNameAtt := pulumiResourcesWithName[resource.Type]
	name := resource.Properties[resourceNameAtt]
} else = name {
	name := common_lib.get_tag_name_if_exists(resource)
} else = name {
	name := logicName
}

pulumiResourcesWithName = {
	"gcp:storage:Bucket"    : "name",
	"gcp:compute:SSLPolicy" : "name",
}
