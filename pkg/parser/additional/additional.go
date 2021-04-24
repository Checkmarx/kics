package additional

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"

	"github.com/rs/zerolog/log"
	"gopkg.in/yaml.v2"
)

func checkConvertingError(err error) {
	if err != nil {
		log.Error().Msg("Failed to convert 'string' into 'int'")
	}
}

func getRegexMatch(regex, text string) string {
	var re = regexp.MustCompile(regex)
	clean := re.FindAllString(text, -1)

	if clean == nil {
		return ""
	}

	return clean[0]
}

func getExpirationDate(datetime string) [3]int {
	// get notAfter datetime
	expirationInfo := getRegexMatch(`(notAfter=)[a-zA-Z]+[ ]+[0-9]{1,2}[ ]([0-9]{2}:[0-9]{2}:[0-9]{2})[ ][0-9]{4}`, datetime)
	clean := strings.Split(expirationInfo, "=")

	months := map[string]int{
		"Jan": 1,
		"Feb": 2,
		"Mar": 3,
		"Apr": 4,
		"May": 5,
		"Jun": 6,
		"Jul": 7,
		"Aug": 8,
		"Sep": 9,
		"Oct": 10,
		"Nov": 11,
		"Dec": 12,
	}

	// pick month
	cleanMonth := getRegexMatch(`^[a-zA-Z]+`, clean[1])
	month := months[cleanMonth]

	// pick year
	cleanYear := getRegexMatch(`[0-9]{4}`, clean[1])
	year, errYear := strconv.Atoi(cleanYear)
	checkConvertingError(errYear)

	// pick day
	cleanDay := getRegexMatch(`[ ][0-9]{1,2}`, clean[1])
	day, errDay := strconv.Atoi(strings.ReplaceAll(cleanDay, " ", ""))
	checkConvertingError(errDay)

	var date [3]int
	date[0] = year
	date[1] = month
	date[2] = day

	return date
}

func expirationDateFromPemCertificate(filePath string) [3]int {
	out, err := exec.Command("openssl", "x509", "-in", filePath, "-noout", "-dates").Output()
	if err != nil {
		log.Error().Msgf("Failed to execute command 'openssl x509 -in %s -noout -dates'", filePath)
	}

	date := getExpirationDate(string(out))

	return date
}

func getBitRSAKeyBit(filePath string) int {
	out, err := exec.Command("openssl", "x509", "-in", filePath, "-text", "-noout").Output()

	if err != nil {
		log.Error().Msgf("Failed to execute command 'openssl x509 -in %s -text -noout'", filePath)
		return -1
	}

	rsaInfo := getRegexMatch(`RSA Public-Key:[ ]\([0-9]{4}[ ]bit\)`, string(out))

	bits := getRegexMatch(`[0-9]{4}`, rsaInfo)
	rsabits, err := strconv.Atoi(bits)
	checkConvertingError(err)

	return rsabits
}

func getFullPath(path, attributeContent, regex string) string {
	dir := filepath.Dir(path)
	file := getRegexMatch(regex, attributeContent)

	filePath := filepath.Join(dir, file)

	return filePath
}

// AddCertificateInfo gets and adds certificate information of a certificate file
func AddCertificateInfo(path, content string) map[string]interface{} {
	var filePath string

	if _, err := os.Stat(content); err != nil { // content is not a full valid path or is an incomplete path
		filePath = getFullPath(path, content, `[0-9a-zA-Z-\/\\_]+\.pem`)
	} else { // content is a full valid path
		filePath = content
	}

	expirationDate := expirationDateFromPemCertificate(filePath)

	if len(expirationDate) != 0 {
		attributes := make(map[string]interface{})
		attributes["file"] = filePath
		attributes["expiration_date"] = expirationDate

		rsaKeyBits := getBitRSAKeyBit(filePath)
		if rsaKeyBits != -1 {
			attributes["bit_rsa_key"] = rsaKeyBits
		}
		return attributes
	}

	return nil
}

func convert(m map[interface{}]interface{}) map[string]interface{} {
	res := map[string]interface{}{}
	for k, v := range m {
		switch v2 := v.(type) {
		case map[interface{}]interface{}:
			res[fmt.Sprint(k)] = convert(v2)
		default:
			res[fmt.Sprint(k)] = v
		}
	}
	return res
}

func readFile(filePath string) map[string]interface{} {
	var result map[string]interface{}

	content, err := os.ReadFile(filePath)
	if err != nil {
		log.Error().Msgf("Failed to read %s", filePath)
	}

	fileExtension := filepath.Ext(filePath)

	if fileExtension == ".json" {
		err := json.Unmarshal(content, &result)
		if err != nil {
			log.Error().Msgf("Failed to unmarshal '%s'", fileExtension)
		}
	} else if fileExtension == ".yaml" || fileExtension == ".yml" {
		var resultYaml map[interface{}]interface{}
		err := yaml.Unmarshal(content, &resultYaml)
		if err != nil {
			log.Error().Msgf("Failed to unmarshal '%s'", fileExtension)
		}
		result = convert(resultYaml)
	}

	return result
}

// AddSwaggerInfo gets and adds the content of a swagger file
func AddSwaggerInfo(path, swaggerPath string) map[string]interface{} {
	var filePath string

	if _, err := os.Stat(swaggerPath); err != nil { // content is not a full valid path or is an incomplete path
		filePath = getFullPath(path, swaggerPath, `[0-9a-zA-Z-/\\_]+\.(json|y(a)?ml)`)
	} else { // content is a full valid path
		filePath = swaggerPath
	}

	swaggerContent := readFile(filePath)
	if len(swaggerContent) != 0 {
		attributes := make(map[string]interface{})
		attributes["file"] = filePath
		attributes["content"] = swaggerContent
		return attributes
	}

	return nil
}
