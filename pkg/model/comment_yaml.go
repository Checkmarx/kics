package model

import (
	"reflect"
	"strings"
	"sync"

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
	memoryMu  sync.Mutex
)

// build builds the ignore struct
func (i *Ignore) build(lines []int) {
	defer memoryMu.Unlock()
	memoryMu.Lock()
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
		// Sequence Node - Head Comment comes in root node
		linesIgnore = append(linesIgnore, processCommentYAML((*comment)(&node.HeadComment), 0, node, node.Kind, false)...)
		NewIgnore.build(linesIgnore)
		return
	}
	// check if comment is in the content
	for i, content := range node.Content {
		if content.FootComment != "" && i+2 < len(node.Content) {
			linesIgnore = append(linesIgnore, processCommentYAML((*comment)(&content.FootComment), i+2, node, node.Kind, true)...)
		}
		if content.HeadComment == "" {
			continue
		}
		linesIgnore = append(linesIgnore, processCommentYAML((*comment)(&content.HeadComment), i, node, node.Kind, false)...)
	}

	NewIgnore.build(linesIgnore)
}

// processCommentYAML returns the lines to ignore
func processCommentYAML(comment *comment, position int, content *yaml.Node, kind yaml.Kind, isFooter bool) (linesIgnore []int) {
	linesIgnore = make([]int, 0)
	switch com := (*comment).value(); com {
	case IgnoreLine:
		linesIgnore = append(linesIgnore, processLine(kind, content, position)...)
	case IgnoreBlock:
		linesIgnore = append(linesIgnore, processBlock(kind, content.Content, position)...)
	default:
		linesIgnore = append(linesIgnore, processRegularLine(string(*comment), content, position, isFooter)...)
	}

	return
}

func getSeqLastLine(content *yaml.Node) int {
	if len(content.Content) == 0 {
		return content.Line
	}

	return content.Content[len(content.Content)-1].Line
}

func getFootComments(comment string, content *yaml.Node, position, commentsNumber int) (linesIgnore []int) {
	// get the right position where the comment is a foot comment
	for content.Content[position].FootComment == comment {
		position--
	}

	line := content.Content[position].Line
	nextSequencePosition := position + 1

	if nextSequencePosition < len(content.Content) &&
		content.Content[nextSequencePosition].Kind == yaml.SequenceNode {
		// get the last line of the sequence through the sequence after the content that has the comment as a foot comment
		// example:
		// - proto: tcp  // content.Content[position]
		//   ports:      // content.Content[nextSequencePosition]
		//     - 80
		//     - 443    //  last line of the sequence
		//   # public ALB 80 + 443 must be access able from everywhere
		line = getSeqLastLine(content.Content[nextSequencePosition])
	}

	for i := 1; i <= commentsNumber; i++ {
		linesIgnore = append(linesIgnore, line+i)
	}

	return
}

func processRegularLine(comment string, content *yaml.Node, position int, isFooter bool) (linesIgnore []int) {
	linesIgnore = make([]int, 0)

	if len(content.Content) == 0 {
		return linesIgnore
	}

	line := content.Content[position].Line
	commentsNumber := strings.Count(comment, "\n") + 1 // number of comments (coverage of nested comments)

	if isFooter { // comment is a foot comment
		return getFootComments(comment, content, position, commentsNumber)
	}

	// comment is not a foot comment

	if KICSCommentRgxpYaml.MatchString(comment) {
		// has kics-scan ignore at the end of the comment
		linesIgnore = append(linesIgnore, line)
	}

	for i := 1; i <= commentsNumber; i++ {
		linesIgnore = append(linesIgnore, line-i)
	}

	return linesIgnore
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
	if len(node.Content) > 0 {
		for _, content := range node.Content {
			if content.Line > lastLine {
				lastLine = content.Line
			}
			if lineContent := getNodeLastLine(content); lineContent > lastLine {
				lastLine = lineContent
			}
		}
	} else if reflect.TypeOf(node.Value).Kind() == reflect.String {
		lastLine += strings.Count(node.Value, "\n")
	}

	return
}

// value returns the value of the comment
func (c *comment) value() (value CommentCommand) {
	comment := strings.ToLower(string(*c))
	if isHelm(comment) {
		res := KICSGetContentCommentRgxp.FindString(comment)
		if res != "" {
			comment = res
		}
	}
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

func isHelm(comment string) bool {
	return strings.Contains(comment, "helm")
}
