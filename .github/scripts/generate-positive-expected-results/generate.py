import json
from pathlib import Path

import models


ASSETS_QUERIES_DIR = Path(__file__).resolve().parents[3] / "assets" / "queries"
EXCLUDED_DIRS: set[str] = set()


def is_query_directory(path: Path) -> bool:
    """A directory is a query if it contains metadata.json and either query.rego or regex_rules.json."""
    if not (path / "metadata.json").is_file():
        return False
    return (path / "query.rego").is_file() or (path / "regex_rules.json").is_file()


def extract_query_id(metadata_path: Path) -> str:
    """Read the 'id' field from the query's metadata.json."""
    with open(metadata_path, "r", encoding="utf-8") as f:
        metadata = json.load(f)
    return metadata["id"]


def build_test_list() -> models.TestList:
    """Walk assets/queries (excluding 'common') and collect QueryInfo for every query found."""
    test_list = models.TestList()

    for query_dir in sorted(ASSETS_QUERIES_DIR.rglob("*")):
        if not query_dir.is_dir():
            continue

        # Skip anything under the 'common' top-level directory
        relative = query_dir.relative_to(ASSETS_QUERIES_DIR)
        if relative.parts[0] in EXCLUDED_DIRS:
            continue

        if not is_query_directory(query_dir):
            continue

        query_id = extract_query_id(query_dir / "metadata.json")

        query_info = models.QueryInfo(
            test_path=str(query_dir / "test"),
            results_file_path=str(query_dir / "results"),
            id=query_id,
            payload_path=str(query_dir / "payloads"),
            results_info=[],
        )

        test_list.queries_list.append(query_info)

    return test_list


if __name__ == "__main__":
    test_list = build_test_list()

    print(f"Total queries found: {len(test_list.queries_list)}\n")
    for qi in test_list.queries_list:
        print(f"  ID:           {qi.id}")
        print(f"  Test path:    {qi.test_path}")
        print(f"  Results path: {qi.results_file_path}")
        print(f"  Payload path: {qi.payload_path}")
        print()
