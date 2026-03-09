from dataclasses import dataclass, field

@dataclass
class ResultInfo:
    query_name: str
    severity: str
    line: str
    filename: str
    resource_type: str
    resource_name: str
    search_key: str
    search_value: str
    expected_value: str
    actual_value: str

@dataclass
class QueryInfo:
    test_path: str
    results_file_path: str
    id: str
    payload_path: str
    results_info: list[ResultInfo] = field(default_factory=list)
    return_code: int | None = None

@dataclass
class TestList:
    queries_list: list[QueryInfo] = field(default_factory=list)
