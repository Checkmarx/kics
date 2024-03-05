package converter

// map[string]interface{}
/*
InLineDescriptions    string `json:"singleDescriptions"`
MultiLineDescriptions string `json:"multiDescriptions"`
*/
type BicepSyntax struct {
	Param     Param     `json:"param"`
	Variables Variable  `json:"variables"`
	Resources Resource  `json:"resources"`
	Outputs   Output    `json:"outputs"`
	Modules   Module    `json:"modules"`
	Metadata  *Metadata `json:"metadata"`
}

type Metadata struct {
	Description string `json:"description"`
	Name        string `json:"name"`
}

type Param struct {
	Name         string    `json:"paramName"`
	Type         string    `json:"paramType"`
	DefaultValue string    `json:"paramDefaultValue"`
	Metadata     *Metadata `json:"paramMetadata"`
}

type Variable struct {
	Name        string `json:"varName"`
	Type        string `json:"varType"`
	Description string `json:"varDescription"`
}

type Resource struct {
	Name        string `json:"resName"`
	Type        string `json:"resType"`
	Description string `json:"resDescription"`
}

type Output struct {
	Name        string `json:"outName"`
	Type        string `json:"outType"`
	Description string `json:"outDescription"`
}

type Module struct {
	Name        string `json:"modName"`
	Path        string `json:"modPath"`
	Description string `json:"modDescription"`
}
