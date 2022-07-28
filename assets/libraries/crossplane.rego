package generic.crossplane

import data.generic.common as common_lib

getPath(path) = result {
	count(path) > 0
	path_string := common_lib.concat_path(path)
	out := array.concat([path_string], ["."])
	result := concat("", out)
} else = result {
	count(path) == 0
	result := ""
}
