package Cx

listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob", "Service", "Secret", "ServiceAccount", "Role", "RoleBinding", "ConfigMap", "Ingress", "Configuration", "Service", "Revision", "ContainerSource"]

import data.generic.common as common_lib
import data.generic.k8s as k8s_lib

# IMPROVED VERSION: Reduces False Positives by considering legitimate namespace usage patterns
CxPolicy[result] {
	document := input.document[i]

	kind := document.kind
	k8s_lib.checkKind(kind, listKinds)

	metadata = document.metadata

	not common_lib.valid_key(metadata, "namespace")
	
	# Only flag if this resource type should have an explicit namespace in production
	should_require_explicit_namespace(kind, document)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("kind={{%s}}.metadata.name={{%s}}", [kind, metadata.name]),
		"keyExpectedValue": "metadata.namespace should be defined and not null",
		"keyActualValue": "metadata.namespace is undefined or null",
		"searchLine": common_lib.build_search_line(["metadata", "name"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]

	kind := document.kind
	k8s_lib.checkKind(kind, listKinds)

	metadata = document.metadata

	unrecommended_namespaces := {"default", "kube-system", "kube-public"}
	metadata.namespace == unrecommended_namespaces[x]
	
	# Only flag if this resource shouldn't be in these namespaces
	should_avoid_system_namespace(kind, metadata.namespace, document)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.namespace", [metadata.name]),
		"keyExpectedValue": "'metadata.namespace' should not be set to default, kube-system or kube-public",
		"keyActualValue": sprintf("'metadata.namespace' is set to %s", [unrecommended_namespaces[x]]),
		"searchLine": common_lib.build_search_line(["metadata", "namespace"], []),
	}
}

# Helper function: Determine if resource should require explicit namespace
should_require_explicit_namespace(kind, document) {
	# Flag workload resources that should be organized in namespaces
	is_workload_resource(kind)
	
	# But exclude simple/testing scenarios
	not is_simple_testing_scenario(document)
}

# Helper function: Check if resource is a workload that benefits from namespacing
is_workload_resource(kind) {
	workload_kinds := {"Deployment", "StatefulSet", "DaemonSet", "Job", "CronJob", "Service", "Ingress", "ConfigMap", "Secret"}
	kind == workload_kinds[_]
}

# Helper function: Check for simple testing scenarios
is_simple_testing_scenario(document) {
	# Single pod with simple configuration (likely testing)
	document.kind == "Pod"
	is_simple_pod_config(document)
}

is_simple_testing_scenario(document) {
	# Resources with testing-related names
	testing_patterns := {"test", "example", "demo", "sample", "tutorial"}
	resource_name := lower(document.metadata.name)
	contains(resource_name, testing_patterns[_])
}

is_simple_testing_scenario(document) {
	# Resources with development-related labels
	common_lib.valid_key(document.metadata, "labels")
	labels := document.metadata.labels
	
	# Check for development/testing labels
	dev_indicators := {"environment", "env", "stage", "tier"}
	dev_values := {"dev", "development", "test", "testing", "demo", "example"}
	
	labels[dev_indicators[_]] == dev_values[_]
}

# Helper function: Check if pod has simple configuration
is_simple_pod_config(document) {
	# Single container
	count(document.spec.containers) == 1
	
	# No complex configurations
	not common_lib.valid_key(document.spec, "volumes")
	not common_lib.valid_key(document.spec, "serviceAccountName")
}

# Helper function: Determine if resource should avoid system namespaces
should_avoid_system_namespace(kind, namespace, document) {
	# Most user workloads should avoid system namespaces
	is_workload_resource(kind)
	
	# But allow legitimate system components
	not is_legitimate_system_component(document, namespace)
}

should_avoid_system_namespace(kind, namespace, document) {
	# Always flag default namespace usage for production workloads
	namespace == "default"
	is_workload_resource(kind)
	not is_simple_testing_scenario(document)
}

# Helper function: Check for legitimate system components
is_legitimate_system_component(document, namespace) {
	# System DaemonSets are often legitimate in kube-system
	document.kind == "DaemonSet"
	namespace == "kube-system"
	is_system_daemonset(document)
}

is_legitimate_system_component(document, namespace) {
	# System services in kube-system
	document.kind == "Service"
	namespace == "kube-system"
	is_system_service(document)
}

# Helper function: Check if DaemonSet is a system component
is_system_daemonset(document) {
	system_daemonset_patterns := {
		"kube-proxy", "calico", "flannel", "weave", "cilium", 
		"node-exporter", "fluentd", "filebeat", "logstash"
	}
	
	name := lower(document.metadata.name)
	contains(name, system_daemonset_patterns[_])
}

# Helper function: Check if Service is a system service
is_system_service(document) {
	system_service_patterns := {
		"kube-dns", "coredns", "metrics-server", "kubernetes-dashboard"
	}
	
	name := lower(document.metadata.name)
	contains(name, system_service_patterns[_])
}
