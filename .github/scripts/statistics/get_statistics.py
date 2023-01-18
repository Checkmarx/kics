import os
import glob
from datetime import date
import sys
import argparse
from tabulate import tabulate
import requests

base = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(os.path.join(base, "metrics"))

from get_metrics import queries_count, queries_path, samples_ext


def get_statistics(test_coverage, total_tests, go_loc):
    latest_release_url = "https://api.github.com/repos/Checkmarx/kics/releases/latest"
    releases_url = "https://api.github.com/repos/Checkmarx/kics/releases"
    dockerhub_url = "https://hub.docker.com/v2/repositories/checkmarx/kics"
    repo_url = "https://api.github.com/repos/Checkmarx/kics"

    date = get_date()
    version = get_version(latest_release_url)
    total_queries, code_samples = get_total_queries()
    all_dockerhub_pulls = get_dockerhub_pulls(dockerhub_url)
    stars, forks = get_info_from_repo(repo_url)
    all_github_downloads = get_github_downloads(releases_url)
    bug_open_count, bug_closed_count, feature_request_open_count, feature_request_closed_count = get_relevant_issues_info()
    e2e_tests = get_e2e_tests()

    return {'date': date,
            'version': version,
            'total_queries': total_queries,
            'go_loc': go_loc,
            'dockerhub_pulls': all_dockerhub_pulls,
            'github_stars': stars,
            'github_forks': forks,
            'github_downloads': all_github_downloads,
            'bugs_open' : bug_open_count,
            'bugs_closed' : bug_closed_count,
            'feature_requests_open' : feature_request_open_count,
            'feature_requests_closed' : feature_request_closed_count,
            'total_tests': total_tests,
            'test_coverage': test_coverage,
            'code_samples': code_samples,
            'e2e_tests' : e2e_tests
           }


def get_github_downloads(releases_url):
    gh_resp = requests.get(releases_url)
    if gh_resp.status_code == 200:
        response_body = gh_resp.json()
        all_github_downloads = sum([item for sublist in [[asset['download_count'] for asset in release['assets']]
                                                         for release in response_body] for item in sublist])

    return all_github_downloads

def get_dockerhub_pulls(dockerhub_url):
    dkr_resp = requests.get(dockerhub_url)
    if dkr_resp.status_code == 200:
        response_body = dkr_resp.json()
        all_dockerhub_pulls = response_body['pull_count']

    return all_dockerhub_pulls

def get_info_from_repo(repo_url):
    info_resp = requests.get(repo_url)
    if info_resp.status_code == 200:
        response_body = info_resp.json()
        stars = response_body['watchers_count']
        forks = response_body['forks']

    return stars, forks


def get_relevant_issues_info():
    base_url = "https://api.github.com/search/issues?q=repo:Checkmarx/kics+type:"
    bug_open = base_url + "issue+state:open+label:bug"
    bug_closed = base_url + "issue+state:closed+label:bug"
    feature_request_open = base_url + "issue+state:open+label:\"feature%20request\""
    feature_request_closed = base_url + "issue+state:closed+label:\"feature%20request\""

    target_urls = [ { bug_open : ""}, { bug_closed : "" }, {feature_request_open: ""}, {feature_request_closed: ""} ]

    for target_url in target_urls:
        for url in target_url:
            target_resp = requests.get(url)
            if target_resp.status_code == 200:
                response_body = target_resp.json()
                target_url[url] = response_body["total_count"]

    bug_open_count = target_urls[0][bug_open]
    bug_closed_count = target_urls[1][bug_closed]
    feature_request_open_count = target_urls[2][feature_request_open]
    feature_request_closed_count = target_urls[3][feature_request_closed]

    return bug_open_count, bug_closed_count, feature_request_open_count, feature_request_closed_count

def get_e2e_tests():
    _, _, files = next(os.walk("./././e2e/testcases"))
    e2e_tests = len(files) - 1

    return e2e_tests

def get_total_queries():
    total_queries = 0
    total_samples = 0
    for key, value in queries_path.items():
        metadata_path = os.path.join(value, 'metadata.json')
        platform_count = sum([queries_count(path)
                            for path in glob.glob(metadata_path)])
        total_queries += platform_count

        for ext in samples_ext[key]:
            sample_path = os.path.join(value, 'test', f'*.{ext}')
            ext_samples = len([path for path in glob.glob(sample_path)])

            total_samples += ext_samples

    return total_queries, total_samples

def get_version(latest_release_url):
    latest_resp = requests.get(latest_release_url)
    if latest_resp.status_code == 200:
        response_body = latest_resp.json()
        version = response_body['name']

    return version

def get_date():
    current_date = date.today().strftime("%Y/%m/%d")

    return current_date


parser = argparse.ArgumentParser(
description='Extract test coverage and total tests')
parser.add_argument('-c', '--coverage', metavar='COV',
required=True)
parser.add_argument('-t', '--total-tests', metavar='TESTS',
required=True)
parser.add_argument('-g', '--goloc', metavar='GOLOC',
required=True)

args = parser.parse_args()

def main():
    statistics = get_statistics(args.coverage, args.total_tests, args.goloc)

    print(tabulate([[key, value] for key, value in statistics.items()], headers=[
      'KICS_KPIS', statistics["date"]], tablefmt='orgtbl'))


if __name__ == "__main__":
    main()
