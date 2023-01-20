// integrations with kicsGPT proxy
package kicsgpt

var (
	gptClient HTTPKicsGPT = &Client{}
)

func GetFileEvaluation(fileData string) error {
	if err := gptClient.CheckConnection(); err != nil {
		return err
	}

	output, err := gptClient.RequestEvaluation(fileData)
	_, _ = output, err

	return nil
}
