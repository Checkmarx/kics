package generic.dockerfile

getPackages(commands, command) = output {
	index := indexof(commands, command[0])
	len := count(command[0])

	commandWithAll := substring(commands, len + index, count(commands))

	commandWithAllSplit := split(commandWithAll, "&&")

	packages := split(commandWithAllSplit[0], " ")

	output = packages
}

withVersion(pack) {
	regex.match("[A-Za-z0-9_-]+[-:][$](.+)", pack)
}

withVersion(pack) {
	regex.match("[A-Za-z0-9_-]+[:-]([0-9]+.)+[0-9]+", pack)
}

withVersion(pack) {
	regex.match("[A-Za-z0-9_-]+=(.+)", pack)
}

arrayContains(array, list) {
	contains(array[_], list[_])
}
