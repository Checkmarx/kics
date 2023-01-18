import requests

def get_version(latest_release_url):
    latest_resp = requests.get(latest_release_url)
    if latest_resp.status_code == 200:
        response_body = latest_resp.json()
        version = response_body['name']

    return version

def get_commits():
    tag = get_version("https://api.github.com/repos/Checkmarx/kics/releases/latest")
    commits_url = "https://api.github.com/repos/Checkmarx/kics/compare/" + tag + "...master"

    contributors = []

    print('\n' + '─' * 150)

    resp = requests.get(commits_url)
    if resp.status_code == 200:
        response_body = resp.json()

        for commit in response_body['commits']:
            author = "@" + commit['author']['login']

            message = commit['commit']['message']
            message = message.split("\n\n")[0]

            if not is_checkmarx_member(author):
                contributors.append(author)
                message = message + " by " + author

            print(message)

    print("\nContributors: " + ', '.join(map(str, contributors)))

    print('─' * 150)

def is_checkmarx_member(member):
    cxMembers = [
        "@cxlucas",
        "@dependabot[bot]",
        "@joaoReigota1",
        "@joaorufi",
        "@kaplanlior",
        "@kicsbot",
        "@markmishaevcx",
        "@nunoocx",
        "@oribendetcx",
        "@rafaela-soares"
    ]

    for cx in cxMembers:
        if cx == member:
            return True

    return False

if __name__ == "__main__":
    get_commits()
