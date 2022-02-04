## Buildah Queries List
This page contains all queries from Buildah.

|            Query             |Severity|Category|Description|Help|
|------------------------------|--------|--------|-----------|----|
|Run Using Dnf Update<br/><sup><sub>bb362c19-e1b2-4006-bf6c-235c2482e774</sub></sup>|<span style="color:#C00">High</span>|Supply-Chain|Command 'dnf update' should not be used, as it can cause inconsistencies between builds and fails in updated packages|<a href="https://github.com/containers/buildah/blob/main/docs/buildah-run.1.md">Documentation</a><br/>|
|Run Using apt<br/><sup><sub>a1bc27c6-7115-48d8-bf9d-5a7e836845ba</sub></sup>|<span style="color:#C60">Medium</span>|Supply-Chain|apt is discouraged by the linux distributions as an unattended tool as its interface may suffer changes between versions. Better use the more stable apt-get and apt-cache|<a href="https://github.com/containers/buildah/blob/main/docs/buildah-run.1.md">Documentation</a><br/>|
