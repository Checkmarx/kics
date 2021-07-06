# Release Checklist

1. Check for any `update-queries-docs` pull requests open, review and merge if any
2. Prepare release (run prepare-release action)
3. Review and merge prepare-release pull-request
4. Create and push new version git tag
5. Wait for goreleaser action to complete
6. Test pre-release manually on each platform
7. Publish new version by updating changelog and removing pre-release flag
8. Check if `update-docs-release` workflow completed with success
9. Trigger `release-docker-image` workflow
10. Check if image is published in dockerhub / update hub documentation if changed.
