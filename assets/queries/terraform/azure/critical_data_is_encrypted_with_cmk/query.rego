package Cx 

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
    doc := input.document[i].resource

    res := get_res(doc)

    result := {
        "documentId": input.document[i].id,
        "resourceType": res["rt"],
        "resourceName": res["rn"],
        "searchKey": res["sk"],
        "searchLine": res["sl"],
        "issueType": res["it"],
        "keyExpectedValue": res["kev"],
        "keyActualValue": res["kav"],
        "remediation": res["rem"],
        "remediationType": res["rtype"],
    }
}

get_res(doc) = res { # key_vault_key_id field not defined
    common_lib.valid_key(doc, "azurerm_storage_account")
    storage_account := doc.azurerm_storage_account[name]
    common_lib.valid_key(storage_account, "customer_managed_key")
    not common_lib.valid_key(storage_account.customer_managed_key, "key_vault_key_id")
    res := {
        "rt": "azurerm_storage_account",
        "rn": tf_lib.get_resource_name(doc.azurerm_storage_account[name], name),
        "sk": sprintf("azurerm_storage_account[%s].customer_managed_key", [name]),
        "it": "MissingAttribute",
        "kav": "'key_vault_key_id' is not defined inside the 'customer_managed_key' block",
        "kev": "'key_vault_key_id' must be defined inside the 'customer_managed_key' block",
        "sl": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "customer_managed_key"], []),
        "rem": "key_vault_key_id = \"azure\"",
        "rtype": "addition"
    }
} else = res { # customer_managed_key block not defined
    common_lib.valid_key(doc, "azurerm_storage_account")
    storage_account := doc.azurerm_storage_account[name]
    not common_lib.valid_key(storage_account, "customer_managed_key")
    not common_lib.valid_key(doc, "azurerm_storage_account_customer_managed_key")
    res := {
        "rt": "azurerm_storage_account",
        "rn": tf_lib.get_resource_name(doc.azurerm_storage_account[name], name),
        "sk": sprintf("azurerm_storage_account[%s]", [name]),
        "it": "MissingAttribute",
        "kav": "'azurerm_storage_account' does not have a 'customer_managed_key' block defined",
        "kev": "'azurerm_storage_account' should have a 'customer_managed_key' block defined",
        "sl": common_lib.build_search_line(["resource", "azurerm_storage_account", name], []),
        "rem": "customer_managed_key {\n\t\tkey_vault_key_id = \"azure\"\n\t}",
        "rtype": "addition"
    }
} else = res { # azurerm_storage_account_customer_managed_key with an incorrect storage_account_id
    common_lib.valid_key(doc, "azurerm_storage_account")
    common_lib.valid_key(doc, "azurerm_storage_account_customer_managed_key")
    storage_account_cmk := doc.azurerm_storage_account_customer_managed_key[name_cmk]
    storage_account := doc.azurerm_storage_account[name]
    not name == split(storage_account_cmk.storage_account_id, ".")[1]
    res := {
        "rt": "azurerm_storage_account_customer_managed_key",
        "rn": tf_lib.get_resource_name(storage_account_cmk, name_cmk),
        "sk": sprintf("azurerm_storage_account_customer_managed_key[%s].storage_account_id", [name_cmk]),
        "it": "IncorrectValue",
        "kav": "'storage_account_id' is not referencing an existent 'azurerm_storage_account'",
        "kev": "'storage_account_id' is referencing an 'azurerm_storage_account' that doesn't exist",
        "sl": common_lib.build_search_line(["resource", "azurerm_storage_account_customer_managed_key", name_cmk, "storage_account_id"], []),
        "rem": json.marshal({
            "before": sprintf("%s", [storage_account_cmk.storage_account_id]),
            "after": sprintf("azurerm_storage_account.%s.id", [name])
        }),
        "rtype": "replacement"
    }
} else = res { # no azurerm_storage_account_defined
    common_lib.valid_key(doc, "azurerm_storage_account_customer_managed_key")
    not common_lib.valid_key(doc, "azurerm_storage_account")
    storage_account_cmk := doc.azurerm_storage_account_customer_managed_key[name_cmk]
    common_lib.valid_key(storage_account_cmk, "storage_account_id")
    res_storage_account_name := split(storage_account_cmk.storage_account_id, ".")[1]

    res := {
        "rt": "azurerm_storage_account_customer_managed_key",
        "rn": tf_lib.get_resource_name(storage_account_cmk, name_cmk),
        "sk": sprintf("azurerm_storage_account_customer_managed_key[%s].storage_account_id", [name_cmk]),
        "it": "IncorrectValue",
        "kav": "'storage_account_id' is not referencing an existent 'azurerm_storage_account'",
        "kev": "'storage_account_id' is referencing an 'azurerm_storage_account' that doesn't exist",
        "sl": common_lib.build_search_line(["resource", "azurerm_storage_account_customer_managed_key", name_cmk, "storage_account_id"], []),
        "rem": null,
        "rtype": null
    }
}