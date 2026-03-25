from pymarshal.json import type_assert, type_assert_iter


class ScanFile:
    def __init__(self, file_name, similarity_id, line,
                 resource_type, resource_name, issue_type,
                 search_key, search_line, search_value,
                 expected_value, actual_value):
        self.file_name = type_assert(file_name, str)
        self.similarity_id = type_assert(similarity_id, str)
        self.line = type_assert(line, int)
        self.resource_type = type_assert(resource_type, str)
        self.resource_name = type_assert(resource_name, str)
        self.issue_type = type_assert(issue_type, str)
        self.search_key = type_assert(search_key, str)
        self.search_line = type_assert(search_line, int)
        self.search_value = type_assert(search_value, str)
        self.expected_value = type_assert(expected_value, str)
        self.actual_value = type_assert(actual_value, str)


class Query:
    def __init__(self, query_name="", query_id="", files=None):
        self.query_name = type_assert(query_name, str)
        self.query_id = type_assert(query_id, str)
        self.files = type_assert_iter(files, ScanFile)


class ScanResults:
    def __init__(self, queries=None):
        self.queries = type_assert_iter(queries, Query)
