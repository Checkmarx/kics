import json
from pathlib import Path

from models import TestList
from runner import run_all


def deduplicate_results(results: list[dict]) -> list[dict]:
    """Remove duplicate results, keeping only the first occurrence of each unique result."""
    seen = set()
    deduplicated = []
    for result in results:
        result_tuple = (
            result["queryName"],
            result["severity"],
            result["line"],
            result["filename"],
            result["resourceType"],
            result["resourceName"],
            result["searchKey"],
            result["searchValue"],
            result["expectedValue"],
            result["actualValue"],
        )
        if result_tuple not in seen:
            seen.add(result_tuple)
            deduplicated.append(result)
    return deduplicated


def _get_subdir_filenames(test_dir: Path) -> dict[str, Path]:
    """Build a mapping of filename -> subdirectory path for files inside positive subdirectories.

    Some test directories contain positive test subdirectories (e.g. positive2/) that have their
    own files and their own positive_expected_result.json. This function maps filenames found
    inside those subdirectories so results can be routed to the correct location.
    """
    filename_to_subdir: dict[str, Path] = {}
    for item in test_dir.iterdir():
        if item.is_dir() and item.name.startswith("positive"):
            for child in item.iterdir():
                if child.is_file() and child.name != "positive_expected_result.json":
                    filename_to_subdir[child.name] = item
    return filename_to_subdir


def _write_results_file(output_file: Path, results: list[dict]) -> None:
    """Deduplicate, sort, and write results to a positive_expected_result.json file."""
    results = deduplicate_results(results)
    results.sort(key=lambda r: (
        r["filename"],
        r["line"] if isinstance(r["line"], int) else 0,
    ))
    output_file.parent.mkdir(parents=True, exist_ok=True)
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)


def write_positive_expected_results(test_list: TestList) -> None:
    """For each query, write positive_expected_result.json in the test_path directory.

    When a test directory contains positive subdirectories (e.g. positive2/), results
    for files inside those subdirectories are written to the subdirectory's own
    positive_expected_result.json instead of the top-level one.
    """
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

        # Map filenames inside positive subdirectories to their subdirectory
        subdir_filenames = _get_subdir_filenames(test_dir)

        # Route results: top-level vs subdirectory
        top_level_results: list[dict] = []
        subdir_results: dict[str, list[dict]] = {}

        for ri in query.results_info:
            result = {
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
            }

            if ri.filename in subdir_filenames:
                subdir_path = str(subdir_filenames[ri.filename])
                subdir_results.setdefault(subdir_path, []).append(result)
            else:
                top_level_results.append(result)

        # Write top-level positive_expected_result.json
        if top_level_results:
            output_file = test_dir / "positive_expected_result.json"
            _write_results_file(output_file, top_level_results)
            print(f"[{i}/{total}] Wrote {output_file} ({len(top_level_results)} results)")
            written += 1

        # Write subdirectory positive_expected_result.json files
        for subdir_path, results in subdir_results.items():
            output_file = Path(subdir_path) / "positive_expected_result.json"
            _write_results_file(output_file, results)
            print(f"[{i}/{total}] Wrote {output_file} ({len(results)} results)")
            written += 1

        if not top_level_results and not subdir_results:
            print(f"[{i}/{total}] Skipping query {query.id} — no results after routing")
            skipped += 1

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
