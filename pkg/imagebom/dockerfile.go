package imagebom

import (
	"strings"

	"github.com/rs/zerolog/log"
)

// extractDockerfileImages pulls base images from the parsed representation of a
// Dockerfile. Stage aliases (FROM <stage>), "scratch" and templated references
// (FROM ${VAR}) are skipped since they are not scannable images.
func extractDockerfileImages(doc map[string]interface{}, file string) []Image {
	commands, ok := doc["command"].(map[string]interface{})
	if !ok {
		return nil
	}

	fromCommands := collectFromCommands(commands)
	aliases := stageAliases(fromCommands)

	images := make([]Image, 0, len(fromCommands))
	for _, cmd := range fromCommands {
		ref := fromImage(cmd)
		if ref == "" || ref == "scratch" || strings.Contains(ref, "$") {
			continue
		}
		if aliases[strings.ToLower(ref)] {
			continue
		}

		img, err := ParseImageRef(ref)
		if err != nil {
			log.Warn().Msgf("image-bom: skipping unparseable Dockerfile image %q in %s: %v", ref, file, err)
			continue
		}
		img.Sources = []Source{{File: file, Line: fromLine(cmd)}}
		images = append(images, img)
	}

	return images
}

// collectFromCommands returns every "from" command across all build stages.
func collectFromCommands(commands map[string]interface{}) []map[string]interface{} {
	var froms []map[string]interface{}
	for _, stage := range commands {
		list, ok := stage.([]interface{})
		if !ok {
			continue
		}
		for _, entry := range list {
			cmd, ok := entry.(map[string]interface{})
			if !ok {
				continue
			}
			if cmd["Cmd"] == "from" {
				froms = append(froms, cmd)
			}
		}
	}
	return froms
}

// stageAliases returns the set of build-stage names (FROM <img> AS <alias>).
func stageAliases(froms []map[string]interface{}) map[string]bool {
	aliases := make(map[string]bool)
	for _, cmd := range froms {
		values := stringSlice(cmd["Value"])
		if len(values) >= 3 && strings.EqualFold(values[1], "as") {
			aliases[strings.ToLower(values[2])] = true
		}
	}
	return aliases
}

// fromImage returns the image reference of a "from" command.
func fromImage(cmd map[string]interface{}) string {
	values := stringSlice(cmd["Value"])
	if len(values) == 0 {
		return ""
	}
	return values[0]
}

func fromLine(cmd map[string]interface{}) int {
	if line, ok := cmd["_kics_line"].(float64); ok {
		return int(line)
	}
	return 0
}

func stringSlice(v interface{}) []string {
	raw, ok := v.([]interface{})
	if !ok {
		return nil
	}
	out := make([]string, 0, len(raw))
	for _, item := range raw {
		if s, ok := item.(string); ok {
			out = append(out, s)
		}
	}
	return out
}
