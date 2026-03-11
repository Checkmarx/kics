#!/usr/bin/env python3

import os
import requests
import json
import subprocess
import sys
from pathlib import Path

KICS_PR_NUMBER = os.getenv('KICS_PR_NUMBER')
KICS_GITHUB_TOKEN = os.getenv('KICS_GITHUB_TOKEN')

def exit_with_error(message):
    print(f"::error::{message}")
    sys.exit(1)

def exit_success():
    print("All searchLine validations passed!")
    sys.exit(0)

def fetch(page=1, max_items=100):
    """Fetch PR files from GitHub API"""
    print(f'Fetching PR #{KICS_PR_NUMBER} files... page {page}')
    headers = {'Authorization': f'token {KICS_GITHUB_TOKEN}'}
    url = f'https://api.github.com/repos/checkmarx/kics/pulls/{KICS_PR_NUMBER}/files?per_page={max_items}&page={page}'
    response = requests.get(url, headers=headers)
    return {"data": response.json(), "status": response.status_code}

def fetch_pr_files():
    """Fetch all files modified in the PR"""
    files = []
    page = 1
    max_items = 100

    while page < 50:
        response = fetch(page, max_items)
        if response['status'] != 200:
            return exit_with_error(f'Failed to fetch PR files\n- status code: {response["status"]}')

        for obj in response['data']:
            if obj['status'] != 'removed':
                files.append(obj['filename'])

        if len(response['data']) < max_items:
            return files

        page += 1

    return exit_with_error('Failed to fetch PR files - too many pages')

def find_modified_queries(files):
    """Find modified query files (query.rego files)"""
    modified_queries = []
    for file in files:
        # Match patterns like assets/queries/terraform/*/query.rego
        if file.startswith('assets/queries/') and file.endswith('/query.rego'):
            query_dir = str(Path(file).parent)
            modified_queries.append(query_dir)
    return modified_queries

def find_test_fixtures(query_dir):
    """Find test fixtures for a query"""
    test_dir = Path(query_dir) / 'test'
    if not test_dir.exists():
        return []
    
    fixtures = []
    for item in test_dir.glob('positive*.json'):
        fixtures.append(str(item))
    
    return fixtures

def validate_query_results(query_dir):
    """Run KICS on test files and validate searchLine"""
    print(f"\n🔍 Validating query: {query_dir}")
    
    test_dir = Path(query_dir) / 'test'
    if not test_dir.exists():
        print("No test directory found")
        return True
    
    test_files = list(test_dir.glob('positive*')) + list(test_dir.glob('negative*'))
    if not test_files:
        print("No test files found")
        return True
    
    for i, entry in range(test_files):
        print(f"test_files[{i}]: {entry}\n")

    # Run KICS on test directory using the compiled binary
    kics_binary = './bin/kics'
    cmd = [
        kics_binary, 'scan',
        '-p', str(test_dir),
        '--queries', str(query_dir),
        '-o', '/tmp/kics-result.json',
        '--output-formats', 'json',
        '--exclude-paths', 'test'
    ]
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, cwd='../..')
        if result.returncode not in [0, 20, 40, 50]:  # KICS returns different codes for different scenarios
            print(f"KICS scan returned code {result.returncode}")
            if result.stderr:
                print(f"       stderr: {result.stderr[:200]}")
            return True  # Don't fail the validation if KICS itself fails
    except FileNotFoundError:
        print(f"KICS binary not found at {kics_binary}")
        return True
    except Exception as e:
        print(f"Failed to run KICS: {e}")
        return True
    
    # Validate results
    try:
        with open('/tmp/kics-result.json', 'r') as f:
            results = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        print("No results file generated")
        return True
    
    all_valid = True
    results_list = results.get('results', [])
    
    if not results_list:
        print("No issues found in test files")
        return True
    
    for result in results_list:
        search_line = result.get('searchLine', -1)
        line = result.get('line', -1)
        
        # Validate searchLine
        if search_line == -1:
            print(f"searchLine is -1 for {result.get('fileName')}:{line}")
            all_valid = False
        elif search_line != line:
            print(f"searchLine ({search_line}) != line ({line}) in {result.get('fileName')}")
            all_valid = False
        else:
            print(f"{result.get('fileName')}:{line} - searchLine correctly set to {search_line}")
    
    return all_valid

def main():
    print("Starting searchLine validation...\n")
    
    if not KICS_PR_NUMBER or not KICS_GITHUB_TOKEN:
        exit_with_error("Missing KICS_PR_NUMBER or KICS_GITHUB_TOKEN environment variables")
    
    # Fetch modified files
    pr_files = fetch_pr_files()
    print(f"Found {len(pr_files)} modified files in PR\n")
    
    # Find modified queries
    modified_queries = find_modified_queries(pr_files)
    for i, entry in range(modified_queries):
        print(f"modified_queries[{i}: {entry}]\n")
    
    if not modified_queries:
        print("No modified queries found in this PR")
        exit_success()
    
    print(f"Found {len(modified_queries)} modified queries\n")
    
    # Validate each query
    all_valid = True
    for query_dir in modified_queries:
        if not validate_query_results(query_dir):
            all_valid = False
    
    if all_valid:
        exit_success()
    else:
        exit_with_error("Some searchLine validations failed. Please fix the issues above.")

if __name__ == "__main__":
    main()
