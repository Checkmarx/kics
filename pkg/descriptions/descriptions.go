package descriptions

import "github.com/Checkmarx/kics/pkg/model"

var (
	descClient HTTPDescription = &Client{}
)

// RequestAndOverrideDescriptions - Requests CIS descriptions and override default descriptions
func RequestAndOverrideDescriptions(summary *model.Summary) error {
	descriptionIDs := make([]string, 0)
	for idx := range summary.Queries {
		descriptionIDs = append(descriptionIDs, summary.Queries[idx].DescriptionID)
	}

	descriptionMap, err := descClient.RequestDescriptions(descriptionIDs)
	if err != nil {
		return err
	}

	for idx := range summary.Queries {
		summary.Queries[idx].CISDescriptionID = descriptionMap[summary.Queries[idx].DescriptionID].DescriptionID
		summary.Queries[idx].CISDescriptionTitle = descriptionMap[summary.Queries[idx].DescriptionID].DescriptionTitle
		summary.Queries[idx].CISDescriptionText = descriptionMap[summary.Queries[idx].DescriptionID].RationaleText
	}
	return nil
}
