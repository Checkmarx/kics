package utils

import (
	"bufio"

	"os"
)

// CountLines counts the number of lines in a file

func CountLines(filePath string) (int, error) {

	file, err := os.Open(filePath)

	if err != nil {

		return 0, err

	}

	defer file.Close()

	scanner := bufio.NewScanner(file)

	lineCount := 0

	for scanner.Scan() {

		lineCount++

	}
	return lineCount, scanner.Err()

}
