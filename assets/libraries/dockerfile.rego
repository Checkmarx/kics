package generic.dockerfile

getPackages(commands, command) = output {
	index := indexof(commands, command[0])
	len := count(command[0])

	commandWithAll := substring(commands, len + index, count(commands))

	contains(commandWithAll, ";")
	commandWithAllNoTabs:= replace(commandWithAll, "\t", "")
	commandWithAllSplit := split(commandWithAllNoTabs, ";")

	packages := split(trim_space(commandWithAllSplit[0]), " ")

	output = packages
}else = output {
	index := indexof(commands, command[0])
	len := count(command[0])

	commandWithAll := substring(commands, len + index, count(commands))

	contains(commandWithAll, "&&")
	commandWithAllSplit := split(commandWithAll, "&&")

	packages := split(commandWithAllSplit[0], " ")

	output = packages
}else = output {
	index := indexof(commands, command[0])
	len := count(command[0])

	commandWithAll := substring(commands, len + index, count(commands))

	not contains(commandWithAll, ";")
    not contains(commandWithAll, "&&")

	packages := split(commandWithAll, " ")

	output = packages
}

getCommands(commands) = output{
	output := split(commands, "&&")
} else = output{
	output := split(commands, "; ")
}

withVersion(pack) {
	regex.match("[A-Za-z0-9_\\+-]+[-:][$](.+)", pack)
}

withVersion(pack) {
	regex.match("[A-Za-z0-9_\\+-]+[:-]([0-9]+.)+[0-9]+", pack)
}

withVersion(pack) {
	regex.match("[A-Za-z0-9_\\+-]+~?=(.+)", pack)
}

arrayContains(array, list) {
	contains(array[_], list[_])
}

check_multi_stage(imageName, images) {
    unsortedIndex := {x |
        images[name][i].Cmd == "from"
        x := {"Name": name, "Line": images[name][i].EndLine}
    }

    sortedIndex := sort(unsortedIndex)
    imageName == sortedIndex[minus(count(sortedIndex), 1)].Name
} 
