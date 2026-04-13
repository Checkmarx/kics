class ScanFile:
    def __init__(self, data):
        """Initialize ScanFile with scan result data."""
        self.file_name = data.get("file_name", "")
        self.similarity_id = data.get("similarity_id", "")
        self.line = int(data.get("line"))
        self.resource_type = data.get("resource_type", "")
        self.resource_name = data.get("resource_name", "")
        self.issue_type = data.get("issue_type", "")
        self.search_key = data.get("search_key", "")
        self.search_line = int(data.get("search_line"))
        self.search_value = data.get("search_value", "")
        self.expected_value = data.get("expected_value", "")
        self.actual_value = data.get("actual_value", "")


class Query:
    """Initialize Query with a query name, ID, and its associated scan files."""
    def __init__(self, data):
        self.query_name = data.get("query_name", "")
        self.query_id = data.get("query_id", "")
        self.files = [ScanFile(f) for f in data.get("files", [])]


class ScanResults:
    """Initialize ScanResults with the total failed queries and list of queries."""
    def __init__(self, data):
        self.queries_failed_to_execute = int(data.get("queries_failed_to_execute", 0))
        self.queries = [Query(q) for q in data.get("queries", [])]
