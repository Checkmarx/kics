"""
Add the missing 'issueType' field to every positive_expected_result.json file.

This script does NOT re-run any scans. It reads each query's query.rego to
determine the issueType(s) and matches them to existing expected-result entries
based on expectedValue / actualValue patterns.

No existing field is modified — only 'issueType' is inserted.

Usage:
    python add_issue_type.py          # normal run
    python add_issue_type.py --dry    # dry run (report only, no writes)
"""

import json
import re
import sys
from pathlib import Path

ASSETS_QUERIES_DIR = Path(__file__).resolve().parents[3] / "assets" / "queries"

# ── Rego parsing ────────────────────────────────────────────────────────────

VALID_ISSUE_TYPES = {"MissingAttribute", "IncorrectValue", "RedundantAttribute", "BillOfMaterials"}

# Keys used for issueType in different rego coding styles
_IT_KEYS = ("issueType", "it", "issueT", "type", "issue")
# Keys used for expected-value pattern
_EV_KEYS = ("keyExpectedValue", "kev", "solution")
# Keys used for actual-value pattern
_AV_KEYS = ("keyActualValue", "kav", "message")


def extract_string_or_sprintf(block: str, keys: tuple[str, ...] | str) -> str | None:
    """Extract a literal string or the format-string from a sprintf call.

    ``keys`` can be a single key or a tuple of alternatives (first match wins).
    """
    if isinstance(keys, str):
        keys = (keys,)
    for key in keys:
        # "key": "literal"
        m = re.search(rf'"{key}"\s*:\s*"([^"]*)"', block)
        if m:
            return m.group(1)
        # "key": sprintf("format ...", [...])
        m = re.search(rf'"{key}"\s*:\s*sprintf\s*\(\s*"([^"]*)"', block)
        if m:
            return m.group(1)
    return None


def _split_into_result_blocks(content: str) -> list[str]:
    """Split rego content into logical blocks that each contain one result dict.

    We look for:
      - CxPolicy[result] { ... }
      - } else = res { ... }   (helper function branches)
      - functionName(...) = res { ... }
      - functionName(...) = "IssueType" {  (issueType helper functions)
    Each "block" is the text from the opening brace to the next block boundary.
    """
    openers = list(re.finditer(
        r'(?:CxPolicy\s*\[\s*result\s*\]\s*\{|'         # CxPolicy blocks
        r'}\s*else\s*=\s*\w+\s*\{|'                      # else = res {
        r'}\s*else\s*=\s*"[^"]*"\s*(?:#[^\n]*)?\n|'      # else = "IncorrectValue" # comment\n
        r'\w+\([^)]*\)\s*=\s*(?:res|result|issue)\s*\{|' # func(...) = res/issue {
        r'\w+\([^)]*\)\s*=\s*"[^"]*"\s*\{)',              # issueType(str) = "Value" {
        content
    ))

    blocks: list[str] = []
    for i, m in enumerate(openers):
        start = m.end()
        end = openers[i + 1].start() if i + 1 < len(openers) else len(content)
        blocks.append(m.group() + content[start:end])  # include opener for context

    return blocks


def parse_rego_blocks(rego_path: Path) -> list[dict]:
    """Return a list of dicts with issueType / expectedPattern / actualPattern.

    Handles direct issueType in CxPolicy blocks and indirect issueType via
    helper functions with various key-name conventions.
    """
    content = rego_path.read_text(encoding="utf-8")
    blocks: list[dict] = []

    result_blocks = _split_into_result_blocks(content)

    for block in result_blocks:
        issue_type = None

        # 1. Check for known issueType keys with literal values
        for key in _IT_KEYS:
            m = re.search(rf'"{key}"\s*:\s*"([^"]+)"', block)
            if m and m.group(1) in VALID_ISSUE_TYPES:
                issue_type = m.group(1)
                break

        # 2. Check for function-style: = "MissingAttribute" { or else = "Value" (comment)
        if not issue_type:
            m = re.search(
                r'=\s*"(MissingAttribute|IncorrectValue|RedundantAttribute|BillOfMaterials)"',
                block
            )
            if m:
                issue_type = m.group(1)

        if not issue_type:
            continue

        blocks.append({
            "issueType": issue_type,
            "expectedPattern": extract_string_or_sprintf(block, _EV_KEYS),
            "actualPattern": extract_string_or_sprintf(block, _AV_KEYS),
        })

    return blocks


# ── Matching ────────────────────────────────────────────────────────────────

def _pattern_score(pattern: str | None, value: str) -> int:
    """Score how well a sprintf/literal pattern matches a resolved value."""
    if not pattern:
        return 0
    # Split the pattern on format specifiers (%s, %d, %v, …) and check
    # whether the literal fragments appear in the value.
    fragments = re.split(r'%[sdvfgtq]', pattern)
    score = 0
    for frag in fragments:
        frag = frag.strip()
        if frag and frag in value:
            score += len(frag)
    return score


def match_issue_type(entry: dict, blocks: list[dict]) -> str | None:
    """Determine the issueType for a single expected-result entry."""
    if not blocks:
        return None

    unique = {b["issueType"] for b in blocks}
    if len(unique) == 1:
        return unique.pop()

    # Multiple issueTypes — score each block against the entry
    actual = entry.get("actualValue", "")
    expected = entry.get("expectedValue", "")

    best_type: str | None = None
    best_score = -1

    for block in blocks:
        score = (
            _pattern_score(block["actualPattern"], actual)
            + _pattern_score(block["expectedPattern"], expected)
        )
        if score > best_score:
            best_score = score
            best_type = block["issueType"]

    return best_type


# ── File discovery ──────────────────────────────────────────────────────────

def find_expected_result_files(query_dir: Path) -> list[Path]:
    """Return all positive_expected_result.json files under the query's test dir."""
    test_dir = query_dir / "test"
    if not test_dir.is_dir():
        return []
    return sorted(test_dir.rglob("positive_expected_result.json"))


def is_query_directory(p: Path) -> bool:
    if not (p / "metadata.json").is_file():
        return False
    return (p / "query.rego").is_file() or (p / "regex_rules.json").is_file()


# ── Main logic ──────────────────────────────────────────────────────────────

def process_query(query_dir: Path, dry: bool) -> dict:
    """Process one query directory. Returns a small stats dict."""
    stats = {"added": 0, "skipped": 0, "already": 0, "no_match": 0, "files": 0}

    rego_path = query_dir / "query.rego"
    is_regex = (query_dir / "regex_rules.json").is_file() and not rego_path.is_file()

    if is_regex:
        blocks: list[dict] = []
        default_issue_type = "RedundantAttribute"
    else:
        if not rego_path.is_file():
            return stats
        blocks = parse_rego_blocks(rego_path)
        default_issue_type = None

    result_files = find_expected_result_files(query_dir)
    if not result_files:
        return stats

    for rf in result_files:
        with open(rf, "r", encoding="utf-8") as f:
            entries = json.load(f)

        if not isinstance(entries, list):
            continue

        modified = False
        for entry in entries:
            if "issueType" in entry:
                stats["already"] += 1
                continue

            if default_issue_type:
                it = default_issue_type
            else:
                it = match_issue_type(entry, blocks)

            if it is None:
                stats["no_match"] += 1
                print(f"  WARNING: could not determine issueType for entry in {rf}")
                print(f"    expectedValue: {entry.get('expectedValue', '')[:80]}")
                print(f"    actualValue:   {entry.get('actualValue', '')[:80]}")
                continue

            entry["issueType"] = it
            stats["added"] += 1
            modified = True

        if modified and not dry:
            with open(rf, "w", encoding="utf-8") as f:
                json.dump(entries, f, indent=2, ensure_ascii=False)
                f.write("\n")

        stats["files"] += 1

    return stats


def main() -> None:
    dry = "--dry" in sys.argv

    if dry:
        print("=== DRY RUN — no files will be written ===\n")

    totals = {"added": 0, "skipped": 0, "already": 0, "no_match": 0, "files": 0, "queries": 0}

    for query_dir in sorted(ASSETS_QUERIES_DIR.rglob("*")):
        if not query_dir.is_dir():
            continue
        if not is_query_directory(query_dir):
            continue

        stats = process_query(query_dir, dry)
        if stats["files"] == 0:
            continue

        totals["queries"] += 1
        for k in ("added", "skipped", "already", "no_match", "files"):
            totals[k] += stats[k]

        label = query_dir.relative_to(ASSETS_QUERIES_DIR)
        if stats["no_match"]:
            print(f"[!] {label}: {stats}")
        elif stats["added"]:
            print(f"[+] {label}: added {stats['added']} issueType(s)")

    print(f"\n{'='*60}")
    print(f"Queries processed : {totals['queries']}")
    print(f"Files touched     : {totals['files']}")
    print(f"issueType added   : {totals['added']}")
    print(f"Already present   : {totals['already']}")
    print(f"No match (WARN)   : {totals['no_match']}")

    if totals["no_match"]:
        print("\n⚠  Some entries could not be matched. Review the warnings above.")
        sys.exit(1)


if __name__ == "__main__":
    main()
