import json
from pathlib import Path

from models import TestList
from runner import run_all


def write_positive_expected_results(test_list: TestList) -> None:
    """For each query, write positive_expected_result.json in the test_path directory."""
    total = len(test_list.queries_list)
    written = 0
    skipped = 0

    for i, query in enumerate(test_list.queries_list, start=1):
        if not query.results_info:
            print(f"[{i}/{total}] Skipping query {query.id} — no results")
            skipped += 1
            continue

        test_dir = Path(query.test_path)
        test_dir.mkdir(parents=True, exist_ok=True)

        output_file = test_dir / "positive_expected_result.json"

        expected_results = []
        for ri in query.results_info:
            expected_results.append({
                "queryName": ri.query_name,
                "severity": ri.severity,
                "line": int(ri.line) if ri.line.isdigit() else ri.line,
                "filename": ri.filename,
                "resourceType": ri.resource_type,
                "resourceName": ri.resource_name,
                "searchKey": ri.search_key,
                "searchValue": ri.search_value,
                "expectedValue": ri.expected_value,
                "actualValue": ri.actual_value,
            })

        expected_results.sort(key=lambda r: (
            r["filename"],
            r["line"] if isinstance(r["line"], int) else 0,
        ))

        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(expected_results, f, indent=2, ensure_ascii=False)

        print(f"[{i}/{total}] Wrote {output_file} ({len(expected_results)} results)")
        written += 1

    print(f"\nDone: {written} files written, {skipped} skipped")


def write_skipped_queries_report(test_list: TestList, output_path: str | Path | None = None) -> None:
    """Write a JSON report of queries that produced no results, including the raw scan output."""
    if output_path is None:
        output_path = Path(__file__).resolve().parent / "skipped_queries_report.json"
    else:
        output_path = Path(output_path)

    skipped_queries = []

    for query in test_list.queries_list:
        if query.results_info:
            continue

        raw_results = None
        results_file = Path(query.results_file_path) / "all_results.json"
        if results_file.is_file():
            with open(results_file, "r", encoding="utf-8") as f:
                raw_results = json.load(f)

        skipped_queries.append({
            "id": query.id,
            "test_path": query.test_path,
            "results_file_path": query.results_file_path,
            "return_code": query.return_code,
            "all_results": raw_results,
        })

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(skipped_queries, f, indent=2, ensure_ascii=False)

    print(f"Skipped queries report: {output_path} ({len(skipped_queries)} queries)")


if __name__ == "__main__":
    # 1. Run scans and get TestList with results_info populated
    test_list = run_all()

    # 2. Write positive_expected_result.json for each query
    print(f"\n{'='*60}")
    print("Writing positive_expected_result.json files...\n")
    write_positive_expected_results(test_list)

    # 3. Write skipped queries report
    print(f"\n{'='*60}")
    print("Writing skipped queries report...\n")
    write_skipped_queries_report(test_list)
