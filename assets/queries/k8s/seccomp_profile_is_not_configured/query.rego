package Cx

import data.generic.common as common_lib

# seccomp annotations are deprecated since Kubernetes v1.19 and removed with v1.25
CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	[path, value] = walk(document)
	annotations := value.metadata.annotations

	seccompAnnotation := "seccomp.security.alpha.kubernetes.io/defaultProfileName"
	common_lib.valid_key(annotations, seccompAnnotation)
	seccomp := annotations[seccompAnnotation]
	seccomp != "runtime/default"

	# if annotations are in pod metadata, path is empty -> strip redundant dot
	seccompAnnotationPath := trim_left(sprintf("%s.annotations.%s", [common_lib.concat_path(path), seccompAnnotation]), ".")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, seccompAnnotationPath]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s is 'runtime/default'", [metadata.name, seccompAnnotationPath]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s is '%s'", [metadata.name, seccompAnnotationPath, seccomp]),
	}
}
