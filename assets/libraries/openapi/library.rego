package generic.openapi

check_openapi(doc) = version {
	object.get(doc, "openapi", "undefined") != "undefined"
	version = doc.openapi
	regex.match("^3\\.0\\.\\d+$", doc.openapi)
} else = version {
	version = "undefined"
}

is_valid_url(url) {
	regex.match(`^(https?):\/\/(-\.)?([^\s\/?\.#-]+([-\.\/])?)+(\/[^\s]*)?$`, url)
}

improperly_defined(params, value) {
	params.in == "header"
	params.name == value
}

incorrect_ref(ref, object) {
	references := {
		"schema": "#/components/schemas",
		"responses": "#/components/responses",
		"requestBody": "#/components/requestBodies",
	}

	not contains(ref, references[object])
}
