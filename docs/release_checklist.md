# Release Checklist

1. Check for any `update-queries-docs` pull requests open, review and merge if any
2. Bump UBI7 image version label in the [Dockerfile.ubi7](https://github.com/Checkmarx/kics/blob/master/Dockerfile.ubi7)
3. Prepare release (run prepare-release action)
4. Review and merge prepare-release pull-request
5. Create and push new version git tag
6. Wait for goreleaser action to complete
7. Test pre-release manually on each platform
8. Publish new version by updating changelog and removing pre-release flag
9. Check if `update-docs-release` workflow completed with success
10. Trigger `release-docker-image` workflow
11. Check if image is published in dockerhub / update hub documentation if changed.
12. Check for dependabots PR's in KICS' [github action](https://github.com/Checkmarx/kics-github-action), merge them and add a new tag.
