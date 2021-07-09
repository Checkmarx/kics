package helpers

import (
	"github.com/Checkmarx/kics/pkg/description"
	"github.com/Checkmarx/kics/pkg/model"
)

func RequestAndOverrideDescriptions(summary *model.Summary) error {
	descriptionIDs := make([]string, 0)
	for idx := range summary.Queries {
		descriptionIDs = append(descriptionIDs, summary.Queries[idx].DescriptionID)
	}

	descriptionMap, err := description.GetDescriptions(descriptionIDs)
	if err != nil {
		return err
	}

	for idx := range summary.Queries {
		descriptionText, ok := descriptionMap[summary.Queries[idx].DescriptionID]
		if ok {
			summary.Queries[idx].Description = descriptionText
		}
	}
	return nil
}
