package Cx

import data.generic.common as common_lib

# Detect use of 'secrets: inherit' when calling external reusable workflows.
#
# 'secrets: inherit' passes the ENTIRE set of repository secrets to the
# called workflow. Combined with an external (third-party) workflow, this
# creates a critical supply-chain risk: if the external repository is ever
# compromised, the attacker gains access to all your secrets.
#
# Safe pattern: pass only the exact secrets the reusable workflow needs:
#
#   jobs:
#     call:
#       uses: org/repo/.github/workflows/deploy.yml@abc123...
#       secrets:
#         DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}   # explicit, minimal
#
# Local workflow calls (uses: ./<path>) are lower risk because the code
# is in the same repository and is subject to the same review process.

CxPolicy[result] {
	job := input.document[i].jobs[j]
	uses := job.uses

	# Only flag external reusable workflows (not local ./path references)
	not startswith(uses, "./")

	# secrets: inherit passes ALL repository secrets to the external workflow
	job.secrets == "inherit"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("jobs.%s.secrets={{inherit}}", [j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("jobs.%s.secrets passes only the specific secrets required by the reusable workflow.", [j]),
		"keyActualValue": sprintf("jobs.%s.secrets is set to inherit, passing all repository secrets to the external reusable workflow '%s'.", [j, uses]),
		"searchLine": common_lib.build_search_line(["jobs", j, "secrets"], []),
	}
}
