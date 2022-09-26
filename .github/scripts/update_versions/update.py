import json
import requests
# Gets data from apiUrl argument and checks if current version is outdated and returns new versions if applicable
def checkVersion(name, apiUrl, currentVersion):
    # make Http Get request
    r = requests.get(apiUrl)

    #checks if request is successful
    if r.status_code == 200:

        # get data from request
        request_version = r.json()[0]['latest']

        if request_version != currentVersion:
            # print version is not up to date and return the updated version value
            print("\t" + name + "\tfrom " +
               currentVersion + " to " + request_version)
            return request_version
        else:
            # print version is up to date and return empty string
            print("\t" + name + "\talready in latest version: " + currentVersion)
            return ""

    else:
        # raise exception is request is not successful
        raise Exception("\t error getting data from:\t"+ apiUrl)


# file descriptor
f = open('assets/libraries/common.json', "r")

# get json data from file
data = json.load(f)
f.close()

# track if file changed
file_changed = False

# get version_numbers_to_check json object
versions_to_check = data['version_numbers_to_check']

print("Checking versions:")

for i in versions_to_check:
    # check if any version is outdated
    version = checkVersion(i['name'], i['apiUrl'], i['version'])
    if version != "":
        file_changed = True
        i['version'] = version

# write file with new versions if any update detected
if file_changed:
    f = open('assets/libraries/common.json', "w")
    json.dump(data, f, indent=2)
    f.close()
    print("Versions Updated")
