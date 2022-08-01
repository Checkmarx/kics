package generic.pulumi

getResourceName(resource, logicName) = name {
	resourceNameAtt := pulumiResourcesWithName[resource.Type]
	name := resource.Properties[resourceNameAtt]
} else = name {
	name := logicName
}

pulumiResourcesWithName = {
	"gcp:storage:Bucket"    : "name",
	"gcp:compute:SSLPolicy" : "name",
}
