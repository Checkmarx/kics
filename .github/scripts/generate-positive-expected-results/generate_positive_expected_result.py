import argparse
import json
import os
import re
import subprocess
import sys

FIELD_ORDER = [
    "queryName", "severity", "line", "fileName",
    "resourceType", "resourceName", "searchKey", "searchValue",
    "expectedValue", "actualValue", "issueType", "similarityID", "search_line",
]

KICS_RESULT_CODES = {0, 1, 20, 30, 40, 50, 60}


def _natural_sort_key(s: str):
    """'positive2.tf' → ['positive', 2, '.tf'] so numeric parts sort numerically."""
    return [int(c) if c.isdigit() else c for c in re.split(r'(\d+)', s)]


SCRIPT_DIR  = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT   = os.path.normpath(os.path.join(SCRIPT_DIR, "../../.."))
QUERIES_DIR = os.path.join(REPO_ROOT, "assets", "queries")


def parse_args():
    parser = argparse.ArgumentParser(description="Run a KICS scan for a given query.")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--run-all", action="store_true", help="Run scans for all queries under assets/queries.")
    group.add_argument("--queryID", help="The query ID to scan.")
    parser.add_argument("--queryPath", help="The base path of the query (required without --run-all).")
    return parser.parse_args()


def build_command(query_id: str, scan_path: str, payload_path: str, output_path: str, output_name: str) -> list[str]:
    main_go = os.path.join(REPO_ROOT, "cmd", "console", "main.go")

    return [
        "go", "run", main_go,
        "scan",
        "-p", scan_path,
        "-o", output_path,
        "--output-name", output_name,
        "-i", query_id,
        "-d", payload_path,
        "-v",
        "--experimental-queries",
        "--bom",
        "--enable-openapi-refs",
        "--kics_compute_new_simid"
    ]


def run_scan(query_id: str, scan_path: str, payload_path: str, output_path: str, output_name: str) -> int:
    command = build_command(query_id, scan_path, payload_path, output_path, output_name)

    print("Running command:")
    print(" ".join(command))
    print("-" * 60)

    try:
        result = subprocess.run(command, cwd=REPO_ROOT)
        if result.returncode not in KICS_RESULT_CODES:
            print(f"\n[ERROR] Scan failed with return code {result.returncode}.", file=sys.stderr)
        return result.returncode
    except FileNotFoundError:
        print("\n[ERROR] 'go' not found. Make sure Go is installed and in your PATH.", file=sys.stderr)
        return 1


def find_positive_tests(query_path: str) -> list[tuple[str, str]]:
    """
    Return a sorted list of (label, scan_path) for each positive test in test/.

    Handles two layouts:
      - File:      test/positiveX.<ext>  → label='positiveX_<ext>',  scan_path=the file
      - Directory: test/positiveX/       → for each positiveX_Y.<ext> inside,
                                           label='positiveX_Y_<ext>', scan_path=the file

    The extension is always included in the label so that files with the same
    base name but different extensions (e.g. positive1.json / positive1.yaml)
    produce distinct payloads and result files.
    """
    test_dir = os.path.join(query_path, "test")
    if not os.path.isdir(test_dir):
        return []

    positives = []
    for entry in os.listdir(test_dir):
        if not entry.startswith("positive"):
            continue
        full_path = os.path.join(test_dir, entry)
        if os.path.isdir(full_path):
            # Directory: positiveX/ — scan each file inside individually
            for file in os.listdir(full_path):
                file_path = os.path.join(full_path, file)
                if not os.path.isfile(file_path):
                    continue
                base_label = os.path.splitext(file)[0]      # e.g. 'positive2_1'
                after = base_label[len("positive"):]
                if not after or not after[0].isdigit():      # skip positive_expected_result etc.
                    continue
                ext = os.path.splitext(file)[1].lstrip(".")  # e.g. 'json', 'yaml', 'tf'
                positives.append((f"{base_label}_{ext}", file_path))
        else:
            # File: positive.<ext> or positiveX.<ext>
            suffix = entry[len("positive"):].split(".")[0]
            if suffix and not suffix.isdigit():
                continue  # skip positive_expected_result.json etc.
            ext = os.path.splitext(entry)[1].lstrip(".")     # e.g. 'json', 'yaml', 'tf'
            positives.append((f"positive{suffix}_{ext}", full_path))

    positives.sort(key=lambda x: _natural_sort_key(x[0]))
    return positives


def run_query_scans(query_id: str, query_path: str) -> tuple[list[tuple[str, str, int]], bool]:
    positives = find_positive_tests(query_path)
    if not positives:
        print(f"[WARN] No positive tests found in {query_path}/test, skipping.", file=sys.stderr)
        return [], False

    payloads_dir = os.path.join(query_path, "payloads")
    os.makedirs(payloads_dir, exist_ok=True)

    output_path = os.path.join(query_path, "results") + os.sep
    os.makedirs(output_path, exist_ok=True)

    failed = []
    for label, scan_path in positives:
        payload_path = os.path.join(payloads_dir, f"{label}.json")
        output_name  = f"{label}.json"
        print(f"\n  -> {label}: {os.path.relpath(scan_path, REPO_ROOT)}")
        rc = run_scan(query_id, scan_path, payload_path, output_path, output_name)
        if rc not in KICS_RESULT_CODES:
            failed.append((scan_path, payload_path, rc))

    written = collect_and_write_expected_results(query_path)
    return failed, written


def collect_and_write_expected_results(query_path: str) -> bool:
    """
    Read all positive*.json result files from results/, extract findings,
    sort by (fileName, line, issueType, searchKey, similarityID), and write
    test/positive_expected_result.json. Returns True if the file was written.
    """
    results_dir = os.path.join(query_path, "results")
    if not os.path.isdir(results_dir):
        return False

    entries = []
    for filename in sorted(os.listdir(results_dir)):
        if not filename.startswith("positive") or not filename.endswith(".json"):
            continue
        with open(os.path.join(results_dir, filename), encoding="utf-8") as f:
            data = json.load(f)

        all_findings = data.get("queries", []) + data.get("bill_of_materials", [])
        for query in all_findings:
            query_name = query.get("query_name", "")
            severity   = query.get("severity", "")
            for file_entry in query.get("files", []):
                entry = {
                    "queryName":    query_name,
                    "severity":     severity,
                    "line":         file_entry.get("line", 0),
                    "fileName":     os.path.basename(file_entry.get("file_name", "")),
                    "resourceType": file_entry.get("resource_type", ""),
                    "resourceName": file_entry.get("resource_name", ""),
                    "searchKey":    file_entry.get("search_key", ""),
                    "searchValue":  file_entry.get("search_value", ""),
                    "expectedValue":file_entry.get("expected_value", ""),
                    "actualValue":  file_entry.get("actual_value", ""),
                    "issueType":    file_entry.get("issue_type", ""),
                    "similarityID": file_entry.get("similarity_id", ""),
                    "search_line":  file_entry.get("search_line", 0),
                }
                entries.append({k: entry[k] for k in FIELD_ORDER})

    if not entries:
        return False

    entries.sort(key=lambda x: (
        _natural_sort_key(x["fileName"]), x["line"], x["issueType"], x["searchKey"], x["similarityID"]
    ))

    out_path = os.path.join(query_path, "test", "positive_expected_result.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(entries, f, indent=2)
        f.write("\n")

    print(f"  -> Written {len(entries)} entries to {os.path.relpath(out_path, REPO_ROOT)}")
    return True


def iter_queries():
    """Yield (query_id, query_path) for every query found under assets/queries."""
    for dirpath, _, filenames in os.walk(QUERIES_DIR):
        if "metadata.json" not in filenames:
            continue
        metadata = os.path.join(dirpath, "metadata.json")
        with open(metadata, encoding="utf-8") as f:
            data = json.load(f)
        query_id = data.get("id")
        if not query_id:
            print(f"[WARN] No 'id' field in {metadata}, skipping.", file=sys.stderr)
            continue
        yield query_id, dirpath


def main():
    args = parse_args()

    if args.run_all:
        all_failed    = []
        written_count = 0
        queries = list(iter_queries())
        total   = len(queries)
        width   = len(str(total))
        print(f"Found {total} queries. Starting scans...\n")
        for idx, (query_id, query_path) in enumerate(queries, start=1):
            print(f"\n[{idx:{width}d}/{total}] {os.path.relpath(query_path, REPO_ROOT)}")
            failed, written = run_query_scans(query_id, query_path)
            all_failed.extend(failed)
            if written:
                written_count += 1

        print("\n" + "=" * 60)
        print(f"[SUMMARY] {written_count}/{total} positive_expected_result.json written")
        if all_failed:
            print(f"          {len(all_failed)} scan(s) failed:")
            for scan_path, payload_path, rc in all_failed:
                print(f"  - {os.path.relpath(scan_path, REPO_ROOT)} → exit {rc}")
            sys.exit(1)
        else:
            print("          All scans completed successfully.")
            sys.exit(0)
    else:
        if not args.queryPath:
            print("[ERROR] --queryPath is required when not using --run-all.", file=sys.stderr)
            sys.exit(1)
        query_path = os.path.normpath(os.path.join(REPO_ROOT, args.queryPath))
        failed, _ = run_query_scans(args.queryID, query_path)
        sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
