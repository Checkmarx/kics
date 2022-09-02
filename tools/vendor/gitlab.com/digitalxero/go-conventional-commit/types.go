package conventional_commit

var (
	// PatchCategories is the list of categories used to determine if this commit is a patch bump or not
	PatchCategories = []string{
		"fix",
		"refactor",
		"perf",
		"docs",
		"style",
		"bug",
		"test",
	}

	// MinorCategories is the list of categories used to determine if this commit is a minor bump or not
	MinorCategories = []string{
		"feat",
		"feature",
		"story",
	}

	// MajorCategories is the list of categories used to determine if this commit is a major bump or not
	MajorCategories = []string{
		"breaking",
	}
)

// ConventionalCommit a parsed conventional commit message
type ConventionalCommit struct {
	Category    string   `yaml:"category"`
	Scope       string   `yaml:"scope"`
	Description string   `yaml:"description"`
	Body        string   `yaml:"body"`
	Footer      []string `yaml:"footer"`
	Major       bool     `yaml:"major"`
	Minor       bool     `yaml:"minor"`
	Patch       bool     `yaml:"patch"`
}

// Compare compares this version to another version. This
// returns -1, 0, or 1 if this version is smaller, equal,
// or larger than the other version, respectively.
//
// If you want boolean results, use the LessThan, Equal,
// GreaterThan, GreaterThanOrEqual or LessThanOrEqual methods.
func (v *ConventionalCommit) Compare(other *ConventionalCommit) int {
	switch {
	case !v.Major && other.Major:
		return 1
	case v.Major && other.Major:
		return 0
	case v.Major && !other.Major:
		return -1
	case !v.Minor && other.Minor:
		return 1
	case v.Minor && other.Minor:
		return 0
	case v.Minor && !other.Minor:
		return -1
	case !v.Patch && other.Patch:
		return 1
	case v.Patch && other.Patch:
		return 0
	case v.Patch && !other.Patch:
		return -1
	}

	return 1
}

// Equal tests if two versions are equal.
func (v *ConventionalCommit) Equal(o *ConventionalCommit) bool {
	return v.Compare(o) == 0
}

// GreaterThan tests if this version is greater than another version.
func (v *ConventionalCommit) GreaterThan(o *ConventionalCommit) bool {
	return v.Compare(o) > 0
}

// GreaterThanOrEqual tests if this version is greater than or equal to another version.
func (v *ConventionalCommit) GreaterThanOrEqual(o *ConventionalCommit) bool {
	return v.Compare(o) >= 0
}

// LessThan tests if this version is less than another version.
func (v *ConventionalCommit) LessThan(o *ConventionalCommit) bool {
	return v.Compare(o) < 0
}

// LessThanOrEqual tests if this version is less than or equal to another version.
func (v *ConventionalCommit) LessThanOrEqual(o *ConventionalCommit) bool {
	return v.Compare(o) <= 0
}

// ConventionalCommits a slice of parsed conventional commit messages
type ConventionalCommits []*ConventionalCommit

// Len return the number of messages in the slice
// required to implement sortable interface https://golang.org/pkg/sort/#Interface
func (v ConventionalCommits) Len() int {
	return len(v)
}

// Less reports whether the element with
// index i should sort before the element with index j.
// required to implement sortable interface https://golang.org/pkg/sort/#Interface
func (v ConventionalCommits) Less(i, j int) bool {
	return v[i].LessThan(v[j])
}

// Swap swaps the elements with indexes i and j.
// required to implement sortable interface https://golang.org/pkg/sort/#Interface
func (v ConventionalCommits) Swap(i, j int) {
	v[i], v[j] = v[j], v[i]
}
