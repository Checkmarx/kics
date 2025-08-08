package analyzer

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"sync"

	"github.com/Checkmarx/kics/v2/internal/metrics"
	"github.com/Checkmarx/kics/v2/pkg/engine/provider"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	ignore "github.com/sabhiram/go-gitignore"

	yamlParser "gopkg.in/yaml.v3"
)

const (
	yml        = ".yml"
	yaml       = ".yaml"
	json       = ".json"
	sh         = ".sh"
	arm        = "azureresourcemanager"
	bicep      = "bicep"
	kubernetes = "kubernetes"
	terraform  = "terraform"
	gdm        = "googledeploymentmanager"
	ansible    = "ansible"
	grpc       = "grpc"
	dockerfile = "dockerfile"
	crossplane = "crossplane"
	knative    = "knative"
	sizeMb     = 1048576
)

// move the openApi regex to public to be used on file.go
// openAPIRegex - Regex that finds OpenAPI defining property "openapi" or "swagger"
// openAPIRegexInfo - Regex that finds OpenAPI defining property "info"
// openAPIRegexPath - Regex that finds OpenAPI defining property "paths", "components", or "webhooks" (from 3.1.0)
// cloudRegex - Regex that finds CloudFormation defining property "Resources"
// k8sRegex - Regex that finds Kubernetes defining property "apiVersion"
// k8sRegexKind - Regex that finds Kubernetes defining property "kind"
// k8sRegexMetadata - Regex that finds Kubernetes defining property "metadata"
// k8sRegexSpec - Regex that finds Kubernetes defining property "spec"
var (
	OpenAPIRegex                                    = regexp.MustCompile(`("(openapi|swagger)"|(openapi|swagger))\s*:`)
	OpenAPIRegexInfo                                = regexp.MustCompile(`("info"|info)\s*:`)
	OpenAPIRegexPath                                = regexp.MustCompile(`("(paths|components|webhooks)"|(paths|components|webhooks))\s*:`)
	armRegexContentVersion                          = regexp.MustCompile(`"contentVersion"\s*:`)
	armRegexResources                               = regexp.MustCompile(`"resources"\s*:`)
	cloudRegex                                      = regexp.MustCompile(`("Resources"|Resources)\s*:`)
	k8sRegex                                        = regexp.MustCompile(`("apiVersion"|apiVersion)\s*:`)
	k8sRegexKind                                    = regexp.MustCompile(`("kind"|kind)\s*:`)
	tfPlanRegexPV                                   = regexp.MustCompile(`"planned_values"\s*:`)
	tfPlanRegexRC                                   = regexp.MustCompile(`"resource_changes"\s*:`)
	tfPlanRegexConf                                 = regexp.MustCompile(`"configuration"\s*:`)
	tfPlanRegexTV                                   = regexp.MustCompile(`"terraform_version"\s*:`)
	cdkTfRegexMetadata                              = regexp.MustCompile(`"metadata"\s*:`)
	cdkTfRegexStackName                             = regexp.MustCompile(`"stackName"\s*:`)
	cdkTfRegexTerraform                             = regexp.MustCompile(`"terraform"\s*:`)
	artifactsRegexKind                              = regexp.MustCompile(`("kind"|kind)\s*:`)
	artifactsRegexProperties                        = regexp.MustCompile(`("properties"|properties)\s*:`)
	artifactsRegexParameters                        = regexp.MustCompile(`("parameters"|parameters)\s*:`)
	policyAssignmentArtifactRegexPolicyDefinitionID = regexp.MustCompile(`("policyDefinitionId"|policyDefinitionId)\s*:`)
	roleAssignmentArtifactRegexPrincipalIds         = regexp.MustCompile(`("principalIds"|principalIds)\s*:`)
	roleAssignmentArtifactRegexRoleDefinitionID     = regexp.MustCompile(`("roleDefinitionId"|roleDefinitionId)\s*:`)
	templateArtifactRegexParameters                 = regexp.MustCompile(`("template"|template)\s*:`)
	blueprintRegexTargetScope                       = regexp.MustCompile(`("targetScope"|targetScope)\s*:`)
	blueprintRegexProperties                        = regexp.MustCompile(`("properties"|properties)\s*:`)
	buildahRegex                                    = regexp.MustCompile(`buildah\s*from\s*\w+`)
	dockerComposeServicesRegex                      = regexp.MustCompile(`services\s*:[\w\W]+(image|build)\s*:`)
	crossPlaneRegex                                 = regexp.MustCompile(`"?apiVersion"?\s*:\s*(\w+\.)+crossplane\.io/v\w+\s*`)
	knativeRegex                                    = regexp.MustCompile(`"?apiVersion"?\s*:\s*(\w+\.)+knative\.dev/v\w+\s*`)
	pulumiNameRegex                                 = regexp.MustCompile(`name\s*:`)
	pulumiRuntimeRegex                              = regexp.MustCompile(`runtime\s*:`)
	pulumiResourcesRegex                            = regexp.MustCompile(`resources\s*:`)
	serverlessServiceRegex                          = regexp.MustCompile(`service\s*:`)
	serverlessProviderRegex                         = regexp.MustCompile(`(^|\n)provider\s*:`)
	cicdOnRegex                                     = regexp.MustCompile(`\s*on:\s*`)
	cicdJobsRegex                                   = regexp.MustCompile(`\s*jobs:\s*`)
	cicdStepsRegex                                  = regexp.MustCompile(`\s*steps:\s*`)
	queryRegexPathsAnsible                          = regexp.MustCompile(fmt.Sprintf(`^.*?%s(?:group|host)_vars%s.*$`, regexp.QuoteMeta(string(os.PathSeparator)), regexp.QuoteMeta(string(os.PathSeparator)))) //nolint:lll
	fhirResourceTypeRegex                           = regexp.MustCompile(`"resourceType"\s*:`)
	fhirEntryRegex                                  = regexp.MustCompile(`"entry"\s*:`)
	fhirSubjectRegex                                = regexp.MustCompile(`"subject"\s*:`)
	fhirCodeRegex                                   = regexp.MustCompile(`"code"\s*:`)
	fhirStatusRegex                                 = regexp.MustCompile(`"status"\s*:`)
	azurePipelinesVscodeRegex                       = regexp.MustCompile(`\$id"\s*:\s*"[^"]*azure-pipelines-vscode[^"]*`)
)

var (
	listKeywordsGoogleDeployment = []string{"resources"}
	armRegexTypes                = []string{"blueprint", "templateArtifact", "roleAssignmentArtifact", "policyAssignmentArtifact"}
	possibleFileTypes            = map[string]bool{
		".yml":               true,
		".yaml":              true,
		".json":              true,
		".dockerfile":        true,
		"Dockerfile":         true,
		"possibleDockerfile": true,
		".debian":            true,
		".ubi8":              true,
		".tf":                true,
		"tfvars":             true,
		".proto":             true,
		".sh":                true,
		".cfg":               true,
		".conf":              true,
		".ini":               true,
		".bicep":             true,
	}
	supportedRegexes = map[string][]string{
		"azureresourcemanager": append(armRegexTypes, arm),
		"buildah":              {"buildah"},
		"cicd":                 {"cicd"},
		"cloudformation":       {"cloudformation"},
		"crossplane":           {"crossplane"},
		"dockercompose":        {"dockercompose"},
		"knative":              {"knative"},
		"kubernetes":           {"kubernetes"},
		"openapi":              {"openapi"},
		"terraform":            {"terraform", "cdkTf"},
		"pulumi":               {"pulumi"},
		"serverlessfw":         {"serverlessfw"},
	}
	listKeywordsAnsible = []string{"name", "gather_facts",
		"hosts", "tasks", "become", "with_items", "with_dict",
		"when", "become_pass", "become_exe", "become_flags"}
	playBooks               = "playbooks"
	ansibleHost             = []string{"all", "ungrouped"}
	listKeywordsAnsibleHots = []string{"hosts", "children"}
)

type Parameters struct {
	Results     string
	Path        []string
	MaxFileSize int
}

// regexSlice is a struct to contain a slice of regex
type regexSlice struct {
	regex []*regexp.Regexp
}

type analyzerInfo struct {
	typesFlag               []string
	excludeTypesFlag        []string
	filePath                string
	fallbackMinifiedFileLOC int
}

// Analyzer keeps all the relevant info for the function Analyze
type Analyzer struct {
	Paths                   []string
	Types                   []string
	ExcludeTypes            []string
	Exc                     []string
	GitIgnoreFileName       string
	ExcludeGitIgnore        bool
	MaxFileSize             int
	FallbackMinifiedFileLOC int
}

// types is a map that contains the regex by type
var types = map[string]regexSlice{
	"openapi": {
		regex: []*regexp.Regexp{
			OpenAPIRegex,
			OpenAPIRegexInfo,
			OpenAPIRegexPath,
		},
	},
	"kubernetes": {
		regex: []*regexp.Regexp{
			k8sRegex,
			k8sRegexKind,
		},
	},
	"crossplane": {
		regex: []*regexp.Regexp{
			crossPlaneRegex,
			k8sRegexKind,
		},
	},
	"knative": {
		regex: []*regexp.Regexp{
			knativeRegex,
			k8sRegexKind,
		},
	},
	"cloudformation": {
		regex: []*regexp.Regexp{
			cloudRegex,
		},
	},
	"azureresourcemanager": {
		[]*regexp.Regexp{
			armRegexContentVersion,
			armRegexResources,
		},
	},
	"terraform": {
		[]*regexp.Regexp{
			tfPlanRegexConf,
			tfPlanRegexPV,
			tfPlanRegexRC,
			tfPlanRegexTV,
		},
	},
	"cdkTf": {
		[]*regexp.Regexp{
			cdkTfRegexMetadata,
			cdkTfRegexStackName,
			cdkTfRegexTerraform,
		},
	},
	"policyAssignmentArtifact": {
		[]*regexp.Regexp{
			artifactsRegexKind,
			artifactsRegexProperties,
			artifactsRegexParameters,
			policyAssignmentArtifactRegexPolicyDefinitionID,
		},
	},
	"roleAssignmentArtifact": {
		[]*regexp.Regexp{
			artifactsRegexKind,
			artifactsRegexProperties,
			roleAssignmentArtifactRegexPrincipalIds,
			roleAssignmentArtifactRegexRoleDefinitionID,
		},
	},
	"templateArtifact": {
		[]*regexp.Regexp{
			artifactsRegexKind,
			artifactsRegexProperties,
			artifactsRegexParameters,
			templateArtifactRegexParameters,
		},
	},
	"blueprint": {
		[]*regexp.Regexp{
			blueprintRegexTargetScope,
			blueprintRegexProperties,
		},
	},
	"buildah": {
		[]*regexp.Regexp{
			buildahRegex,
		},
	},
	"dockercompose": {
		[]*regexp.Regexp{
			dockerComposeServicesRegex,
		},
	},
	"pulumi": {
		[]*regexp.Regexp{
			pulumiNameRegex,
			pulumiRuntimeRegex,
			pulumiResourcesRegex,
		},
	},
	"serverlessfw": {
		[]*regexp.Regexp{
			serverlessServiceRegex,
			serverlessProviderRegex,
		},
	},
	"cicd": {
		[]*regexp.Regexp{
			cicdOnRegex,
			cicdJobsRegex,
			cicdStepsRegex,
		},
	},
}

// region blacklisted platforms

var blacklistedTypesRegexes = map[string]map[string]regexSlice{
	"templateArtifact": {
		"fhir": {
			regex: []*regexp.Regexp{
				fhirResourceTypeRegex,
				fhirStatusRegex,
				fhirCodeRegex,
				fhirEntryRegex,
				fhirSubjectRegex,
			},
		},
	},
	"blueprint": {
		"azurepipelinesvscode": {
			regex: []*regexp.Regexp{
				azurePipelinesVscodeRegex,
			},
		},
	},
}

//endregion

var defaultConfigFiles = []string{"pnpm-lock.yaml"}

// Analyze will go through the slice paths given and determine what type of queries should be loaded
// should be loaded based on the extension of the file and the content
func Analyze(a *Analyzer) (model.AnalyzedPaths, error) {
	// start metrics for file analyzer
	metrics.Metric.Start("file_type_analyzer")
	returnAnalyzedPaths := model.AnalyzedPaths{
		Types:       make([]string, 0),
		Exc:         make([]string, 0),
		ExpectedLOC: 0,
	}

	var files []string
	var wg sync.WaitGroup
	// results is the channel shared by the workers that contains the types found
	results := make(chan string)
	locCount := make(chan int)
	ignoreFiles := make([]string, 0)
	projectConfigFiles := make([]string, 0)
	done := make(chan bool)
	hasGitIgnoreFile, gitIgnore := shouldConsiderGitIgnoreFile(a.Paths[0], a.GitIgnoreFileName, a.ExcludeGitIgnore)
	// get all the files inside the given paths
	for _, path := range a.Paths {
		if _, err := os.Stat(path); err != nil {
			return returnAnalyzedPaths, errors.Wrap(err, "failed to analyze path")
		}
		if err := filepath.Walk(path, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			ext, errExt := utils.GetExtension(path)
			if errExt == nil {
				trimmedPath := strings.ReplaceAll(path, a.Paths[0], filepath.Base(a.Paths[0]))
				ignoreFiles = a.checkIgnore(info.Size(), hasGitIgnoreFile, gitIgnore, path, trimmedPath, ignoreFiles)

				if isConfigFile(path, defaultConfigFiles) {
					projectConfigFiles = append(projectConfigFiles, path)
					a.Exc = append(a.Exc, path)
				}

				if _, ok := possibleFileTypes[ext]; ok && !isExcludedFile(path, a.Exc) {
					files = append(files, path)
				}
			}
			return nil
		}); err != nil {
			log.Error().Msgf("failed to analyze path %s: %s", path, err)
		}
	}

	// unwanted is the channel shared by the workers that contains the unwanted files that the parser will ignore
	unwanted := make(chan string, len(files))

	a.Types, a.ExcludeTypes = typeLower(a.Types, a.ExcludeTypes)

	// Start the workers
	for _, file := range files {
		wg.Add(1)
		// analyze the files concurrently
		a := &analyzerInfo{
			typesFlag:               a.Types,
			excludeTypesFlag:        a.ExcludeTypes,
			filePath:                file,
			fallbackMinifiedFileLOC: a.FallbackMinifiedFileLOC,
		}
		go a.worker(results, unwanted, locCount, &wg)
	}

	go func() {
		// close channel results when the worker has finished writing into it
		defer func() {
			close(unwanted)
			close(results)
			close(locCount)
		}()
		wg.Wait()
		done <- true
	}()

	availableTypes, unwantedPaths, loc := computeValues(results, unwanted, locCount, done)
	multiPlatformTypeCheck(&availableTypes)
	unwantedPaths = append(unwantedPaths, ignoreFiles...)
	unwantedPaths = append(unwantedPaths, projectConfigFiles...)
	returnAnalyzedPaths.Types = availableTypes
	returnAnalyzedPaths.Exc = unwantedPaths
	returnAnalyzedPaths.ExpectedLOC = loc
	// stop metrics for file analyzer
	metrics.Metric.Stop()
	return returnAnalyzedPaths, nil
}

// worker determines the type of the file by ext (dockerfile and terraform)/content and
// writes the answer to the results channel
// if no types were found, the worker will write the path of the file in the unwanted channel
func (a *analyzerInfo) worker(results, unwanted chan<- string, locCount chan<- int, wg *sync.WaitGroup) { //nolint: gocyclo
	defer func() {
		if err := recover(); err != nil {
			log.Warn().Msgf("Recovered from analyzing panic for file %s with error: %#v", a.filePath, err.(error).Error())
			unwanted <- a.filePath
		}
		wg.Done()
	}()

	ext, errExt := utils.GetExtension(a.filePath)
	if errExt == nil {
		linesCount, _ := utils.LineCounter(a.filePath, a.fallbackMinifiedFileLOC)

		switch ext {
		// Dockerfile (direct identification)
		case ".dockerfile", "Dockerfile":
			if a.isAvailableType(dockerfile) {
				results <- dockerfile
				locCount <- linesCount
			}
		// Dockerfile (indirect identification)
		case "possibleDockerfile", ".ubi8", ".debian":
			if a.isAvailableType(dockerfile) && isDockerfile(a.filePath) {
				results <- dockerfile
				locCount <- linesCount
			} else {
				unwanted <- a.filePath
			}
		// Terraform
		case ".tf", "tfvars":
			if a.isAvailableType(terraform) {
				results <- terraform
				locCount <- linesCount
			}
		// Bicep
		case ".bicep":
			if a.isAvailableType(bicep) {
				results <- arm
				locCount <- linesCount
			}
		// GRPC
		case ".proto":
			if a.isAvailableType(grpc) {
				results <- grpc
				locCount <- linesCount
			}
		// It could be Ansible Config or Ansible Inventory
		case ".cfg", ".conf", ".ini":
			if a.isAvailableType(ansible) {
				results <- ansible
				locCount <- linesCount
			}
		/* It could be Ansible, Buildah, CICD, CloudFormation, Crossplane, OpenAPI, Azure Resource Manager
		Docker Compose, Knative, Kubernetes, Pulumi, ServerlessFW or Google Deployment Manager.
		We also have FHIR's case which will be ignored since it's not a platform file.*/
		case yaml, yml, json, sh:
			a.checkContent(results, unwanted, locCount, linesCount, ext)
		}
	}
}

func isDockerfile(path string) bool {
	content, err := os.ReadFile(filepath.Clean(path))
	if err != nil {
		log.Error().Msgf("failed to analyze file: %s", err)
		return false
	}

	regexes := []*regexp.Regexp{
		regexp.MustCompile(`\s*FROM\s*`),
		regexp.MustCompile(`\s*RUN\s*`),
	}

	check := true

	for _, regex := range regexes {
		if !regex.Match(content) {
			check = false
			break
		}
	}

	return check
}

// overrides k8s match when all regexes pass for azureresourcemanager key and extension is set to json
func needsOverride(check bool, returnType, key, ext string) bool {
	if check && returnType == kubernetes && key == arm && ext == json {
		return true
	} else if check && returnType == kubernetes && (key == knative || key == crossplane) && (ext == yaml || ext == yml) {
		return true
	}
	return false
}

// checkContent will determine the file type by content when worker was unable to
// determine by ext, if no type was determined checkContent adds it to unwanted channel
func (a *analyzerInfo) checkContent(results, unwanted chan<- string, locCount chan<- int, linesCount int, ext string) {
	typesFlag := a.typesFlag
	excludeTypesFlag := a.excludeTypesFlag
	// get file content
	content, err := os.ReadFile(a.filePath)
	if err != nil {
		log.Error().Msgf("failed to analyze file: %s", err)
		return
	}

	returnType := ""

	// Sort map so that CloudFormation (type that as less required) goes last
	keys := make([]string, 0, len(types))
	for k := range types {
		keys = append(keys, k)
	}

	if typesFlag[0] != "" {
		keys = getKeysFromTypesFlag(typesFlag)
	} else if excludeTypesFlag[0] != "" {
		keys = getKeysFromExcludeTypesFlag(excludeTypesFlag)
	}

	sort.Sort(sort.Reverse(sort.StringSlice(keys)))

	for _, key := range keys {
		check := true
		for _, typeRegex := range types[key].regex {
			if !typeRegex.Match(content) {
				check = false
				break
			}
		}
		// If all regexes passed and there wasn't a type already assigned
		if check && returnType == "" {
			returnType = key
		} else if needsOverride(check, returnType, key, ext) {
			returnType = key
		}
	}

	// Check for blacklisted types for the detected returnType
	if isBlacklistedTypeMatch(returnType, content) {
		// File type is blacklisted, so we ignore it
		unwanted <- a.filePath
		return
	}

	returnType = checkReturnType(a.filePath, returnType, ext, content)
	if returnType == "" || !a.isAvailableType(returnType) {
		// No type was determined (ignore on parser)
		unwanted <- a.filePath
		return
	}

	results <- returnType
	locCount <- linesCount
}

func checkReturnType(path, returnType, ext string, content []byte) string {
	if returnType != "" {
		if returnType == "cdkTf" {
			return terraform
		}
		if utils.Contains(returnType, armRegexTypes) {
			return arm
		}
	} else if ext == yaml || ext == yml {
		if checkHelm(path) {
			return kubernetes
		}
		platform := checkYamlPlatform(content, path)
		if platform != "" {
			return platform
		}
	}
	return returnType
}

func checkHelm(path string) bool {
	_, err := os.Stat(filepath.Join(filepath.Dir(path), "Chart.yaml"))
	if errors.Is(err, os.ErrNotExist) {
		return false
	} else if err != nil {
		log.Error().Msgf("failed to check helm: %s", err)
	}

	return true
}

func checkYamlPlatform(content []byte, path string) string {
	content = utils.DecryptAnsibleVault(content, os.Getenv("ANSIBLE_VAULT_PASSWORD_FILE"))

	var yamlContent model.Document
	if err := yamlParser.Unmarshal(content, &yamlContent); err != nil {
		log.Warn().Msgf("failed to parse yaml file (%s): %s", path, err)
	}
	// check if it is google deployment manager platform
	for _, keyword := range listKeywordsGoogleDeployment {
		if _, ok := yamlContent[keyword]; ok {
			return gdm
		}
	}

	// check if the file contains some keywords related with Ansible
	if checkForAnsible(yamlContent) {
		return ansible
	}
	// check if the file contains some keywords related with Ansible Host
	if checkForAnsibleHost(yamlContent) {
		return ansible
	}
	// add for yaml files contained at paths (group_vars, host_vars) related with ansible
	if checkForAnsibleByPaths(path) {
		return ansible
	}
	return ""
}

func checkForAnsibleByPaths(path string) bool {
	return queryRegexPathsAnsible.MatchString(path)
}

func checkForAnsible(yamlContent model.Document) bool {
	isAnsible := false
	if play := yamlContent[playBooks]; play != nil {
		if listOfPlayBooks, ok := play.([]interface{}); ok {
			for _, value := range listOfPlayBooks {
				castingValue, ok := value.(map[string]interface{})
				if ok {
					for _, keyword := range listKeywordsAnsible {
						if _, ok := castingValue[keyword]; ok {
							isAnsible = true
						}
					}
				}
			}
		}
	}
	return isAnsible
}

func checkForAnsibleHost(yamlContent model.Document) bool {
	isAnsible := false
	for _, ansibleDefault := range ansibleHost {
		if hosts := yamlContent[ansibleDefault]; hosts != nil {
			if listHosts, ok := hosts.(map[string]interface{}); ok {
				for _, value := range listKeywordsAnsibleHots {
					if host := listHosts[value]; host != nil {
						isAnsible = true
					}
				}
			}
		}
	}
	return isAnsible
}

// computeValues computes expected Lines of Code to be scanned from locCount channel
// and creates the types and unwanted slices from the channels removing any duplicates
func computeValues(types, unwanted chan string, locCount chan int, done chan bool) (typesS, unwantedS []string, locTotal int) {
	var val int
	unwantedSlice := make([]string, 0)
	typeSlice := make([]string, 0)
	for {
		select {
		case i := <-locCount:
			val += i
		case i := <-unwanted:
			if !utils.Contains(i, unwantedSlice) {
				unwantedSlice = append(unwantedSlice, i)
			}
		case i := <-types:
			if !utils.Contains(i, typeSlice) {
				typeSlice = append(typeSlice, i)
			}
		case <-done:
			return typeSlice, unwantedSlice, val
		}
	}
}

// getKeysFromTypesFlag gets all the regexes keys related to the types flag
func getKeysFromTypesFlag(typesFlag []string) []string {
	ks := make([]string, 0, len(types))
	for i := range typesFlag {
		t := typesFlag[i]

		if regexes, ok := supportedRegexes[t]; ok {
			ks = append(ks, regexes...)
		}
	}
	return ks
}

// getKeysFromExcludeTypesFlag gets all the regexes keys related to the excluding unwanted types from flag
func getKeysFromExcludeTypesFlag(excludeTypesFlag []string) []string {
	ks := make([]string, 0, len(types))
	for k := range supportedRegexes {
		if !utils.Contains(k, excludeTypesFlag) {
			if regexes, ok := supportedRegexes[k]; ok {
				ks = append(ks, regexes...)
			}
		}
	}
	return ks
}

// isExcludedFile verifies if the path is pointed in the --exclude-paths flag
func isExcludedFile(path string, exc []string) bool {
	for i := range exc {
		exclude, err := provider.GetExcludePaths(exc[i])
		if err != nil {
			log.Err(err).Msg("failed to get exclude paths")
		}
		for j := range exclude {
			if exclude[j] == path {
				log.Info().Msgf("Excluded file %s from analyzer", path)
				return true
			}
		}
	}
	return false
}

func isDeadSymlink(path string) bool {
	fileInfo, _ := os.Stat(path)
	return fileInfo == nil
}

func isConfigFile(path string, exc []string) bool {
	for i := range exc {
		exclude, err := provider.GetExcludePaths(exc[i])
		if err != nil {
			log.Err(err).Msg("failed to get exclude paths")
		}
		for j := range exclude {
			fileInfo, _ := os.Stat(path)
			if fileInfo != nil && fileInfo.IsDir() {
				continue
			}

			if len(path)-len(exclude[j]) > 0 && path[len(path)-len(exclude[j]):] == exclude[j] && exclude[j] != "" {
				log.Info().Msgf("Excluded file %s from analyzer", path)
				return true
			}
		}
	}
	return false
}

// shouldConsiderGitIgnoreFile verifies if the scan should exclude the files according to the .gitignore file
func shouldConsiderGitIgnoreFile(path, gitIgnore string, excludeGitIgnoreFile bool) (hasGitIgnoreFileRes bool,
	gitIgnoreRes *ignore.GitIgnore) {
	gitIgnorePath := filepath.ToSlash(filepath.Join(path, gitIgnore))
	_, err := os.Stat(gitIgnorePath)

	if !excludeGitIgnoreFile && err == nil && gitIgnore != "" {
		gitIgnore, _ := ignore.CompileIgnoreFile(gitIgnorePath)
		if gitIgnore != nil {
			log.Info().Msgf(".gitignore file was found in '%s' and it will be used to automatically exclude paths", path)
			return true, gitIgnore
		}
	}
	return false, nil
}

func multiPlatformTypeCheck(typesSelected *[]string) {
	if utils.Contains("serverlessfw", *typesSelected) && !utils.Contains("cloudformation", *typesSelected) {
		*typesSelected = append(*typesSelected, "cloudformation")
	}
	if utils.Contains("knative", *typesSelected) && !utils.Contains("kubernetes", *typesSelected) {
		*typesSelected = append(*typesSelected, "kubernetes")
	}
}

func (a *analyzerInfo) isAvailableType(typeName string) bool {
	// no flag is set
	if len(a.typesFlag) == 1 && a.typesFlag[0] == "" && len(a.excludeTypesFlag) == 1 && a.excludeTypesFlag[0] == "" {
		return true
	} else if len(a.typesFlag) > 1 || a.typesFlag[0] != "" {
		// type flag is set
		return utils.Contains(typeName, a.typesFlag)
	} else if len(a.excludeTypesFlag) > 1 || a.excludeTypesFlag[0] != "" {
		// exclude type flag is set
		return !utils.Contains(typeName, a.excludeTypesFlag)
	}
	// no valid behavior detected
	return false
}

func (a *Analyzer) checkIgnore(fileSize int64, hasGitIgnoreFile bool,
	gitIgnore *ignore.GitIgnore,
	fullPath string, trimmedPath string, ignoreFiles []string) []string {
	exceededFileSize := a.MaxFileSize >= 0 && float64(fileSize)/float64(sizeMb) > float64(a.MaxFileSize)

	if (hasGitIgnoreFile && gitIgnore.MatchesPath(trimmedPath)) || isDeadSymlink(fullPath) || exceededFileSize {
		ignoreFiles = append(ignoreFiles, fullPath)
		a.Exc = append(a.Exc, fullPath)

		if exceededFileSize {
			log.Error().Msgf("file %s exceeds maximum file size of %d Mb", fullPath, a.MaxFileSize)
		}
	}
	return ignoreFiles
}

func typeLower(types, exclTypes []string) (typesRes, exclTypesRes []string) {
	for i := range types {
		types[i] = strings.ToLower(types[i])
	}

	for i := range exclTypes {
		exclTypes[i] = strings.ToLower(exclTypes[i])
	}

	return types, exclTypes
}

// isBlacklistedTypeMatch checks if any blacklisted regex for the given returnType matches the content.
func isBlacklistedTypeMatch(returnType string, content []byte) bool {
	if blMap, ok := blacklistedTypesRegexes[returnType]; ok {
		for _, bl := range blMap {
			for _, re := range bl.regex {
				if re.Match(content) {
					return true
				}
			}
		}
	}
	return false
}
