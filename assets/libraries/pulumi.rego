package generic.pulumi

type_check(resource_type, prefix, sufix) {
	startswith(resource_type, prefix)
	endswith(resource_type, sufix)
}
