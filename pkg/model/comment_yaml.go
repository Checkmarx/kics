package model

import (
	"strings"

	"gopkg.in/yaml.v3"
)

// comment is a struct that holds the comment
type comment string

// Ignore is a struct that holds the lines to ignore
type Ignore struct {
	// Lines is the lines to ignore
	Lines []int
}

var (
	// NewIgnore is the ignore struct
	NewIgnore = &Ignore{}
)

// build builds the ignore struct
func (i *Ignore) build(lines []int) {
	i.Lines = append(i.Lines, lines...)
}

// GetLines returns the lines to ignore
func (i *Ignore) GetLines() []int {
	return RemoveDuplicates(i.Lines)
}

// Reset resets the ignore struct
func (i *Ignore) Reset() {
	i.Lines = make([]int, 0)
}

// ignoreCommentsYAML sets the lines to ignore for a yaml file
func ignoreCommentsYAML(node *yaml.Node) {
	linesIgnore := make([]int, 0)
	if node.HeadComment != "" {
		// Squence Node - Head Comment comes in root node
		linesIgnore = append(linesIgnore, processCommentYAML((*comment)(&node.HeadComment), 0, node, node.Kind)...)
		NewIgnore.build(linesIgnore)
		return
	}
	// check if comment is in the content
	for i, content := range node.Content {
		if content.FootComment != "" && i+2 < len(node.Content) {
			linesIgnore = append(linesIgnore, processCommentYAML((*comment)(&content.FootComment), i+2, node, node.Kind)...) //nolint
		}
		if content.HeadComment == "" {
			continue
		}
		linesIgnore = append(linesIgnore, processCommentYAML((*comment)(&content.HeadComment), i, node, node.Kind)...)
	}

	NewIgnore.build(linesIgnore)
}

// processCommentYAML returns the lines to ignore
func processCommentYAML(comment *comment, position int, content *yaml.Node, kind yaml.Kind) (linesIgnore []int) {
	linesIgnore = make([]int, 0)
	switch com := (*comment).value(); com {
	case IgnoreLine:
		linesIgnore = append(linesIgnore, processLine(kind, content, position)...)
	case IgnoreBlock:
		linesIgnore = append(linesIgnore, processBlock(kind, content.Content, position)...)
	}

	return
}

// processLine returns the lines to ignore for a line
func processLine(kind yaml.Kind, content *yaml.Node, position int) (linesIgnore []int) {
	linesIgnore = make([]int, 0)
	var nodeToIgnore *yaml.Node
	if kind == yaml.ScalarNode {
		nodeToIgnore = content
	} else {
		nodeToIgnore = content.Content[position]
	}
	linesIgnore = append(linesIgnore, nodeToIgnore.Line-1, nodeToIgnore.Line)
	return
}

// processBlock returns the lines to ignore for a block
func processBlock(kind yaml.Kind, content []*yaml.Node, position int) (linesIgnore []int) {
	linesIgnore = make([]int, 0)
	var contentToIgnore []*yaml.Node
	if kind == yaml.SequenceNode {
		contentToIgnore = content[position].Content
	} else if position == 0 {
		contentToIgnore = content
	} else {
		contentToIgnore = content[position+1].Content
	}

	linesIgnore = append(linesIgnore, content[position].Line, content[position].Line-1)
	linesIgnore = append(linesIgnore, Range(contentToIgnore[0].Line,
		getNodeLastLine(contentToIgnore[len(contentToIgnore)-1]))...)
	return
}

// getNodeLastLine returns the last line of a node
func getNodeLastLine(node *yaml.Node) (lastLine int) {
	lastLine = node.Line
	for _, content := range node.Content {
		if content.Line > lastLine {
			lastLine = content.Line
		}
		if lineContent := getNodeLastLine(content); lineContent > lastLine {
			lastLine = lineContent
		}
	}

	return
}

// value returns the value of the comment
func (c *comment) value() (value CommentCommand) {
	comment := strings.ToLower(string(*c))
	// check if we are working with kics command
	if KICSCommentRgxp.MatchString(comment) {
		comment = KICSCommentRgxp.ReplaceAllString(comment, "")
		comment = strings.Trim(comment, "\n")
		commands := strings.Split(strings.Trim(comment, "\r"), " ")
		value = ProcessCommands(commands)
		return
	}
	return CommentCommand(comment)
}
