# Release Checklist

1. Check for any `update-queries-docs` pull requests open, review and merge if any
2. Prepare release (run prepare-release action)
3. Use prepare release pull request (`docs: preparing for release`) to bump UBI8 image version label in the [Dockerfile.ubi8](https://github.com/Checkmarx/kics/blob/master/docker/Dockerfile.ubi8) and [index.md](https://github.com/Checkmarx/kics/blob/master/docs/index.md)
4. Review and merge prepare-release pull-request
5. Create and push a new version git tag
    - Be sure you configure [commit signature verification](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification)
    - In the master branch, run `git tag <tag_version>` and `git push -u origin <tag_version>`
6. Test pre-release manually on each platform
7. In [Tags](https://github.com/Checkmarx/kics/tags), create the release for the target version. Do not forget to select "Create a discussion for this release" and check if it was created.
8. Check if `update-docs-release`, `update-infra-version`, and `release-docker-image` workflow completed with success
9. Check if the image is published in [dockerhub](https://hub.docker.com/r/checkmarx/kics) / update hub documentation if changed
10. Push image to Red Hat
11. Update integrations tag:
    - git checkout integrations
    - git checkout -b ${new_branch}
    - git merge ${latest_tag} // update internal/constants/constants.go version to latest
    - git push -u origin HEAD // create PR and merge ${new_branch} with integrations branch !! Warning !! Make sure that branch is being merged with integrations and not master
    - git checkout integrations
    - git tag ${latest_tag}-integrations
    - git push origin ${latest_tag}-integrations
