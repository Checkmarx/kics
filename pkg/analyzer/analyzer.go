package analyzer

import (
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"sync"

	"github.com/Checkmarx/kics/internal/metrics"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/utils"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"

	yamlParser "gopkg.in/yaml.v3"
)

// openAPIRegex - Regex that finds OpenAPI defining property "openapi" or "swagger"
// openAPIRegexInfo - Regex that finds OpenAPI defining property "info"
// openAPIRegexPath - Regex that finds OpenAPI defining property "paths", "components", or "webhooks" (from 3.1.0)
// cloudRegex - Regex that finds CloudFormation defining property "Resources"
// k8sRegex - Regex that finds Kubernetes defining property "apiVersion"
// k8sRegexKind - Regex that finds Kubernetes defining property "kind"
// k8sRegexMetadata - Regex that finds Kubernetes defining property "metadata"
// k8sRegexSpec - Regex that finds Kubernetes defining property "spec"
var (
	openAPIRegex                                    = regexp.MustCompile("\\s*\"?(openapi|swagger)\"?\\s*:")
	openAPIRegexInfo                                = regexp.MustCompile("\\s*\"?info\"?\\s*:")
	openAPIRegexPath                                = regexp.MustCompile("\\s*\"?(paths|components|webhooks)\"?\\s*:")
	armRegexContentVersion                          = regexp.MustCompile("\\s*\"contentVersion\"\\s*:")
	armRegexResources                               = regexp.MustCompile("\\s*\"resources\"\\s*:")
	cloudRegex                                      = regexp.MustCompile("\\s*\"?Resources\"?\\s*:")
	k8sRegex                                        = regexp.MustCompile("\\s*\"?apiVersion\"?\\s*:")
	k8sRegexKind                                    = regexp.MustCompile("\\s*\"?kind\"?\\s*:")
	ansibleVaultRegex                               = regexp.MustCompile(`^\s*\$ANSIBLE_VAULT.*`)
	tfPlanRegexPV                                   = regexp.MustCompile("\\s*\"planned_values\"\\s*:")
	tfPlanRegexRC                                   = regexp.MustCompile("\\s*\"resource_changes\"\\s*:")
	tfPlanRegexConf                                 = regexp.MustCompile("\\s*\"configuration\"\\s*:")
	tfPlanRegexTV                                   = regexp.MustCompile("\\s*\"terraform_version\"\\s*:")
	cdkTfRegexMetadata                              = regexp.MustCompile("\\s*\"metadata\"\\s*:")
	cdkTfRegexStackName                             = regexp.MustCompile("\\s*\"stackName\"\\s*:")
	cdkTfRegexTerraform                             = regexp.MustCompile("\\s*\"terraform\"\\s*:")
	artifactsRegexKind                              = regexp.MustCompile("\\s*\"?kind\"?\\s*:")
	artifactsRegexProperties                        = regexp.MustCompile("\\s*\"?properties\"?\\s*:")
	artifactsRegexParametes                         = regexp.MustCompile("\\s*\"?parameters\"?\\s*:")
	policyAssignmentArtifactRegexPolicyDefinitionID = regexp.MustCompile("\\s*\"?policyDefinitionId\"?\\s*:")
	roleAssignmentArtifactRegexPrincipalIds         = regexp.MustCompile("\\s*\"?principalIds\"?\\s*:")
	roleAssignmentArtifactRegexRoleDefinitionID     = regexp.MustCompile("\\s*\"?roleDefinitionId\"?\\s*:")
	templateArtifactRegexParametes                  = regexp.MustCompile("\\s*\"?template\"?\\s*:")
	blueprintpRegexTargetScope                      = regexp.MustCompile("\\s*\"?targetScope\"?\\s*:")
	blueprintpRegexProperties                       = regexp.MustCompile("\\s*\"?properties\"?\\s*:")
	buildahRegex                                    = regexp.MustCompile(`\s*buildah\s*from\s*\w+`)
	dockerComposeVersionRegex                       = regexp.MustCompile(`\s*version\s*:`)
	dockerComposeServicesRegex                      = regexp.MustCompile(`\s*services\s*:`)
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
	}
	supportedRegexes = map[string][]string{
		"azureresourcemanager": append(armRegexTypes, arm),
		"buildah":              {"buildah"},
		"cloudformation":       {"cloudformation"},
		"dockercompose":        {"dockercompose"},
		"kubernetes":           {"kubernetes"},
		"openapi":              {"openapi"},
		"terraform":            {"terraform", "cdkTf"},
	}
)

const (
	yml        = ".yml"
	yaml       = ".yaml"
	json       = ".json"
	sh         = ".sh"
	arm        = "azureresourcemanager"
	kubernetes = "kubernetes"
	terraform  = "terraform"
	gdm        = "googledeploymentmanager"
	ansible    = "ansible"
	grpc       = "grpc"
	dockerfile = "dockerfile"
)

// regexSlice is a struct to contain a slice of regex
type regexSlice struct {
	regex []*regexp.Regexp
}

type analyzerInfo struct {
	typesFlag []string
	filePath  string
}

// types is a map that contains the regex by type
var types = map[string]regexSlice{
	"openapi": {
		regex: []*regexp.Regexp{
			openAPIRegex,
			openAPIRegexInfo,
			openAPIRegexPath,
		},
	},
	"kubernetes": {
		regex: []*regexp.Regexp{
			k8sRegex,
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
			artifactsRegexParametes,
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
			artifactsRegexParametes,
			templateArtifactRegexParametes,
		},
	},
	"blueprint": {
		[]*regexp.Regexp{
			blueprintpRegexTargetScope,
			blueprintpRegexProperties,
		},
	},
	"buildah": {
		[]*regexp.Regexp{
			buildahRegex,
		},
	},
	"dockercompose": {
		[]*regexp.Regexp{
			dockerComposeVersionRegex,
			dockerComposeServicesRegex,
		},
	},
}

// Analyze will go through the slice paths given and determine what type of queries should be loaded
// should be loaded based on the extension of the file and the content
func Analyze(paths, types, exc []string) (model.AnalyzedPaths, error) {
	// start metrics for file analyzer
	metrics.Metric.Start("file_type_analyzer")
	returnAnalyzedPaths := model.AnalyzedPaths{
		Types: make([]string, 0),
		Exc:   make([]string, 0),
	}

	var files []string
	var wg sync.WaitGroup
	// results is the channel shared by the workers that contains the types found
	results := make(chan string)

	// get all the files inside the given paths
	for _, path := range paths {
		if _, err := os.Stat(path); err != nil {
			return returnAnalyzedPaths, errors.Wrap(err, "failed to analyze path")
		}
		if err := filepath.Walk(path, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			ext := utils.GetExtension(path)

			if _, ok := possibleFileTypes[ext]; ok && !isExcludedFile(path, exc) {
				files = append(files, path)
			}

			return nil
		}); err != nil {
			log.Error().Msgf("failed to analize path %s: %s", path, err)
		}
	}

	// unwanted is the channel shared by the workers that contains the unwanted files that the parser will ignore
	unwanted := make(chan string, len(files))

	for i := range types {
		types[i] = strings.ToLower(types[i])
	}

	for _, file := range files {
		wg.Add(1)
		// analyze the files concurrently
		a := &analyzerInfo{
			typesFlag: types,
			filePath:  file,
		}
		go a.worker(results, unwanted, &wg)
	}

	go func() {
		// close channel results when the worker has finished writing into it
		defer func() {
			close(unwanted)
			close(results)
		}()
		wg.Wait()
	}()

	availableTypes := createSlice(results)
	unwantedPaths := createSlice(unwanted)
	returnAnalyzedPaths.Types = availableTypes
	returnAnalyzedPaths.Exc = unwantedPaths
	// stop metrics for file analyzer
	metrics.Metric.Stop()
	return returnAnalyzedPaths, nil
}

// worker determines the type of the file by ext (dockerfile and terraform)/content and
// writes the answer to the results channel
// if no types were found, the worker will write the path of the file in the unwanted channel
func (a *analyzerInfo) worker(results, unwanted chan<- string, wg *sync.WaitGroup) {
	defer wg.Done()

	ext := utils.GetExtension(a.filePath)

	typesFlag := a.typesFlag

	switch ext {
	// Dockerfile (direct identification)
	case ".dockerfile", "Dockerfile":
		if typesFlag[0] == "" || utils.Contains(dockerfile, typesFlag) {
			results <- dockerfile
		}
	// Dockerfile (indirect identification)
	case "possibleDockerfile", ".ubi8", ".debian":
		if (typesFlag[0] == "" || utils.Contains(dockerfile, typesFlag)) && isDockerfile(a.filePath) {
			results <- dockerfile
		}
	// Terraform
	case ".tf", "tfvars":
		if typesFlag[0] == "" || utils.Contains(terraform, typesFlag) {
			results <- terraform
		}
	// GRPC
	case ".proto":
		if typesFlag[0] == "" || utils.Contains(grpc, typesFlag) {
			results <- grpc
		}
	// Cloud Formation, Ansible, OpenAPI, Buildah
	case yaml, yml, json, sh:
		a.checkContent(results, unwanted, ext)
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

// overrides k8s match when all regexs passes for azureresourcemanager key and extension is set to json
func needsOverride(check bool, returnType, key, ext string) bool {
	if check && returnType == kubernetes && key == arm && ext == json {
		return true
	}
	return false
}

// checkContent will determine the file type by content when worker was unable to
// determine by ext, if no type was determined checkContent adds it to unwanted channel
func (a *analyzerInfo) checkContent(results, unwanted chan<- string, ext string) {
	typesFlag := a.typesFlag
	// get file content
	content, err := os.ReadFile(a.filePath)
	if err != nil {
		log.Error().Msgf("failed to analyze file: %s", err)
		return
	}

	returnType := ""

	// Sort map so that CloudFormation (type that as less requireds) goes last
	keys := make([]string, 0, len(types))
	for k := range types {
		keys = append(keys, k)
	}

	if typesFlag[0] != "" {
		keys = getKeysFromTypesFlag(typesFlag)
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
		// If all regexs passed and there wasn't a type already assigned
		if check && returnType == "" {
			returnType = key
		} else if needsOverride(check, returnType, key, ext) {
			returnType = key
		}
	}
	returnType = checkReturnType(a.filePath, returnType, ext, content)
	if returnType != "" {
		if typesFlag[0] == "" || utils.Contains(returnType, typesFlag) {
			results <- returnType
			return
		}
	}
	// No type was determined (ignore on parser)
	unwanted <- a.filePath
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
	// check if it is an ansible vault
	if !ansibleVaultRegex.Match(content) {
		// Since Ansible has no defining property
		// and no other type matched for YAML file extension, assume the file type is Ansible
		return ansible
	}
	return ""
}

// createSlice creates a slice from the channel given removing any duplicates
func createSlice(chanel chan string) []string {
	slice := make([]string, 0)
	for i := range chanel {
		if !utils.Contains(i, slice) {
			slice = append(slice, i)
		}
	}
	return slice
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
