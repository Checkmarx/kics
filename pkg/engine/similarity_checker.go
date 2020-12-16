package engine

func computeSimilarityID(filePath string, queryID string, searchKey string) int {

	var stringNode string = filePath + queryID + searchKey

	return getHashCode(stringNode)
}

func getHashCode(s string) int {
	var hashCode = 0
	for _, runeChar := range s {
		hashCode = hashCode*31 + int(runeChar)
	}
	return hashCode
}
