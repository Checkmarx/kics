package Cx 

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

resources := {"AWS::Elasticsearch::Domain", "AWS::OpenSearchService::Domain"} 

CxPolicy[result] {
    document := input.document[i]
    resource := document.Resources[name]
    resource.Type == resources[m]

    node_to_node_block_not_defined(resource.Properties, resources[m])

    result := {
        "documentId": input.document[i].id,
        "resourceType": resource.Type,
        "resourceName": cf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("Resources.%s.Properties", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'Resources.%s.Properties.NodeToNodeEncryptionOptions' should be defined", [name]),
        "keyActualValue": sprintf("'Resources.%s.Properties.NodeToNodeEncryptionOptions' is not defined", [name]),
    }
}

CxPolicy[result] {
    document := input.document[i]
    resource := document.Resources[name]
    resource.Type == resources[m]

    common_lib.valid_key(resource.Properties, "NodeToNodeEncryptionOptions")
    node_to_node_encryption_not_enabled(resource.Properties, resources[m])

    result := {
        "documentId": input.document[i].id,
        "resourceType": resource.Type,
        "resourceName": cf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("Resources.%s.Properties.NodeToNodeEncryptionOptions.Enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'Resources.%s.Properties.NodeToNodeEncryptionOptions.Enabled' should be defined to true", [name]),
        "keyActualValue": sprintf("'Resources.%s.Properties.NodeToNodeEncryptionOptions.Enabled' is not defined to true", [name]),
    }
}

node_to_node_encryption_not_enabled(resource, type) {
    type == "AWS::Elasticsearch::Domain"
    not resource.NodeToNodeEncryptionOptions.Enabled == true
} else {
    type == "AWS::OpenSearchService::Domain"
    regex.match("^Elasticsearch_[0-9]{1}\\.[0-9]{1,2}$", resource.EngineVersion)
    not resource.NodeToNodeEncryptionOptions.Enabled == true
}

node_to_node_block_not_defined(resource, type) {
    type == "AWS::Elasticsearch::Domain"
    not common_lib.valid_key(resource, "NodeToNodeEncryptionOptions")
} else {
    type == "AWS::OpenSearchService::Domain"
    regex.match("^Elasticsearch_[0-9]{1}\\.[0-9]{1,2}$", resource.EngineVersion)
    not common_lib.valid_key(resource, "NodeToNodeEncryptionOptions")
}