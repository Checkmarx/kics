class ScanFile:
    def __init__(self, data):
        self.file_name = data.get("file_name", "")
        self.similarity_id = data.get("similarity_id", "")
        self.line = int(data.get("line", 0))
        self.resource_type = data.get("resource_type", "")
        self.resource_name = data.get("resource_name", "")
        self.issue_type = data.get("issue_type", "")
        self.search_key = data.get("search_key", "")
        self.search_line = int(data.get("search_line", 0))
        self.search_value = data.get("search_value", "")
        self.expected_value = data.get("expected_value", "")
        self.actual_value = data.get("actual_value", "")


class Query:
    def __init__(self, data):
        self.query_name = data.get("query_name", "")
        self.query_id = data.get("query_id", "")
        self.files = [ScanFile(f) for f in data.get("files", [])]


class ScanResults:
    def __init__(self, data):
        self.queries = [Query(q) for q in data.get("queries", [])]
