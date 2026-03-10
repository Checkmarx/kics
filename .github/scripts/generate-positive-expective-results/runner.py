import json
import subprocess
import sys
from pathlib import Path

from generate import build_test_list
from models import QueryInfo, ResultInfo, TestList

KICS_ROOT = Path(__file__).resolve().parents[3]
GO_ENTRY_POINT = str(KICS_ROOT / "cmd" / "console" / "main.go")


def build_command(query: QueryInfo) -> list[str]:
    """Build the go run scan command for a single query."""
    return [
        "go", "run", GO_ENTRY_POINT, "scan",
        "-p", query.test_path,
        "-o", query.results_file_path,
        "--output-name", "all_results.json",
        "-i", query.id,
        "-d", f"{query.payload_path}/all_payloads.json",
        "-v",
        "--experimental-queries",
        "--bom",
        "--enable-openapi-refs"
    ]


def parse_results(query: QueryInfo) -> list[ResultInfo]:
    """Read all_results.json and extract ResultInfo entries for positive files."""
    results_file = Path(query.results_file_path) / "all_results.json"
    if not results_file.is_file():
        return []

    with open(results_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    results: list[ResultInfo] = []

    bom_entries = data.get("bill_of_materials", [])
    query_entries = data.get("queries", [])

    if bom_entries:
        query.is_bom = True

    all_entries = bom_entries if bom_entries else query_entries
    for q in all_entries:
        query_name = q.get("query_name", "")
        severity = q.get("severity", "")

        for file_entry in q.get("files", []):
            filename = Path(file_entry.get("file_name", "")).name

            results.append(ResultInfo(
                query_name=query_name,
                severity=severity,
                line=str(file_entry.get("line", "")),
                filename=filename,
                resource_type=file_entry.get("resource_type", ""),
                resource_name=file_entry.get("resource_name", ""),
                search_key=file_entry.get("search_key", ""),
                search_value=file_entry.get("search_value", ""),
                expected_value=file_entry.get("expected_value", ""),
                actual_value=file_entry.get("actual_value", ""),
            ))

    return results


def run_all() -> TestList:
    """Run scans for all queries and return TestList with results_info populated."""
    test_list = build_test_list()
    total = len(test_list.queries_list)
    failed = []

    print(f"Running scan for {total} queries...\n")

    for i, query in enumerate(test_list.queries_list, start=1):
        cmd = build_command(query)
        print(f"[{i}/{total}] Scanning query {query.id}")
        print(f"  Command: {' '.join(cmd)}\n")

        result = subprocess.run(cmd, cwd=str(KICS_ROOT))
        query.return_code = result.returncode

        if result.returncode != 0:
            failed.append(query.id)
            print(f"  ⚠ Query {query.id} exited with code {result.returncode}\n")
        else:
            print(f"  ✓ Query {query.id} completed successfully\n")

        # Populate results_info from the generated all_results.json
        query.results_info = parse_results(query)

    print(f"\n{'='*60}")
    print(f"Finished: {total - len(failed)}/{total} succeeded, {len(failed)} failed")

    if failed:
        print("\nFailed queries:")
        for qid in failed:
            print(f"  - {qid}")

    return test_list


if __name__ == "__main__":
    run_all()
