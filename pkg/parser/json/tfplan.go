package json

import (
	"encoding/json"

	"github.com/Checkmarx/kics/pkg/model"
	hcl_plan "github.com/hashicorp/terraform-json"
)

// KicsPlan is an auxiliary structure for parsing tfplans as a KICS Document
type KicsPlan struct {
	Resource map[string]KicsPlanResource `json:"resource"`
}

// KicsPlanResource is an auxiliary structure for parsing tfplans as a KICS Document
type KicsPlanResource map[string]KicsPlanNamedResource

// KicsPlanNamedResource is an auxiliary structure for parsing tfplans as a KICS Document
type KicsPlanNamedResource map[string]interface{}

// parseTFPlan unmarshals Document as a plan so it can be rebuilt with only
// the required information
func parseTFPlan(doc model.Document) (model.Document, error) {
	var plan *hcl_plan.Plan
	b, err := json.Marshal(doc)
	if err != nil {
		return model.Document{}, err
	}
	// Unmarshal our Document as a plan so we are able retrieve planned_values
	// in a easier way
	err = json.Unmarshal(b, &plan)
	if err != nil {
		// Consider as regular JSON and not tfplan
		return model.Document{}, err
	}

	parsedPlan := readPlan(plan)
	return parsedPlan, nil
}

// readPlan will get the information needed and parse it in a way KICS understands it
func readPlan(p *hcl_plan.Plan) model.Document {
	modRes := readModule(p.PlannedValues.RootModule.Resources)

	doc := model.Document{}

	kp := KicsPlan{
		Resource: modRes,
	}
	b, err := json.Marshal(kp)
	if err != nil {
		return model.Document{}
	}
	err = json.Unmarshal(b, &doc)
	if err != nil {
		return model.Document{}
	}

	return doc
}

// readModule will iterate over all planned_value getting the information required
func readModule(r []*hcl_plan.StateResource) map[string]KicsPlanResource {
	convRes := make(map[string]KicsPlanResource)
	// initialize all the types interfaces
	for _, resource := range r {
		convNamedRes := make(map[string]KicsPlanNamedResource)
		convRes[resource.Type] = convNamedRes
	}
	// fill in all the types interfaces
	for _, resource := range r {
		convRes[resource.Type][resource.Name] = resource.AttributeValues
	}
	return convRes
}
