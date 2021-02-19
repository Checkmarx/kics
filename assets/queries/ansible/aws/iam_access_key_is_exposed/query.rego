package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document = input.document[i]
	tasks := ansLib.getTasks(document)
	iamuserObj = tasks[_]
    ansLib.isAnsibleTrue(task["community.aws.iam"].publicly_accessible)
	iamuserObjBody = iamuserObj["community.aws.iam"]
	iamuserObjName = iamuserObj.name
	lower(iamuserObjBody.access_key_state) == "active"
	not contains(lower(iamuserObjBody.name),"root")
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam}}.access_key_state", [iamuserObjName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}}.{{community.aws.iam}}.name is 'root' for an active access key", [iamuserObjName]),
		"keyActualValue": sprintf("{{%s}}.{{community.aws.iam}}.name is '%s' for an active access key", [iamuserObjName, iamuserObjBody.name]),
	}
}
