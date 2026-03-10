#!/usr/bin/env python3
"""
Run scans for skipped queries individually (per test file) and write positive_expected_result.json.

For queries that returned no results when scanning the whole test directory, this script
re-runs the scan once per individual positive test file so the query engine can isolate
matches that it misses when all files are scanned together.

Usage:
    python run_skipped.py [path/to/skipped_queries_report.json]

Defaults to skipped_queries_report.json in the same directory as this script.
"""

import json
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR))

from write_expected_results import deduplicate_results

KICS_ROOT = Path(__file__).resolve().parents[3]
GO_ENTRY_POINT = str(KICS_ROOT / "cmd" / "console" / "main.go")
DEFAULT_SKIPPED_REPORT = SCRIPT_DIR / "skipped_queries_report.json"


def get_positive_test_files(test_path: Path) -> list[Path]:
    """Return all positive test files/dirs in the test dir (excluding positive_expected_result.json)."""
    positives = []
    for item in sorted(test_path.iterdir()):
        if item.name.startswith("positive") and item.name != "positive_expected_result.json":
            positives.append(item)
    return positives


def get_payload_for_test(test_file: Path, payload_dir: Path) -> Path:
    """Return the individual payload file for a test file, falling back to all_payloads.json."""
    stem = test_file.stem if test_file.is_file() else test_file.name
    individual = payload_dir / f"{stem}_payload.json"
    if individual.is_file():
        return individual
    return payload_dir / "all_payloads.json"


def run_individual_scan(
    query_id: str,
    test_file: Path,
    results_dir: Path,
    payload_file: Path,
) -> tuple[Path, int]:
    """Run a scan on a single test file/dir. Returns (output_file_path, return_code)."""
    stem = test_file.stem if test_file.is_file() else test_file.name
    output_name = f"{stem}_results.json"
    output_file = results_dir / output_name

    results_dir.mkdir(parents=True, exist_ok=True)

    cmd = [
        "go", "run", GO_ENTRY_POINT, "scan",
        "-p", str(test_file),
        "-o", str(results_dir),
        "--output-name", output_name,
        "-i", query_id,
        "-d", str(payload_file),
        "-v",
        "--experimental-queries",
        "--bom",
        "--enable-openapi-refs",
    ]

    print(f"    $ {' '.join(cmd)}")
    result = subprocess.run(cmd, cwd=str(KICS_ROOT))
    return output_file, result.returncode


def parse_results_from_file(results_file: Path) -> list[dict]:
    """Parse a scan result JSON file and return a list of result dicts."""
    if not results_file.is_file():
        return []

    with open(results_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    results = []
    bom_entries = data.get("bill_of_materials", [])
    query_entries = data.get("queries", [])
    all_entries = bom_entries if bom_entries else query_entries

    for q in all_entries:
        query_name = q.get("query_name", "")
        severity = q.get("severity", "")
        for file_entry in q.get("files", []):
            filename = Path(file_entry.get("file_name", "")).name
            results.append({
                "queryName": query_name,
                "severity": severity,
                "line": file_entry.get("line", ""),
                "filename": filename,
                "resourceType": file_entry.get("resource_type", ""),
                "resourceName": file_entry.get("resource_name", ""),
                "searchKey": file_entry.get("search_key", ""),
                "searchValue": file_entry.get("search_value", ""),
                "expectedValue": file_entry.get("expected_value", ""),
                "actualValue": file_entry.get("actual_value", ""),
            })

    return results


def process_skipped_query(query: dict) -> list[dict]:
    """Run per-file scans for a skipped query and return aggregated results."""
    query_id = query["id"]
    test_path = Path(query["test_path"])
    results_dir = Path(query["results_file_path"])
    payload_dir = test_path.parent / "payloads"

    print(f"  Test path : {test_path}")

    if not test_path.is_dir():
        print(f"  ⚠ Test directory not found")
        return []

    positive_files = get_positive_test_files(test_path)
    if not positive_files:
        print(f"  ⚠ No positive test files found")
        return []

    print(f"  Positive files: {[f.name for f in positive_files]}")

    all_results = []
    for test_file in positive_files:
        payload_file = get_payload_for_test(test_file, payload_dir)
        print(f"\n  [{test_file.name}] payload → {payload_file.name}")

        output_file, return_code = run_individual_scan(
            query_id=query_id,
            test_file=test_file,
            results_dir=results_dir,
            payload_file=payload_file,
        )

        if return_code != 0:
            print(f"  ⚠ Scan failed with return code {return_code}")
        else:
            print(f"  ✓ Scan completed")

        file_results = parse_results_from_file(output_file)
        print(f"    → {len(file_results)} result(s) found")
        all_results.extend(file_results)

    return all_results


def write_positive_expected_result(test_path: Path, results: list[dict]) -> None:
    """Deduplicate, sort, and write positive_expected_result.json to the test directory."""
    results = deduplicate_results(results)
    results.sort(key=lambda r: (
        r["filename"],
        r["line"] if isinstance(r["line"], int) else 0,
    ))

    output_file = test_path / "positive_expected_result.json"
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)

    print(f"\n  ✓ Written: {output_file} ({len(results)} result(s))")


def main() -> None:
    report_path = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_SKIPPED_REPORT

    if not report_path.is_file():
        print(f"Error: report file not found: {report_path}", file=sys.stderr)
        sys.exit(1)

    with open(report_path, "r", encoding="utf-8") as f:
        skipped_queries = json.load(f)

    total = len(skipped_queries)
    print(f"Processing {total} skipped quer{'y' if total == 1 else 'ies'} from: {report_path}")
    print("=" * 60)

    still_skipped = []

    for i, query in enumerate(skipped_queries, start=1):
        print(f"\n[{i}/{total}] Query: {query['id']}")
        results = process_skipped_query(query)

        if not results:
            print(f"  ⚠ No results produced — skipping positive_expected_result.json")
            still_skipped.append(query["id"])
            continue

        write_positive_expected_result(Path(query["test_path"]), results)

    print(f"\n{'=' * 60}")
    succeeded = total - len(still_skipped)
    print(f"Done: {succeeded}/{total} queries updated successfully")

    if still_skipped:
        print(f"\nStill produced no results ({len(still_skipped)}):")
        for qid in still_skipped:
            print(f"  - {qid}")


if __name__ == "__main__":
    main()
