## CICD Queries List
This page contains all queries from CICD.

### GITHUB
Bellow are listed queries related with CICD GITHUB:



|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|Unpinned Actions Full Length Commit SHA<br/><sup><sub>555ab8f9-2001-455e-a077-f2d0f41e2fb9</sub></sup>|<span style="color:#C60">Medium</span>|Supply-Chain|Pinning an action to a full length commit SHA is currently the only way to use an action as an immutable release. Pinning to a particular SHA helps mitigate the risk of a bad actor adding a backdoor to the action's repository, as they would need to generate a SHA-1 collision for a valid Git object payload. When selecting a SHA, you should verify it is from the action's repository and not a repository fork. (<a href="../cicd-queries/common/555ab8f9-2001-455e-a077-f2d0f41e2fb9" target="_blank">read more</a>)|<a href="https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#using-third-party-actions">Documentation</a><br/>|
