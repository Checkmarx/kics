
package Cx

CxPolicy[result] {
    document := input.document[i]
    tasks := getTasks(document)
    task := tasks[t]
    awsEc2 := task["amazon.aws.ec2_group"]
    rules := awsEc2.rules[j]
    port := rules.ports[k]
    rules.cidr_ip == "0.0.0.0/0"
    portNumber := 2383
    port <= portNumber
    port >= portNumber
    
 
    result := {
        "documentId": document.id,
        "searchKey": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.cidr_ip", [task.name]),
        "issueType": "IncorrectValue",
       "keyExpectedValue": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.cidr_ip is not public", [task.name]), 
        "keyActualValue": sprintf("name=%s.{{amazon.aws.ec2_group}}.rules.cidr_ip is public", [task.name])
    }
}


getTasks(document) = result {
    result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
    count(result) != 0
} else = result {
    result := [body | playbook := document.playbooks[_]; body := playbook ]  
    count(result) != 0
}


