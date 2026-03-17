"""
Fix incorrect issueType values in positive_expected_result.json for specific failing queries.

Runs a KICS scan for each failing query, extracts the correct issueType per result
from the scan output, and patches the existing positive_expected_result.json files
without touching any other field.

Usage:
    python fix_issue_types.py          # run fixes
    python fix_issue_types.py --dry    # dry run (report only, no writes)
"""

import json
import subprocess
import sys
import tempfile
from pathlib import Path

KICS_ROOT = Path(__file__).resolve().parents[3]
ASSETS_QUERIES_DIR = KICS_ROOT / "assets" / "queries"
GO_ENTRY_POINT = str(KICS_ROOT / "cmd" / "console" / "main.go")

FAILING_QUERIES = [
    "ansible/aws/instance_uses_metadata_service_IMDSv1",
    "terraform/nifcloud/load_balancer_use_insecure_tls_policy_name",
    "azureResourceManager/sql_server_database_without_auditing",
    "azureResourceManager/storage_logging_for_read_write_delete_requests_disabled",
    "azureResourceManager/website_with_client_certificate_auth_disabled",
    "openAPI/2.0/security_definitions_undefined_or_empty",
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
    "terraform/azure/backup_vault_without_immutability",
    "terraform/azure/diagnostic_settings_without_appropriate_logging",
    "terraform/azure/recovery_services_vaut_with_public_network_access",
    "terraform/azure/recovery_services_vaut_without_immutability",
    "terraform/azure/storage_account_not_using_latest_smb_protocol_version",
    "terraform/azure/storage_account_using_unsafe_smb_channel_encryption",
    "terraform/azure/storage_account_with_shared_access_key",
    "terraform/azure/storage_account_without_delete_lock",
    "terraform/azure/vm_without_encryption_at_host",
    "k8s/image_pull_policy_of_container_is_not_always",
    "openAPI/general/path_parameter_not_required",
    "terraform/aws/api_gateway_access_logging_disabled",
    "terraform/aws/auto_scaling_group_with_no_associated_elb",
    "terraform/aws/glue_security_configuration_encryption_disabled",
    "terraform/aws/msk_cluster_encryption_disabled",
    "terraform/aws/msk_cluster_logging_disabled",
    "terraform/aws/rds_with_backup_disabled",
    "terraform/aws/sns_topic_not_encrypted",
    "cloudFormation/aws/elb_with_security_group_without_outbound_rules",
    "cloudFormation/aws/elb_without_secure_protocol",
    "cloudFormation/aws/neptune_logging_is_disabled",
    "cloudFormation/aws/secretsmanager_secret_without_kms",
    "dockerfile/apt_get_install_pin_version_not_defined",
]


def get_query_id(query_dir: Path) -> str:
    with open(query_dir / "metadata.json", "r", encoding="utf-8") as f:
        return json.load(f)["id"]


def run_scan(query_dir: Path, query_id: str) -> dict | None:
    """Run KICS scan and return the parsed JSON results."""
    with tempfile.TemporaryDirectory() as tmpdir:
        test_path = str(query_dir / "test")
        payload_path = str(query_dir / "payloads")
        output_file = Path(tmpdir) / "results.json"

        cmd = [
            "go", "run", GO_ENTRY_POINT, "scan",
            "-p", test_path,
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

        if not output_file.is_file():
            return None

        with open(output_file, "r", encoding="utf-8") as f:
            return json.load(f)


def build_issue_type_map(scan_data: dict) -> dict[tuple, str]:
    """Build a map from (filename, line) -> issue_type from scan results."""
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
                    # Primary key: (filename, line)
                    it_map[(filename, line)] = issue_type
                    # Fallback key with more specificity
                    it_map[(filename, line, expected_value, actual_value)] = issue_type

    return it_map


def find_expected_result_files(query_dir: Path) -> list[Path]:
    test_dir = query_dir / "test"
    if not test_dir.is_dir():
        return []
    return sorted(test_dir.rglob("positive_expected_result.json"))


def patch_expected_results(query_dir: Path, it_map: dict[tuple, str], dry: bool) -> dict:
    stats = {"fixed": 0, "unchanged": 0, "not_found": 0}

    for rf in find_expected_result_files(query_dir):
        with open(rf, "r", encoding="utf-8") as f:
            entries = json.load(f)

        if not isinstance(entries, list):
            continue

        modified = False
        for entry in entries:
            filename = entry.get("filename", "")
            line = entry.get("line", 0)
            expected_value = entry.get("expectedValue", "")
            actual_value = entry.get("actualValue", "")
            current_it = entry.get("issueType", "")

            # Try specific key first, then fallback
            correct_it = it_map.get(
                (filename, line, expected_value, actual_value),
                it_map.get((filename, line))
            )

            if correct_it is None:
                stats["not_found"] += 1
                continue

            if current_it != correct_it:
                entry["issueType"] = correct_it
                stats["fixed"] += 1
                modified = True
            else:
                stats["unchanged"] += 1

        if modified and not dry:
            with open(rf, "w", encoding="utf-8") as f:
                json.dump(entries, f, indent=2, ensure_ascii=False)
                f.write("\n")

    return stats


def main() -> None:
    dry = "--dry" in sys.argv
    if dry:
        print("=== DRY RUN ===\n")

    total = len(FAILING_QUERIES)
    total_fixed = 0
    total_not_found = 0
    failed_scans = []

    for i, q in enumerate(FAILING_QUERIES, 1):
        query_dir = ASSETS_QUERIES_DIR / q
        if not query_dir.is_dir():
            print(f"[{i}/{total}] SKIP (not found): {q}")
            continue

        query_id = get_query_id(query_dir)
        print(f"[{i}/{total}] Scanning: {q} (id={query_id})")

        scan_data = run_scan(query_dir, query_id)
        if scan_data is None:
            print(f"  ERROR: scan produced no output")
            failed_scans.append(q)
            continue

        it_map = build_issue_type_map(scan_data)
        if not it_map:
            print(f"  WARNING: no results from scan")
            failed_scans.append(q)
            continue

        stats = patch_expected_results(query_dir, it_map, dry)
        total_fixed += stats["fixed"]
        total_not_found += stats["not_found"]

        if stats["fixed"]:
            print(f"  Fixed {stats['fixed']} entries (unchanged: {stats['unchanged']})")
        else:
            print(f"  No changes needed (unchanged: {stats['unchanged']})")

        if stats["not_found"]:
            print(f"  WARNING: {stats['not_found']} entries could not be matched")

    print(f"\n{'='*60}")
    print(f"Total fixed      : {total_fixed}")
    print(f"Not matched      : {total_not_found}")
    print(f"Failed scans     : {len(failed_scans)}")

    if failed_scans:
        print("\nFailed scans:")
        for q in failed_scans:
            print(f"  - {q}")
        sys.exit(1)


if __name__ == "__main__":
    main()
