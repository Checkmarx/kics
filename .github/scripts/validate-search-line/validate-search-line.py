#!/usr/bin/env python3
"""
Validates searchLine in modified KICS queries.
Receives the list of changed files via CHANGED_QUERIES (JSON array from dorny/paths-filter).

Validations (only run if query.rego defines searchLine):
  1. searchLine must not be hardcoded to -1 in query.rego
  2. In expected result files, searchLine must equal line
"""

import os
import re
import json
import sys
from pathlib import Path

# Script lives at .github/scripts/validate-search-line/
REPO_ROOT = Path(__file__).resolve().parent.parent.parent.parent


def exit_with_error(message):
    print(f"::error::{message}")
    sys.exit(1)


def get_changed_queries():
    """Get changed query.rego directories from CHANGED_QUERIES env var (JSON array from dorny/paths-filter)."""
    changed = os.getenv('CHANGED_QUERIES', '')
    if not changed:
        exit_with_error("CHANGED_QUERIES environment variable is empty or not set")

    try:
        files = json.loads(changed)
    except json.JSONDecodeError:
        exit_with_error(f"CHANGED_QUERIES is not valid JSON: {changed}")

    query_dirs = []
    for f in files:
        if f.endswith('/query.rego'):
            query_dirs.append(REPO_ROOT / Path(f).parent)

    return query_dirs


def validate_query(query_dir):
    """Validate searchLine for a single query directory."""
    rel_dir = query_dir.relative_to(REPO_ROOT)
    print(f"--- Validating: {rel_dir}")

    rego_file = query_dir / 'query.rego'
    if not rego_file.exists():
        print("  [SKIP] query.rego not found")
        return True

    try:
        content = rego_file.read_text()
    except Exception as e:
        print(f"  ::warning file={rego_file.relative_to(REPO_ROOT)}::Cannot read file: {e}")
        return True

    if 'searchLine' not in content:
        print("  [SKIP] searchLine not defined in query.rego")
        return True

    # searchLine is defined — check if hardcoded to -1
    if re.search(r'"searchLine"\s*:\s*-1', content):
        print(f"  ::error file={rego_file.relative_to(REPO_ROOT)}::searchLine is hardcoded to -1")
        return False

    print("  [OK] query.rego defines searchLine correctly")

    return validate_expected_results(query_dir)


def validate_expected_results(query_dir):
    """Validate expected result files: searchLine must equal line."""
    test_dir = query_dir / 'test'

    if not test_dir.exists():
        print("  [SKIP] No test directory found")
        return True

    expected_files = list(test_dir.glob('*expected_result*.json'))

    if not expected_files:
        print("  [SKIP] No expected result files found")
        return True

    all_valid = True
    for expected_file in expected_files:
        try:
            results = json.loads(expected_file.read_text())
        except json.JSONDecodeError:
            print(f"  ::warning file={expected_file.relative_to(REPO_ROOT)}::Invalid JSON")
            continue
        except Exception as e:
            print(f"  ::warning file={expected_file.relative_to(REPO_ROOT)}::Error reading: {e}")
            continue

        if not isinstance(results, list):
            results = [results]

        for idx, result in enumerate(results):
            search_line = result.get('searchLine')
            line = result.get('line')

            if search_line is None or line is None:
                continue

            rel_path = expected_file.relative_to(REPO_ROOT)

            if search_line == -1:
                print(f"  ::error file={rel_path}::Result [{idx}]: searchLine is -1 (line={line})")
                all_valid = False
            elif search_line != line:
                print(f"  ::error file={rel_path}::Result [{idx}]: searchLine ({search_line}) != line ({line})")
                all_valid = False
            else:
                print(f"  [OK] {rel_path}: result [{idx}] searchLine={search_line} matches line")

    return all_valid


def main():
    print("Starting searchLine validation...\n")

    modified_queries = get_changed_queries()

    if not modified_queries:
        print("No query.rego files found in CHANGED_QUERIES - nothing to validate")
        sys.exit(0)

    print(f"Found {len(modified_queries)} modified queries to validate:\n")

    all_valid = True
    for query_dir in modified_queries:
        if not validate_query(query_dir):
            all_valid = False
        print()

    if all_valid:
        print("All searchLine validations passed!")
        sys.exit(0)
    else:
        exit_with_error("Some searchLine validations failed. See errors above.")


if __name__ == "__main__":
    main()
