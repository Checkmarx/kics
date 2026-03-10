#!/usr/bin/env python3
"""
Validador de searchLine para queries KICS (versao lite - analise estatica).
Recebe a lista de ficheiros alterados via CHANGED_QUERIES (JSON array do dorny/paths-filter).

Validacoes:
  1. Se o query.rego tiver searchLine, nao pode estar hardcoded a -1
  2. Nos expected results, se searchLine e line existirem:
     - searchLine != -1
     - searchLine == line
"""

import os
import re
import json
import sys
from pathlib import Path

# O script corre a partir de .github/scripts/validate-search-line/
REPO_ROOT = Path(__file__).resolve().parent.parent.parent.parent


def exit_with_error(message):
    print(f"::error::{message}")
    sys.exit(1)


def get_changed_queries():
    """Obtem a lista de query.rego alterados via env CHANGED_QUERIES (JSON array do dorny/paths-filter)."""
    changed = os.getenv('CHANGED_QUERIES', '')
    if not changed:
        exit_with_error("CHANGED_QUERIES environment variable is empty or not set")

    try:
        files = json.loads(changed)
    except json.JSONDecodeError:
        exit_with_error(f"CHANGED_QUERIES is not valid JSON: {changed}")

    # Extrair directorios unicos das queries
    query_dirs = []
    for f in files:
        if f.endswith('/query.rego'):
            query_dirs.append(REPO_ROOT / Path(f).parent)

    return query_dirs


def validate_rego_file(rego_file):
    """Valida que o query.rego define searchLine correctamente.

    - Se searchLine nao existir, skip (nao e obrigatorio)
    - Se existir, nao pode estar hardcoded a -1
    """
    try:
        content = rego_file.read_text()
    except Exception as e:
        print(f"  ::warning file={rego_file}::Cannot read file: {e}")
        return True

    if 'searchLine' not in content:
        print(f"  [SKIP] searchLine not found in {rego_file.name}")
        return True

    # Detectar searchLine hardcoded a -1
    if re.search(r'"searchLine"\s*:\s*-1', content):
        print(f"  ::error file={rego_file.relative_to(REPO_ROOT)}::searchLine is hardcoded to -1")
        return False

    # Verificar se usa build_search_line() (padrao recomendado)
    if 'build_search_line' in content:
        print(f"  [OK] {rego_file.name} uses build_search_line()")
        return True

    # Verificar se searchLine e atribuido a uma variavel
    if re.search(r'"searchLine"\s*:\s*[a-zA-Z_]\w*', content):
        print(f"  [OK] {rego_file.name} has searchLine assigned to a variable")
        return True

    print(f"  ::warning file={rego_file.relative_to(REPO_ROOT)}::searchLine pattern unclear - review manually")
    return True


def validate_expected_results(query_dir):
    """Valida os ficheiros de expected results.

    Para cada resultado esperado que contenha searchLine e line:
    - searchLine != -1
    - searchLine == line
    """
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
            print("  ::warning file={expected_file.relative_to(REPO_ROOT)}::Invalid JSON")
            continue
        except Exception as e:
            print("  ::warning file={expected_file.relative_to(REPO_ROOT)}::Error reading: {e}")
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
                print("  ::error file={rel_path}::Result [{idx}]: searchLine is -1 (line={line})")
                all_valid = False
            elif search_line != line:
                print("  ::error file={rel_path}::Result [{idx}]: searchLine ({search_line}) != line ({line})")
                all_valid = False
            else:
                print("  [OK] {rel_path}: result [{idx}] searchLine={search_line} matches line")

    return all_valid


def main():
    print("Starting searchLine validation (lite mode)...\n")

    # Obter queries alteradas do dorny/paths-filter
    modified_queries = get_changed_queries()

    if not modified_queries:
        print("No query.rego files found in CHANGED_QUERIES - nothing to validate")
        sys.exit(0)

    print(f"Found {len(modified_queries)} modified queries to validate:\n")

    all_valid = True
    for query_dir in modified_queries:
        rel_dir = query_dir.relative_to(REPO_ROOT)
        print(f"--- Validating: {rel_dir}")

        rego_file = query_dir / 'query.rego'
        if rego_file.exists():
            if not validate_rego_file(rego_file):
                all_valid = False

        if not validate_expected_results(query_dir):
            all_valid = False

        print()

    if all_valid:
        print("All searchLine validations passed!")
        sys.exit(0)
    else:
        exit_with_error("Some searchLine validations failed. See errors above.")


if __name__ == "__main__":
    main()
