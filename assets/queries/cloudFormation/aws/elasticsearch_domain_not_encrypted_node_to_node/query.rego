package Cx 

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

resources := {"AWS::Elasticsearch::Domain", "AWS::OpenSearchService::Domain"} 

CxPolicy[result] {
    document := input.document[i]
    resource := document.Resources[name]
    resource.Type == resources[m]

    r := node_to_node_block_not_defined(resource.Properties, resources[m], name)

    result := {
        "documentId": input.document[i].id,
        "resourceType": resource.Type,
        "resourceName": cf_lib.get_resource_name(resource, name),
        "searchKey": r.sk,
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'Resources.%s.Properties.NodeToNodeEncryptionOptions' should be defined", [name]),
        "keyActualValue": sprintf("'Resources.%s.Properties.NodeToNodeEncryptionOptions' is null or not defined", [name]),
        "searchLine": r.sl,
    }
}

CxPolicy[result] {
    document := input.document[i]
    resource := document.Resources[name]
    resource.Type == resources[m]

    common_lib.valid_key(resource.Properties.NodeToNodeEncryptionOptions, "Enabled")
    node_to_node_encryption_not_enabled(resource.Properties, resources[m])

    result := {
        "documentId": input.document[i].id,
        "resourceType": resource.Type,
        "resourceName": cf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("Resources.%s.Properties.NodeToNodeEncryptionOptions.Enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'Resources.%s.Properties.NodeToNodeEncryptionOptions.Enabled' should be defined to true", [name]),
        "keyActualValue": sprintf("'Resources.%s.Properties.NodeToNodeEncryptionOptions.Enabled' is not defined to true", [name]),
        "searchLine": common_lib.build_search_line(["Resources", name, "Properties", "NodeToNodeEncryptionOptions", "Enabled"], []),
    }
}

node_to_node_encryption_not_enabled(resource, type) {
    type == "AWS::Elasticsearch::Domain"
    not cf_lib.isCloudFormationTrue(resource.NodeToNodeEncryptionOptions.Enabled)
} else {
    type == "AWS::OpenSearchService::Domain"
    regex.match("^Elasticsearch_[0-9]{1}\\.[0-9]{1,2}$", resource.EngineVersion)
    not cf_lib.isCloudFormationTrue(resource.NodeToNodeEncryptionOptions.Enabled)
}

node_to_node_block_not_defined(resource, type, name) = r {
    type == "AWS::Elasticsearch::Domain"
    not common_lib.valid_key(resource, "NodeToNodeEncryptionOptions")    
    r := {
        "sk": sprintf("Resources.%s.Properties", [name]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties"], []),
    }
} else = r {
    type == "AWS::Elasticsearch::Domain"
    resource.NodeToNodeEncryptionOptions == {} 
    r := {
        "sk": sprintf("Resources.%s.Properties.NodeToNodeEncryptionOptions", [name]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties", "NodeToNodeEncryptionOptions"], []),
    }
} else = r {
    type == "AWS::OpenSearchService::Domain"
    regex.match("^Elasticsearch_[0-9]{1}\\.[0-9]{1,2}$", resource.EngineVersion)
    not common_lib.valid_key(resource, "NodeToNodeEncryptionOptions")
    r := {
        "sk": sprintf("Resources.%s.Properties", [name]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties"], []),
    }
} else = r {
    type == "AWS::OpenSearchService::Domain"
    regex.match("^Elasticsearch_[0-9]{1}\\.[0-9]{1,2}$", resource.EngineVersion)
    resource.NodeToNodeEncryptionOptions == {}
    r := {
        "sk": sprintf("Resources.%s.Properties.NodeToNodeEncryptionOptions", [name]),
        "sl": common_lib.build_search_line(["Resources", name, "Properties", "NodeToNodeEncryptionOptions"], []),
    }
}