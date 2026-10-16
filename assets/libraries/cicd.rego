package generic.cicd

# has_trigger reports whether the given event name is configured in a
# workflow's "on:" trigger. GitHub Actions allows three equivalent
# forms, and a query that only checks one of them silently misses the
# other two:
#   on: pull_request_target                 (scalar string)
#   on: [pull_request_target, push]         (list of strings)
#   on: { pull_request_target: {...} }      (map; value may be an
#                                             object, or empty/null)
has_trigger(on, name) {
	is_string(on)
	on == name
}

has_trigger(on, name) {
	is_array(on)
	on[_] == name
}

has_trigger(on, name) {
	is_object(on)
	on[name]
}
