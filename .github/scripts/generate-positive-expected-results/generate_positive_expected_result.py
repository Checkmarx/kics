import argparse
import json
import os
import shutil
import subprocess
import sys
import tempfile

from models import (
    FIELD_ORDER,
    KICS_RESULT_CODES,
    ExpectedResultEntry,
    PositiveTest,
    ScanFailure,
    natural_sort_key,
)

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
    """Run a KICS scan using a temporary directory that mirrors the assets/queries/
    structure so that the similarity IDs match what the Go tests produce.

    The Go tests use baseScanPaths = ["../assets/queries/"], which means the
    similarity ID hash includes the path relative to the queries root
    (e.g. "terraform/.../test/positive1.tf").  The CLI uses whatever is passed
    to -p as the base, so we create a temp dir that mirrors the structure and
    pass -p <tmpdir> — giving the same relative paths.
    """
    rel_to_queries = os.path.relpath(scan_path, QUERIES_DIR)

    with tempfile.TemporaryDirectory() as tmpdir:
        target_path = os.path.join(tmpdir, rel_to_queries)
        if os.path.isdir(scan_path):
            shutil.copytree(scan_path, target_path)
        else:
            os.makedirs(os.path.dirname(target_path), exist_ok=True)
            shutil.copy2(scan_path, target_path)

        # Copy auxiliary files (e.g. .pem certificates) that positive files
        # may reference via functions like Terraform's file().  We skip other
        # positive/negative test files to avoid duplicate scan results.
        src_dir = os.path.dirname(scan_path)
        dst_dir = os.path.dirname(target_path)
        for name in os.listdir(src_dir):
            if name.startswith("positive") or name.startswith("negative"):
                continue
            src = os.path.join(src_dir, name)
            dst = os.path.join(dst_dir, name)
            if os.path.isfile(src) and not os.path.exists(dst):
                shutil.copy2(src, dst)

        command = build_command(query_id, tmpdir, payload_path, output_path, output_name)

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


def run_directory_scan(query_id: str, scan_paths: list[str], payload_path: str, output_path: str, output_name: str) -> int:
    """Run a KICS scan with all given files copied into a single temporary directory
    that mirrors the assets/queries/ structure, so similarity IDs match.
    """
    if not scan_paths:
        return 0

    # All files share the same parent directory (test/).
    src_dir = os.path.dirname(scan_paths[0])
    rel_dir = os.path.relpath(src_dir, QUERIES_DIR)

    with tempfile.TemporaryDirectory() as tmpdir:
        target_dir = os.path.join(tmpdir, rel_dir)
        os.makedirs(target_dir, exist_ok=True)

        # Copy all positive files.
        for scan_path in scan_paths:
            dst = os.path.join(target_dir, os.path.basename(scan_path))
            shutil.copy2(scan_path, dst)

        # Copy auxiliary files (certificates, etc.) — skip other positive/negative files.
        for name in os.listdir(src_dir):
            if name.startswith("positive") or name.startswith("negative"):
                continue
            src = os.path.join(src_dir, name)
            dst = os.path.join(target_dir, name)
            if os.path.isfile(src) and not os.path.exists(dst):
                shutil.copy2(src, dst)

        command = build_command(query_id, tmpdir, payload_path, output_path, output_name)

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


def find_positive_tests(query_path: str) -> list[PositiveTest]:
    """
    Return a sorted list of PositiveTest for each positive test in test/.

    Handles two layouts:
      - File:      test/positiveX.<ext>  → label='positiveX_<ext>',  scan_path=the file
      - Directory: test/positiveX/       → for each positiveX_Y.<ext> inside,
                                           label='positiveX_Y_<ext>', scan_path=the file

    The extension is always included in the label so that files with the same
    base name but different extensions (e.g. positive1.json / positive1.yaml)
    produce distinct payloads and result files.

    ``group`` mirrors how the Go tests split scans: loose files use "test"
    (results go to test/positive_expected_result.json) while subdirectory
    files use "test/<dir>" (results go to test/<dir>/positive_expected_result.json).
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
                positives.append(PositiveTest(f"{base_label}_{ext}", file_path, f"test/{entry}"))
        else:
            # File: positive.<ext> or positiveX.<ext>
            suffix = entry[len("positive"):].split(".")[0]
            if suffix and not suffix.isdigit():
                continue  # skip positive_expected_result.json etc.
            ext = os.path.splitext(entry)[1].lstrip(".")     # e.g. 'json', 'yaml', 'tf'
            positives.append(PositiveTest(f"positive{suffix}_{ext}", full_path, "test"))

    positives.sort(key=lambda x: natural_sort_key(x.label))
    return positives


def run_query_scans(query_id: str, query_path: str) -> tuple[list[ScanFailure], bool]:
    positives = find_positive_tests(query_path)
    if not positives:
        print(f"[WARN] No positive tests found in {query_path}/test, skipping.", file=sys.stderr)
        return [], False

    # Check for subdirectory tests.
    has_subdir_tests = any(t.group != "test" for t in positives)
    loose_tests = [t for t in positives if t.group == "test"]

    with tempfile.TemporaryDirectory() as tmpdir:
        payloads_dir = os.path.join(tmpdir, "payloads")
        results_dir  = os.path.join(tmpdir, "results")
        os.makedirs(payloads_dir)
        os.makedirs(results_dir)

        label_to_group = {}
        failed = []

        # passwords_and_secrets has too many positive files — only directory scan.
        is_secrets_query = query_path.endswith(os.path.join("common", "passwords_and_secrets"))

        if not has_subdir_tests and loose_tests:
            # No subdirectories: scan all loose files together + each individually.

            # 1. Directory scan (all loose files at once).
            all_paths = [t.scan_path for t in loose_tests]
            dir_label = "directory_scan"
            label_to_group[dir_label] = "test"
            payload_path = os.path.join(payloads_dir, f"{dir_label}.json")
            output_name  = f"{dir_label}.json"
            print(f"\n  -> directory scan: {[os.path.relpath(p, REPO_ROOT) for p in all_paths]}")
            rc = run_directory_scan(query_id, all_paths, payload_path, results_dir + os.sep, output_name)
            if rc not in KICS_RESULT_CODES:
                failed.append(ScanFailure(query_path, payload_path, rc))

            # 2. Individual file scans (skip for passwords_and_secrets).
            if not is_secrets_query:
                for test in loose_tests:
                    label_to_group[test.label] = test.group
                    payload_path = os.path.join(payloads_dir, f"{test.label}.json")
                    output_name  = f"{test.label}.json"
                    print(f"\n  -> {test.label}: {os.path.relpath(test.scan_path, REPO_ROOT)}")
                    rc = run_scan(query_id, test.scan_path, payload_path, results_dir + os.sep, output_name)
                    if rc not in KICS_RESULT_CODES:
                        failed.append(ScanFailure(test.scan_path, payload_path, rc))
        else:
            # Has subdirectories: directory scan for loose files + directory scan per subdirectory.

            # 1. Directory scan for all loose positive files in test/.
            if loose_tests:
                all_loose_paths = [t.scan_path for t in loose_tests]
                dir_label = "directory_scan"
                label_to_group[dir_label] = "test"
                payload_path = os.path.join(payloads_dir, f"{dir_label}.json")
                output_name  = f"{dir_label}.json"
                print(f"\n  -> directory scan (loose): {[os.path.relpath(p, REPO_ROOT) for p in all_loose_paths]}")
                rc = run_directory_scan(query_id, all_loose_paths, payload_path, results_dir + os.sep, output_name)
                if rc not in KICS_RESULT_CODES:
                    failed.append(ScanFailure(query_path, payload_path, rc))

            # 2. For each subdirectory, scan all files inside it together.
            subdir_groups: dict[str, list[PositiveTest]] = {}
            for test in positives:
                if test.group != "test":
                    subdir_groups.setdefault(test.group, []).append(test)

            for group, tests in sorted(subdir_groups.items()):
                all_paths = [t.scan_path for t in tests]
                dir_label = group.replace("/", "_") + "_scan"
                label_to_group[dir_label] = group
                payload_path = os.path.join(payloads_dir, f"{dir_label}.json")
                output_name  = f"{dir_label}.json"
                print(f"\n  -> directory scan ({group}): {[os.path.relpath(p, REPO_ROOT) for p in all_paths]}")
                rc = run_directory_scan(query_id, all_paths, payload_path, results_dir + os.sep, output_name)
                if rc not in KICS_RESULT_CODES:
                    failed.append(ScanFailure(query_path, payload_path, rc))

        written = collect_and_write_expected_results(query_path, results_dir, label_to_group)

    return failed, written


def collect_and_write_expected_results(query_path: str, results_dir: str, label_to_group: dict[str, str]) -> bool:
    """
    Read all positive*.json result files from results_dir, extract findings,
    group them by test group (loose files -> "test", subdirectory files ->
    "test/<dir>"), sort each group, and write the corresponding
    positive_expected_result.json files.

    This mirrors the Go test structure where loose positive files are compared
    against test/positive_expected_result.json and each positive subdirectory
    against test/<dir>/positive_expected_result.json.

    Returns True if at least one file was written.
    """
    if not os.path.isdir(results_dir):
        return False

    grouped_entries: dict[str, list[ExpectedResultEntry]] = {}

    for filename in sorted(os.listdir(results_dir)):
        if not filename.endswith(".json"):
            continue

        label = os.path.splitext(filename)[0]
        if label not in label_to_group:
            continue

        group = label_to_group[label]

        with open(os.path.join(results_dir, filename), encoding="utf-8") as f:
            data = json.load(f)

        all_findings = data.get("queries", []) + data.get("bill_of_materials", [])
        for query in all_findings:
            query_name = query.get("query_name", "")
            severity   = query.get("severity", "")
            for file_entry in query.get("files", []):
                entry = ExpectedResultEntry.from_kics_result(query_name, severity, file_entry)
                grouped_entries.setdefault(group, []).append(entry)

    # Deduplicate entries within each group using all output fields.
    for group in grouped_entries:
        seen = set()
        unique = []
        for entry in grouped_entries[group]:
            key = tuple(getattr(entry, k) for k in FIELD_ORDER)
            if key not in seen:
                seen.add(key)
                unique.append(entry)
        grouped_entries[group] = unique

    if not grouped_entries:
        return False

    # If subdirectory results exist but no loose-file results, still write
    # an empty main expected file — the Go test always reads it.
    if any(g != "test" for g in grouped_entries) and "test" not in grouped_entries:
        grouped_entries["test"] = []

    written_any = False
    for group, entries in grouped_entries.items():
        entries.sort(key=lambda e: e.sort_key())

        out_path = os.path.join(query_path, group, "positive_expected_result.json")
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump([e.to_ordered_dict() for e in entries], f, indent=2)
            f.write("\n")

        print(f"  -> Written {len(entries)} entries to {os.path.relpath(out_path, REPO_ROOT)}")
        written_any = True

    return written_any


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
            for failure in all_failed:
                print(f"  - {os.path.relpath(failure.scan_path, REPO_ROOT)} → exit {failure.return_code}")
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
