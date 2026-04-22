import os
import re
from dataclasses import dataclass


FIELD_ORDER = [
    "queryName", "severity", "line", "fileName",
    "resourceType", "resourceName", "searchKey", "searchValue",
    "expectedValue", "actualValue", "issueType", "similarityID", "search_line",
]

KICS_RESULT_CODES = {0, 1, 20, 30, 40, 50, 60}


def natural_sort_key(s: str):
    """'positive2.tf' → ['positive', 2, '.tf'] so numeric parts sort numerically."""
    return [int(c) if c.isdigit() else c for c in re.split(r'(\d+)', s)]


@dataclass
class PositiveTest:
    """A positive test file to scan."""
    label: str
    scan_path: str
    group: str  # "test" for loose files, "test/<dir>" for subdirectory files


@dataclass
class ScanFailure:
    """A scan that failed with an unexpected return code."""
    scan_path: str
    payload_path: str
    return_code: int


@dataclass
class ExpectedResultEntry:
    """A single expected vulnerability finding."""
    queryName: str = ""
    severity: str = ""
    line: int = 0
    fileName: str = ""
    resourceType: str = ""
    resourceName: str = ""
    searchKey: str = ""
    searchValue: str = ""
    expectedValue: str = ""
    actualValue: str = ""
    issueType: str = ""
    similarityID: str = ""
    search_line: int = -1

    @classmethod
    def from_kics_result(cls, query_name: str, severity: str, file_entry: dict) -> "ExpectedResultEntry":
        """Build an entry from a KICS scan result file_entry."""
        return cls(
            queryName=query_name,
            severity=severity,
            line=file_entry.get("line", 0),
            fileName=os.path.basename(file_entry.get("file_name", "")),
            resourceType=file_entry.get("resource_type", ""),
            resourceName=file_entry.get("resource_name", ""),
            searchKey=file_entry.get("search_key", ""),
            searchValue=file_entry.get("search_value", ""),
            expectedValue=file_entry.get("expected_value", ""),
            actualValue=file_entry.get("actual_value", ""),
            issueType=file_entry.get("issue_type", ""),
            similarityID=file_entry.get("similarity_id", ""),
            search_line=file_entry.get("search_line", -1),
        )

    def to_ordered_dict(self) -> dict:
        """Return a dict with keys in FIELD_ORDER."""
        return {k: getattr(self, k) for k in FIELD_ORDER}

    def sort_key(self) -> tuple:
        return (
            natural_sort_key(self.fileName),
            self.line,
            self.searchKey,
            self.searchValue,
            self.resourceType,
            self.resourceName,
            self.queryName,
            self.expectedValue,
            self.actualValue,
            self.issueType,
            self.similarityID,
            self.search_line,
        )
