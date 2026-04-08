package utils

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestReadFileToUTF8(t *testing.T) {
	tests := []struct {
		name       string
		content    []byte
		want       string
		wantError  bool
		createFile bool
	}{
		{
			name:       "UTF-8 JSON file",
			content:    []byte(`{"key": "value", "number": 123}`),
			want:       `{"key": "value", "number": 123}`,
			wantError:  false,
			createFile: true,
		},
		{
			name: "UTF-16 LE with BOM - Terraform plan JSON",
			content: []byte{
				0xFF, 0xFE, // BOM
				'{', 0x00, '"', 0x00, 't', 0x00, 'e', 0x00, 'r', 0x00, 'r', 0x00, 'a', 0x00,
				'f', 0x00, 'o', 0x00, 'r', 0x00, 'm', 0x00, '_', 0x00, 'v', 0x00, 'e', 0x00,
				'r', 0x00, 's', 0x00, 'i', 0x00, 'o', 0x00, 'n', 0x00, '"', 0x00, ':', 0x00,
				'"', 0x00, '1', 0x00, '.', 0x00, '0', 0x00, '"', 0x00, '}', 0x00,
			},
			want:       `{"terraform_version":"1.0"}`,
			wantError:  false,
			createFile: true,
		},
		{
			name: "UTF-16 BE with BOM",
			content: []byte{
				0xFE, 0xFF, // BOM
				0x00, '{', 0x00, '"', 0x00, 'k', 0x00, 'e', 0x00, 'y', 0x00, '"', 0x00, '}',
			},
			want:       `{"key"}`,
			wantError:  false,
			createFile: true,
		},
		{
			name: "UTF-8 Terraform file",
			content: []byte(`resource "aws_s3_bucket" "example" {
  bucket = "my-test-bucket"
}`),
			want: `resource "aws_s3_bucket" "example" {
  bucket = "my-test-bucket"
}`,
			wantError:  false,
			createFile: true,
		},
		{
			name:       "UTF-8 with special characters",
			content:    []byte(`{"name":"José","city":"São Paulo"}`),
			want:       `{"name":"José","city":"São Paulo"}`,
			wantError:  false,
			createFile: true,
		},
		{
			name:       "Error reading non-existent file",
			content:    nil,
			want:       "",
			wantError:  true,
			createFile: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if tt.createFile {
				tmpDir := t.TempDir()
				tmpFile := filepath.Join(tmpDir, "test_file")
				err := os.WriteFile(tmpFile, tt.content, 0644)
				require.NoError(t, err)

				got, err := ReadFileToUTF8(tmpFile)
				if tt.wantError {
					require.Error(t, err)
				} else {
					require.NoError(t, err)
					require.Equal(t, tt.want, string(got))
				}
			} else {
				_, err := ReadFileToUTF8("/nonexistent/path/to/file.json")
				require.Error(t, err)
			}
		})
	}
}

func TestReadFileContentToUTF8(t *testing.T) {
	tests := []struct {
		name      string
		content   []byte
		filename  string
		want      string
		wantError bool
	}{
		{
			name:      "UTF-8 Terraform plan JSON",
			content:   []byte(`{"terraform_version":"1.0.0","planned_values":{}}`),
			filename:  "tfplan.json",
			want:      `{"terraform_version":"1.0.0","planned_values":{}}`,
			wantError: false,
		},
		{
			name: "UTF-16 LE with BOM - terraform plan",
			content: []byte{
				0xFF, 0xFE, // BOM
				'{', 0x00, '"', 0x00, 't', 0x00, 'e', 0x00, 'r', 0x00, 'r', 0x00, 'a', 0x00,
				'f', 0x00, 'o', 0x00, 'r', 0x00, 'm', 0x00, '_', 0x00, 'v', 0x00, 'e', 0x00,
				'r', 0x00, 's', 0x00, 'i', 0x00, 'o', 0x00, 'n', 0x00, '"', 0x00, '}', 0x00,
			},
			filename:  "tfplan.json",
			want:      `{"terraform_version"}`,
			wantError: false,
		},
		{
			name: "UTF-16 BE with BOM",
			content: []byte{
				0xFE, 0xFF, // BOM
				0x00, '{', 0x00, '"', 0x00, 'k', 0x00, 'e', 0x00, 'y', 0x00, '"', 0x00, '}',
			},
			filename:  "config.json",
			want:      `{"key"}`,
			wantError: false,
		},
		{
			name:      "UTF-8 with special characters",
			content:   []byte(`{"name":"José","city":"São Paulo"}`),
			filename:  "config.json",
			want:      `{"name":"José","city":"São Paulo"}`,
			wantError: false,
		},
		{
			name: "UTF-8 multiline Terraform plan",
			content: []byte(`{
  "format_version": "1.2",
  "terraform_version": "1.12.2",
  "planned_values": {
    "root_module": {
      "resources": []
    }
  }
}`),
			filename: "tfplan.json",
			want: `{
  "format_version": "1.2",
  "terraform_version": "1.12.2",
  "planned_values": {
    "root_module": {
      "resources": []
    }
  }
}`,
			wantError: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := ReadFileContentToUTF8(tt.content, tt.filename)
			if tt.wantError {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
				require.Equal(t, tt.want, string(got))
			}
		})
	}
}

// TestReadFileContentToUTF8_BugScenario tests the exact bug that was discovered:
// tfplan.json extracted from ZIP on Windows as UTF-16 LE with BOM
func TestReadFileContentToUTF8_BugScenario(t *testing.T) {
	t.Run("Terraform plan JSON from ZIP - UTF-16 LE with BOM", func(t *testing.T) {
		// Simulate the exact bug: tfplan.json extracted from ZIP as UTF-16 LE
		jsonContent := `{"format_version":"1.2","terraform_version":"1.12.2","planned_values":{"resources":[]}}`

		// Convert to UTF-16 LE with BOM (as Windows does)
		utf16Content := []byte{0xFF, 0xFE} // BOM
		for _, r := range jsonContent {
			utf16Content = append(utf16Content, byte(r), 0x00)
		}

		got, err := ReadFileContentToUTF8(utf16Content, "tfplan.json")
		require.NoError(t, err)
		require.Equal(t, jsonContent, string(got))

		// Verify regex matching works (analyzer use case)
		require.Contains(t, string(got), "terraform_version")
		require.Contains(t, string(got), "planned_values")
		require.Contains(t, string(got), "format_version")
	})

	t.Run("Large tfplan.json - UTF-16 LE with BOM (3239 lines scenario)", func(t *testing.T) {
		// Create large JSON content similar to real tfplan.json
		largeJSON := `{"terraform_version":"1.12.2","planned_values":{"resources":[`
		for i := 0; i < 100; i++ {
			if i > 0 {
				largeJSON += ","
			}
			largeJSON += `{"address":"aws_s3_bucket.bucket` + string(rune('a'+(i%26))) + `","type":"aws_s3_bucket"}`
		}
		largeJSON += `]}}`

		// Convert to UTF-16 LE with BOM
		utf16Content := []byte{0xFF, 0xFE}
		for _, r := range largeJSON {
			utf16Content = append(utf16Content, byte(r), 0x00)
		}

		// Test with both functions
		got1, err := ReadFileContentToUTF8(utf16Content, "large_tfplan.json")
		require.NoError(t, err)
		require.Equal(t, largeJSON, string(got1))
		require.Greater(t, len(got1), 1000, "Should handle large files")
		require.Contains(t, string(got1), "terraform_version")

		// Test file reading
		tmpDir := t.TempDir()
		tmpFile := filepath.Join(tmpDir, "large_tfplan.json")
		err = os.WriteFile(tmpFile, utf16Content, 0644)
		require.NoError(t, err)

		got2, err := ReadFileToUTF8(tmpFile)
		require.NoError(t, err)
		require.Equal(t, largeJSON, string(got2))
	})

	t.Run("Verify UTF-8 files pass through unchanged", func(t *testing.T) {
		tfContent := []byte(`resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"
}`)
		got, err := ReadFileContentToUTF8(tfContent, "main.tf")
		require.NoError(t, err)
		require.Equal(t, string(tfContent), string(got))
	})
}
