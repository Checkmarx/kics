# Changes in v1.6.0

---

## Breaking Changes

### Processing .gitignore – paths assumed for KICS scan exclusion

From v1.6, KICS will read .gitignore file in the root of the project to exclude from the scan the paths therein.

How does this impact your scans?

-   You will only be affected by this change in case you use KICS locally on your develop environment.
    -   Notice that if you are using KICS on top of a repository (e.g., as part of a CI/CD pipeline) those paths already do not exist, so there will be no effect for those scenarios.
-   You’ll notice an apparent loss of results: results identified in files under the .gitignore paths will no more be identified.

<br/>

### Consistency between scan with and without the -t flag
-t or --type flag is used to instruct KICS to scan only files of specific technologies. 

Before v1.6, KICS with -t flag would scan the project and, in case there are no files of the specified technologies, it will terminate with a message “No files were scanned” and no other output. 

From v1.6, KICS will keep its behavior consistent whether -t flag is used or not. Meaning: it will always output results file, even if it is an “empty” results report is created due to no files being scanned, as shown in the image below. 

How does this impact your scans? 

- You will only be affected by this change in case you use KICS with flag -t/--type AND there are no files of the specified “type” in the scanned project.
- If you rely on the message “No files were scanned” for some post-scan action, this change will also affect you, because that message disappears now.

<div style="min-width:150;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
    <img alt="-t flag behavior" src="../img/1-6-t-flag.png"  width="300" style="min-width:300px">
</div>

<br/>

### Masking Secrets – Hide secrets from results when KICS finds them

From v1.6, KICS will mask/hide identified secrets out of results reports, in order to avoid exposing them to undesirable report readers. 

How does this impact your scans?

- This is not likely to impact you in any way.
- Notice that results of secrets and passwords will appear in a slightly different, but more secure, fashion (see below an example of an HTML report)


<div style="min-width:150;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
    <img alt="Masked Secrets" src="../img/masked-secrets.png"  width="450" style="min-width:450px">
</div>



---

## Deprecations during 1.6.x (so far)

During KICS 1.6.x versions we intend to deprecate some of our flags and keep using their default values. 
They are the following: 

- --minimal-ui
- --no-progress
- --preview-lines
- --no-color

