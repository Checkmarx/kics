package Cx

# Improved: Distinguish between user workloads and system components
listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob", "Service", "Secret", "ServiceAccount", "Role", "RoleBinding", "ConfigMap", "Ingress", "Configuration", "Service", "Revision", "ContainerSource"]

import data.generic.common as common_lib
import data.generic.k8s as k8s_lib

# Improved rule: Only flags resources without namespaces if they are user workloads
# that would benefit from namespace isolation
CxPolicy[result] {
	document := input.document[i]

	kind := document.kind
	k8s_lib.checkKind(kind, listKinds)

	metadata = document.metadata

	not common_lib.valid_key(metadata, "namespace")
	
	# Only flag resources that should have explicit namespaces
	should_have_explicit_namespace(document)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("kind={{%s}}.metadata.name={{%s}}", [kind, metadata.name]),
		"searchValue": document.kind, # multiple kinds can match
		"keyExpectedValue": "metadata.namespace should be defined for production workloads",
		"keyActualValue": "metadata.namespace is undefined or null",
		"searchLine": common_lib.build_search_line(["metadata", "name"], []),
	}
}

# Improved rule: Only flags system namespaces when used inappropriately
CxPolicy[result] {
	document := input.document[i]

	kind := document.kind
	k8s_lib.checkKind(kind, listKinds)

	metadata = document.metadata

	options := {"default", "kube-system", "kube-public"}
	metadata.namespace == options[x]
	
	# Only flag if this is not a legitimate system component
	not is_legitimate_system_component(document, options[x])

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "IncorrectValue",
		"searchValue": document.kind, # multiple kinds can match
		"searchKey": sprintf("metadata.name={{%s}}.namespace", [metadata.name]),
		"keyExpectedValue": sprintf("User workloads should not use the '%s' namespace", [options[x]]),
		"keyActualValue": sprintf("'metadata.namespace' is set to %s", [options[x]]),
		"searchLine": common_lib.build_search_line(["metadata", "namespace"], []),
	}
}

# Determine if a resource should have an explicit namespace
should_have_explicit_namespace(document) {
	# Flag workload resources that benefit from isolation
	workload_kinds := {"Deployment", "StatefulSet", "DaemonSet", "Job", "CronJob"}
	document.kind == workload_kinds[_]
	
	# Exclude simple test/demo resources
	not is_test_resource(document)
} else {
	# Flag services and ingresses for production workloads
	service_kinds := {"Service", "Ingress"}
	document.kind == service_kinds[_]
	
	# Exclude simple test/demo resources
	not is_test_resource(document)
}

# Check if this is a legitimate system component that can use system namespaces
is_legitimate_system_component(document, namespace) {
	namespace == "kube-system"
	# Allow legitimate system services
	is_system_service(document)
} else {
	namespace == "default"
	# Allow simple test pods in default namespace
	is_simple_test_pod(document)
}

# Check if this is a legitimate system service
is_system_service(document) {
	# System DaemonSets (node agents, network plugins, etc.)
	document.kind == "DaemonSet"
	system_daemonset_patterns := {"kube-proxy", "coredns", "calico", "flannel", "weave", "cilium"}
	contains(lower(document.metadata.name), system_daemonset_patterns[_])
} else {
	# System services
	document.kind == "Service"
	system_service_patterns := {"kube-dns", "coredns", "metrics-server", "kubernetes-dashboard"}
	contains(lower(document.metadata.name), system_service_patterns[_])
} else {
	# System ServiceAccounts
	document.kind == "ServiceAccount"
	system_sa_patterns := {"coredns", "kube-proxy", "metrics-server"}
	contains(lower(document.metadata.name), system_sa_patterns[_])
} else {
	# System ConfigMaps
	document.kind == "ConfigMap"
	system_cm_patterns := {"coredns", "kube-proxy", "kubeadm-config"}
	contains(lower(document.metadata.name), system_cm_patterns[_])
}

# Check if this is a simple test pod that can reasonably use default namespace
is_simple_test_pod(document) {
	document.kind == "Pod"
	# Simple test patterns
	test_patterns := {"test", "demo", "example", "hello", "nginx"}
	contains(lower(document.metadata.name), test_patterns[_])
}

# Check if this is a test/development resource
is_test_resource(document) {
	# Check for test/demo indicators in name
	test_indicators := {"test", "demo", "example", "sample", "hello-world", "nginx"}
	contains(lower(document.metadata.name), test_indicators[_])
} else {
	# Check for dev/test labels
	common_lib.valid_key(document.metadata, "labels")
	labels := document.metadata.labels
	dev_labels := {"environment": "dev", "environment": "test", "app": "demo"}
	labels[key] == dev_labels[key]
}
