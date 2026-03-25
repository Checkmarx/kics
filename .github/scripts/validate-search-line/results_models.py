from pymarshal.json import unmarshal_json


class ScanFile:
    def __init__(self, file_name="", similarity_id="", line=0,
                 resource_type="", resource_name="", issue_type="",
                 search_key="", search_line="", search_value="",
                 expected_value="", actual_value=""):
        self.file_name = file_name
        self.similarity_id = similarity_id
        self.line = int(line)
        self.resource_type = resource_type
        self.resource_name = resource_name
        self.issue_type = issue_type
        self.search_key = search_key
        self.search_line = int(search_line)
        self.search_value = search_value
        self.expected_value = expected_value
        self.actual_value = actual_value


class Query:
    def __init__(self, query_name="", query_id="", files=None):
        self.query_name = query_name
        self.query_id = query_id
        self.files = [unmarshal_json(f, ScanFile) for f in (files or [])]


class ScanResults:
    def __init__(self, queries=None):
        self.queries = [unmarshal_json(q, Query) for q in (queries or [])]
