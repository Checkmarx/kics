from runner import run_all
from write_expected_results import write_positive_expected_results, write_skipped_queries_report


def main():
    # 1. Build test list, run scans and populate results_info
    test_list = run_all()

    # 2. Write positive_expected_result.json for each query
    print(f"\n{'='*60}")
    print("Writing positive_expected_result.json files...\n")
    write_positive_expected_results(test_list)

    # 3. Write skipped queries report
    print(f"\n{'='*60}")
    print("Writing skipped queries report...\n")
    write_skipped_queries_report(test_list)


if __name__ == "__main__":
    main()
