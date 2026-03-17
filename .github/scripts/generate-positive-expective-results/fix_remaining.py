"""
Fix the remaining queries that failed in fix_issue_types.py:
- activity_log_alert queries: need per-subdirectory scans
- elb_with_security_group_without_outbound_rules: unmatched entries
- activity_log_alert_for_service_health_not_configured: unmatched entries

Usage:
    python fix_remaining.py
    python fix_remaining.py --dry
"""

import json
import subprocess
import sys
import tempfile
from pathlib import Path

KICS_ROOT = Path(__file__).resolve().parents[3]
ASSETS_QUERIES_DIR = KICS_ROOT / "assets" / "queries"
GO_ENTRY_POINT = str(KICS_ROOT / "cmd" / "console" / "main.go")

REMAINING_QUERIES = [
    "terraform/azure/activity_log_alert_for_create_or_update_network_security_group_not_configured",
    "terraform/azure/activity_log_alert_for_create_or_update_public_ip_address_rule_not_configured",
    "terraform/azure/activity_log_alert_for_create_or_update_security_solution_not_configured",
    "terraform/azure/activity_log_alert_for_create_or_update_sql_server_firewall_rule_not_configured",
    "terraform/azure/activity_log_alert_for_create_policy_assignment_not_configured",
    "terraform/azure/activity_log_alert_for_delete_network_security_group_not_configured",
    "terraform/azure/activity_log_alert_for_delete_policy_assignment_not_configured",
    "terraform/azure/activity_log_alert_for_delete_public_ip_address_rule_not_configured",
    "terraform/azure/activity_log_alert_for_delete_security_solution_not_configured",
    "terraform/azure/activity_log_alert_for_delete_sql_server_firewall_rule_not_configured",
    "terraform/azure/activity_log_alert_for_service_health_not_configured",
    "cloudFormation/aws/elb_with_security_group_without_outbound_rules",
]


def get_query_id(query_dir: Path) -> str:
    with open(query_dir / "metadata.json", "r", encoding="utf-8") as f:
        return json.load(f)["id"]


def run_scan(scan_path: str, query_id: str, payload_path: str) -> dict | None:
    with tempfile.TemporaryDirectory() as tmpdir:
        cmd = [
            "go", "run", GO_ENTRY_POINT, "scan",
            "-p", scan_path,
            "-o", tmpdir,
            "--output-name", "results.json",
            "-i", query_id,
            "-d", f"{payload_path}/all_payloads.json",
            "-v",
            "--experimental-queries",
            "--bom",
            "--enable-openapi-refs",
        ]
        subprocess.run(cmd, cwd=str(KICS_ROOT), capture_output=True)
        output_file = Path(tmpdir) / "results.json"
        if not output_file.is_file():
            return None
        with open(output_file, "r", encoding="utf-8") as f:
            return json.load(f)


def build_issue_type_map(scan_data: dict) -> dict[tuple, str]:
    it_map: dict[tuple, str] = {}
    for section in ("queries", "bill_of_materials"):
        for q in scan_data.get(section, []):
            for f in q.get("files", []):
                file_path = Path(f.get("file_name", ""))
                filename = file_path.name
                line = f.get("line", 0)
                issue_type = f.get("issue_type", "")
                expected_value = f.get("expected_value", "")
                actual_value = f.get("actual_value", "")
                if issue_type:
                    it_map[(filename, line)] = issue_type
                    it_map[(filename, line, expected_value, actual_value)] = issue_type
    return it_map


def get_scan_dirs(test_dir: Path) -> list[tuple[Path, Path | None]]:
    """Return list of (scan_dir, expected_result_file) pairs.

    For queries with positive subdirectories (positive2/, positive3/),
    we need to scan each subdirectory separately.
    Also scan top-level for the main positive_expected_result.json.
    """
    pairs = []

    # Top-level: scan the whole test dir but only match top-level expected results
    top_expected = test_dir / "positive_expected_result.json"
    if top_expected.is_file():
        # Scan only the top-level positive files (not in subdirs)
        pairs.append((test_dir, top_expected))

    # Subdirectories with their own positive_expected_result.json
    for subdir in sorted(test_dir.iterdir()):
        if subdir.is_dir() and subdir.name.startswith("positive"):
            sub_expected = subdir / "positive_expected_result.json"
            if sub_expected.is_file():
                pairs.append((subdir, sub_expected))

    return pairs


def patch_file(expected_file: Path, it_map: dict[tuple, str], dry: bool) -> dict:
    stats = {"fixed": 0, "unchanged": 0, "not_found": 0}

    with open(expected_file, "r", encoding="utf-8") as f:
        entries = json.load(f)

    if not isinstance(entries, list):
        return stats

    modified = False
    for entry in entries:
        filename = entry.get("filename", "")
        line = entry.get("line", 0)
        expected_value = entry.get("expectedValue", "")
        actual_value = entry.get("actualValue", "")
        current_it = entry.get("issueType", "")

        correct_it = it_map.get(
            (filename, line, expected_value, actual_value),
            it_map.get((filename, line))
        )

        if correct_it is None:
            stats["not_found"] += 1
            print(f"    NOT FOUND: {filename}:{line}")
            continue

        if current_it != correct_it:
            entry["issueType"] = correct_it
            stats["fixed"] += 1
            modified = True
        else:
            stats["unchanged"] += 1

    if modified and not dry:
        with open(expected_file, "w", encoding="utf-8") as f:
            json.dump(entries, f, indent=2, ensure_ascii=False)
            f.write("\n")

    return stats


def process_query(query_path: str, dry: bool) -> dict:
    query_dir = ASSETS_QUERIES_DIR / query_path
    query_id = get_query_id(query_dir)
    test_dir = query_dir / "test"
    payload_path = str(query_dir / "payloads")

    total_stats = {"fixed": 0, "unchanged": 0, "not_found": 0}

    scan_pairs = get_scan_dirs(test_dir)

    for scan_dir, expected_file in scan_pairs:
        scan_data = run_scan(str(scan_dir), query_id, payload_path)
        if scan_data is None:
            print(f"  No scan output for {scan_dir.name}")
            continue

        it_map = build_issue_type_map(scan_data)
        if not it_map:
            print(f"  No results for {scan_dir.name}")
            continue

        stats = patch_file(expected_file, it_map, dry)
        for k in total_stats:
            total_stats[k] += stats[k]

    return total_stats


def main():
    dry = "--dry" in sys.argv
    if dry:
        print("=== DRY RUN ===\n")

    total_fixed = 0
    total_not_found = 0
    total = len(REMAINING_QUERIES)

    for i, q in enumerate(REMAINING_QUERIES, 1):
        print(f"[{i}/{total}] {q}")
        stats = process_query(q, dry)
        total_fixed += stats["fixed"]
        total_not_found += stats["not_found"]

        if stats["fixed"]:
            print(f"  Fixed {stats['fixed']} (unchanged: {stats['unchanged']})")
        else:
            print(f"  No changes (unchanged: {stats['unchanged']})")

    print(f"\n{'='*60}")
    print(f"Total fixed  : {total_fixed}")
    print(f"Not matched  : {total_not_found}")


if __name__ == "__main__":
    main()
