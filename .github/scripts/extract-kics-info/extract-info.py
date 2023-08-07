import os
from fnmatch import fnmatch
import json
import zipfile


class Query:
    id: str
    queryName: str
    severityId: int
    categoryId: str
    descriptionText: str
    descriptionUrl: str
    platformId: int
    descriptionID: str
    aggregation: int
    cloudProviderId: int

    def __init__(self, queryData):
        self.id = queryData['id']
        self.queryName = queryData['queryName']
        self.severityId = severities.getSeverityId(queryData['severity'])
        self.categoryId = categories.getCategoryId(queryData['category'])
        self.descriptionText = queryData['descriptionText']
        self.descriptionUrl = queryData['descriptionUrl']
        self.platformId = platforms.getPlatformId(queryData['platform'])
        self.descriptionID = queryData['descriptionID']
        if queryData.__contains__('cloudProvider'):
            self.cloudProviderId = cloudProviders.getCloudProviderId(
                queryData['cloudProvider'])
        else:
            self.cloudProviderId = None
        if queryData.__contains__('aggregation'):
            self.aggregation = queryData['aggregation']
        else:
            self.aggregation = 1

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Queries:
    queries = []

    def __init__(self):
        self.queries = []

    def addQuery(self, query):
        self.queries.append(query)

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Platform:
    id: int
    platform: str

    def __init__(self, id, platform):
        self.id = id
        self.platform = platform

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Platforms:
    platforms = []

    def __init__(self):
        self.platforms = []

    def addPlatform(self, id, platform):
        p = Platform(id, platform)
        self.platforms.append(p)
        return p.id

    def getPlatformId(self, platform):
        found = False
        creationId = 1
        for plat in self.platforms:
            creationId = plat.id+1
            if plat.platform == platform:
                found = True
                return plat.id
        if not found:
            return self.addPlatform(creationId, platform)

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class CloudProvider:
    id: int
    cloudProvider: str

    def __init__(self, id, cloudProvider):
        self.id = id
        self.cloudProvider = cloudProvider

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class CloudProviders:
    cloudProviders = []

    def __init__(self):
        self.cloudProviders = []

    def addCloudProvider(self, id, cloudProvider):
        c = CloudProvider(id, cloudProvider)
        self.cloudProviders.append(c)
        return c.id

    def getCloudProviderId(self, cloudProvider):
        found = False
        creationId = 1
        for cp in self.cloudProviders:
            creationId = cp.id+1
            if cp.cloudProvider == cloudProvider:
                found = True
                return cp.id
        if not found:
            return self.addCloudProvider(creationId, cloudProvider)

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Severity:
    id: int
    severity: str

    def __init__(self, id, severity):
        self.id = id
        self.severity = severity

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Severities:
    severities = []

    def __init__(self):
        self.severities = []

    def addSeverity(self, id, severity):
        c = Severity(id, severity)
        self.severities.append(c)
        return c.id

    def getSeverityId(self, severity):
        found = False
        creationId = 1
        for s in self.severities:
            creationId = s.id+1
            if s.severity == severity:
                found = True
                return s.id
        if not found:
            return self.addSeverity(creationId, severity)

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Category:
    id: int
    category: str

    def __init__(self, id, category):
        self.id = id
        self.category = category

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class Categories:
    categories = []

    def __init__(self):
        self.categories = []

    def addCategory(self, id, category):
        c = Category(id, category)
        self.categories.append(c)
        return c.id

    def getCategoryId(self, category):
        found = False
        creationId = 1
        for c in self.categories:
            creationId = c.id+1
            if c.category == category:
                found = True
                return c.id
        if not found:
            return self.addCategory(creationId, category)

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


root = 'assets'
queriesRoot = root + "/queries"
pattern = "metadata.json"

queries = Queries()
categories = Categories()
severities = Severities()
cloudProviders = CloudProviders()
platforms = Platforms()


def getFramworks():
    frameworksList = next(os.walk(queriesRoot))[1]
    frameworksList.remove('common')
    return frameworksList


def loadQueriesData():
    for path, _, files in os.walk(root):
        assetsFolderPath = os.path.join(exportFolderPath,path)
        for name in files:
            lastPath = os.path.basename(os.path.normpath(assetsFolderPath))
            if not (lastPath == "test" or lastPath == ".git"):
                os.makedirs(assetsFolderPath, exist_ok=True)
                with open(os.path.join(assetsFolderPath,name), "w") as outfile:
                    file = open(os.path.join(path, name))
                    outfile.write(file.read())
            if fnmatch(name, pattern) and os.path.join("assets","queries") in assetsFolderPath: # make sure it is a metadata.json from the queries folder
                file = open(os.path.join(path, name))
                data = json.load(file)
                file.close()
                queries.addQuery(Query(data))
    #categoriesList.remove('Bill Of Materials')


exportFolderPath = ".github/scripts/extract-kics-info/"


def exportData():
    with open(exportFolderPath+"categories.json", "w") as outfile:
        outfile.write(categories.toJSON())

    with open(exportFolderPath+"platforms.json", "w") as outfile:
        outfile.write(platforms.toJSON())

    with open(exportFolderPath+"cloudProviders.json", "w") as outfile:
        outfile.write(cloudProviders.toJSON())

    with open(exportFolderPath+"severities.json", "w") as outfile:
        outfile.write(severities.toJSON())

    with open(exportFolderPath+"queries.json", "w") as outfile:
        outfile.write(queries.toJSON())

    with zipfile.ZipFile(exportFolderPath+"extracted-info.zip", mode="w") as archive:
        archive.write(exportFolderPath+"categories.json",
                      arcname="categories.json")
        archive.write(exportFolderPath+"platforms.json",
                      arcname="platforms.json")
        archive.write(exportFolderPath+"cloudProviders.json",
                      arcname="cloudProviders.json")
        archive.write(exportFolderPath+"severities.json",
                      arcname="severities.json")
        archive.write(exportFolderPath+"queries.json", arcname="queries.json")
        for dirname, _, files in os.walk(os.path.join(exportFolderPath,"assets")):
            archive.write(os.path.relpath(dirname,exportFolderPath))
            for filename in files:
                archive.write(os.path.join(os.path.relpath(dirname,exportFolderPath), filename))


if __name__ == "__main__":
    loadQueriesData()
    exportData()
