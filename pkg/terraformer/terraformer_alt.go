//go:build dev
// +build dev

package terraformer

/*
	Since terraformer import is very big, this creates problems for the dev env
	regarding CPU and MEM usage.
	To fix this issue an alternative terraformer file is used which disables terraformer,
	and mocks the import function.
	To use this alternative terraformer file, be sure to run kics with the tag "dev".
*/

// Import is a mock function that does nothing
func Import(terraformerPath, destinationPath string) (string, error) {
	return "", nil
}
