package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

has_readonly_lock(doc, sa_id) {
    l := doc.resource.azurerm_management_lock[_]
    check_lock_scope(l.scope, sa_id)
    l.lock_level == "ReadOnly"
}

check_lock_scope(current, target) {
    current == target
}

check_lock_scope(current, target) {
    current == sprintf("${%s}", [target])
}

# CASE 1: Storage Account completely unprotected (no associated locks)
CxPolicy[result] {
    doc := input.document[i]
    sa := doc.resource.azurerm_storage_account[sa_name]
    sa_id := sprintf("azurerm_storage_account.%s.id", [sa_name])

    associated_locks := [l |
        l := doc.resource.azurerm_management_lock[_]
        check_lock_scope(l.scope, sa_id)
    ]
    count(associated_locks) == 0

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_storage_account",
        "resourceName": tf_lib.get_resource_name(sa, sa_name),
        "searchKey": sprintf("azurerm_storage_account[%s]", [sa_name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", sa_name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_storage_account.%s' should have a 'ReadOnly' lock associated", [sa_name]),
        "keyActualValue": sprintf("'azurerm_storage_account.%s' has no locks associated", [sa_name]),
    }
}

# CASE 2: Storage Account with incorrect lock (level other than ReadOnly)
CxPolicy[result] {
    doc := input.document[i]
    lock := doc.resource.azurerm_management_lock[lock_name]

    lock.lock_level != "ReadOnly"

    sa := doc.resource.azurerm_storage_account[sa_name]
    sa_id := sprintf("azurerm_storage_account.%s.id", [sa_name])
    check_lock_scope(lock.scope, sa_id)

    not has_readonly_lock(doc, sa_id)

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_management_lock",
        "resourceName": tf_lib.get_resource_name(lock, lock_name),
        "searchKey": sprintf("azurerm_management_lock[%s].lock_level", [lock_name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_management_lock", lock_name, "lock_level"], []),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("'azurerm_management_lock.%s.lock_level' should be 'ReadOnly'", [lock_name]),
        "keyActualValue": sprintf("'azurerm_management_lock.%s.lock_level' is '%s'", [lock_name, lock.lock_level]),
    }
}
