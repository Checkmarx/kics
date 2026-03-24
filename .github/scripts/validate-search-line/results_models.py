from dataclasses import dataclass, field

@dataclass
class ScanFile:
    file_name: str = ""
    similarity_id: str = ""
    line: int = 0
    resource_type: str = ""
    resource_name: str = ""
    issue_type: str = ""
    search_key: str = ""
    search_line: int = 0
    search_value: str = ""
    expected_value: str = ""
    actual_value: str = ""
    
@dataclass
class Query:
    query_name: str = ""
    query_id: str = ""
    files: list[ScanFile] = field(default_factory=list)

@dataclass
class ScanResults:
    queries: list[Query] = field(default_factory=list)