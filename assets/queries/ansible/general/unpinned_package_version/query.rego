package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][_]
	package_installer := task[ansLib.installer_modules[m]]
	ansLib.checkState(package_installer)

	not common_lib.valid_key(package_installer, "version")
    not common_lib.valid_key(package_installer, "update_only")
    package_installer.state == "latest"

	result := {
		"documentId": id,
		"resourceType": ansLib.installer_modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.state", [task.name, ansLib.installer_modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "State's task when installing a package should not be defined as 'latest' or should have set 'update_only' to 'true'",
		"keyActualValue": "State's task is set to 'latest'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][_]
	package_installer := task[ansLib.installer_modules[m]]
	ansLib.checkState(package_installer)

	not common_lib.valid_key(package_installer, "version")
    package_installer.update_only == false
    package_installer.state == "latest"

	result := {
		"documentId": id,
		"resourceType": ansLib.installer_modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.state", [task.name, ansLib.installer_modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "State's task when installing a package should not be defined as 'latest' or should have set 'update_only' to 'true'",
		"keyActualValue": "State's task is set to 'latest'",
	}
}
