package chglog

import (
	"errors"
	"fmt"
	"os"
	"sort"

	"github.com/Masterminds/semver/v3"
	"github.com/go-git/go-git/v5"
	"github.com/go-git/go-git/v5/plumbing"
	"github.com/go-git/go-git/v5/plumbing/object"
	"github.com/go-git/go-git/v5/plumbing/storer"
)

// InitChangelog create a new ChangeLogEntries from a git repo.
func InitChangelog(gitRepo *git.Repository, owner string, notes *ChangeLogNotes, deb *ChangelogDeb, useConventionalCommits bool) (cle ChangeLogEntries, err error) {
	var (
		tagRefs    storer.ReferenceIter
		tags       []*semver.Version
		start, end plumbing.Hash
	)

	cle = make(ChangeLogEntries, 0)
	end = plumbing.ZeroHash

	if tagRefs, err = gitRepo.Tags(); err != nil {
		return nil, fmt.Errorf("unable to fetch tags: %w", err)
	}
	defer tagRefs.Close()

	if err = tagRefs.ForEach(func(t *plumbing.Reference) error {
		var version *semver.Version

		tagName := t.Name().Short()

		if version, err = semver.NewVersion(tagName); err != nil || version == nil {
			fmt.Fprintf(os.Stderr, "Warning: unable to parse version from tag: %s : %v\n", tagName, err)
			return nil
		}

		tags = append(tags, version)
		return nil
	}); err != nil {
		return nil, err
	}

	sort.Slice(tags, func(i, j int) bool { return tags[i].LessThan(tags[j]) })

	for _, version := range tags {
		tagName := version.Original()

		t, err := gitRepo.Tag(tagName)
		if err != nil {
			return nil, err
		}

		var (
			commits      []*object.Commit
			commitObject *object.Commit
			tag          *object.Tag
		)

		if version.Prerelease() != "" {
			// Do not need change logs for pre-release entries
			continue
		}

		if start, err = GitHashFotTag(gitRepo, tagName); err != nil {
			return nil, fmt.Errorf("unable to find hash for tag: %s : %w", tagName, err)
		}

		// If this is an annotated tag look up the hash of the commit and use that.
		if tag, err = gitRepo.TagObject(t.Hash()); err == nil {
			var c *object.Commit

			if c, err = tag.Commit(); err != nil {
				return nil, fmt.Errorf("cannot dereference annotated tag: %s : %w", tagName, err)
			}
			start = c.Hash
		}

		if commitObject, err = gitRepo.CommitObject(start); err != nil {
			// This ignores objects that are off branch which happens when tagging on multiple branches happens.
			if errors.Is(err, plumbing.ErrObjectNotFound) {
				continue
			}
			return nil, fmt.Errorf("unable to fetch commit from tag %v: %w", tagName, err)
		}
		if owner == "" {
			owner = fmt.Sprintf("%s <%s>", commitObject.Committer.Name, commitObject.Committer.Email)
		}
		if commits, err = CommitsBetween(gitRepo, start, end); err != nil {
			return nil, fmt.Errorf("unable to find commits between %s & %s: %w", end, start, err)
		}

		changelog := CreateEntry(commitObject.Committer.When, version, owner, notes, deb, commits, useConventionalCommits)
		cle = append(cle, changelog)
		end = start
	}

	sort.Sort(sort.Reverse(cle))

	return cle, nil
}
