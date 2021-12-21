import requests
import subprocess
import os
import glob
import json
from datetime import date
from tabulate import tabulate
import argparse
# import sys
# sys.path.append(os.path.abspath("./metrics/get_metrics.py"))


def get_statistics(test_coverage, total_tests, go_loc):
    latest_realease_url = "https://api.github.com/repos/Checkmarx/kics/releases/latest"
    releases_url = "https://api.github.com/repos/Checkmarx/kics/releases"
    dockerhub_url = "https://hub.docker.com/v2/repositories/checkmarx/kics"
    repo_url = "https://api.github.com/repos/Checkmarx/kics"

    date = get_date()
    version = get_version(latest_realease_url)
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
            'bug_open' : bug_open_count,
            'bug_closed' : bug_closed_count,
            'feature_request_open' : feature_request_open_count, 
            'feature_request_closed' : feature_request_closed_count,
            'total_tests': total_tests,
            'test_coverage': test_coverage,
            'e2e_tests' : e2e_tests
           }


def get_github_downloads(releases_url):
    gh_resp = requests.get(releases_url)
    if gh_resp.status_code == 200:
        response_body = gh_resp.json()
        all_github_downloads = sum([item for sublist in [[asset['download_count'] for asset in release['assets']]
                                                         for release in response_body] for item in sublist])
    print(f"Total GitHub downloads: {all_github_downloads}")

    return all_github_downloads

def get_dockerhub_pulls(dockerhub_url):
    dkr_resp = requests.get(dockerhub_url)
    if dkr_resp.status_code == 200:
        response_body = dkr_resp.json()
        all_dockerhub_pulls = response_body['pull_count']
    print(f"Total Dockerhub pulls: {all_dockerhub_pulls}")

    return all_dockerhub_pulls

def get_info_from_repo(repo_url):
    info_resp = requests.get(repo_url)
    if info_resp.status_code == 200:
        response_body = info_resp.json()
        stars = response_body['watchers_count']
        forks = response_body['forks']
    print(f"Total GitHub stars: {stars}")
    print(f"Total GitHub forks: {forks}")

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

    print(f"Total GitHub bug open issues: {bug_open_count}")
    print(f"Total GitHub bug closed issues: {bug_closed_count}")
    print(f"Total GitHub feature request open issues: {feature_request_open_count}")
    print(f"Total GitHub feature request closed issues: {feature_request_closed_count}")

    return bug_open_count, bug_closed_count, feature_request_open_count, feature_request_closed_count

def get_e2e_tests():
    path, dirs, files = next(os.walk("./././e2e/testcases"))
    e2e_tests = len(files) - 1
    print(f"Total E2E tests: {e2e_tests}")

    return e2e_tests

queries_basepath = 'assets/queries'

queries_path = {
    'ansible': os.path.join(queries_basepath, 'ansible', '**', '*'),
    'azureresourcemanager': os.path.join(queries_basepath, 'azureResourceManager', '*'),
    'cloudformation': os.path.join(queries_basepath, 'cloudFormation', '*'),
    'openapi': os.path.join(queries_basepath, 'openAPI', '**', '*'),
    'k8s': os.path.join(queries_basepath, 'k8s', '*'),
    'common': os.path.join(queries_basepath, 'common', '*'),
    'dockerfile': os.path.join(queries_basepath, 'dockerfile', '*'),
    'terraform': os.path.join(queries_basepath, 'terraform', '**', '*'),
    'grpc': os.path.join(queries_basepath, 'grpc', '*'),
    'gdm': os.path.join(queries_basepath, 'googleDeploymentManager', '*'),
}

samples_ext = {
    'azureresourcemanager': ['json'],
    'cloudformation': ['yaml', 'json'],
    'openapi': ['yaml', 'json'],
    'ansible': ['yaml'],
    'k8s': ['yaml'],
    'common': ['yaml', 'json', 'dockerfile', 'tf'],
    'dockerfile': ['dockerfile'],
    'terraform': ['tf'],
    'grpc': ['proto'],
    'gdm': ['yaml'],

}

def queries_count(path):
    rtn_count = 0
    with open(path) as fp:
        metadata_obj = json.load(fp)
        if 'aggregation' in metadata_obj:
            rtn_count = metadata_obj['aggregation']
        else:
            rtn_count = 1

    return rtn_count

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

    print(f"Total queries: {total_queries}")
    print(f"Total samples: {total_samples}")

    return total_queries, total_samples

def get_version(latest_realease_url):
    latest_resp = requests.get(latest_realease_url)
    if latest_resp.status_code == 200:
        response_body = latest_resp.json()
        version = response_body['name']
    print(f"Version: {version}")

    return version

def get_date():
    current_date = date.today().strftime("%Y/%m/%d")
    print(f"Date: {current_date}")

    return current_date


parser = argparse.ArgumentParser(
description='Extract test coverage and total tests')
parser.add_argument('-c', '--coverage', metavar='COV',
required=True, help='path to KICS repository root')
parser.add_argument('-t', '--total-tests', metavar='TESTS',
required=True, help='path to KICS repository root')
parser.add_argument('-g', '--goloc', metavar='GOLOC',
required=True, help='path to KICS repository root')

args = parser.parse_args()

def main():
    statistics = get_statistics(args.coverage, args.total_tests, args.goloc)

    print(tabulate([[key, value] for key, value in statistics.items()], headers=[
      '', ''], tablefmt='orgtbl'))


if __name__ == "__main__":
    main()
    print("Done!")
