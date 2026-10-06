## Password and Secrets
Being the only query written in Golang, it involves several rules to cover the maximum possible cases. These rules are based on regexes. The default rules can be found [here](https://github.com/Checkmarx/kics/blob/master/assets/queries/common/passwords_and_secrets/regex_rules.json).
Each one is mainly composed of id, name and regex.

Since there are cases where it is necessary to filter the results of these rules (i.e. cases to exclude), you can use **allowRules**.
Basically, there are two types: **specific allowRules**, which is just applied to a specific rule and **generic allowRules**, which is applied to all rules.

**NOTE:** Terraform variables will not be resolved. Password and Secrets query will scan and point directly to tfvars file.

```json
{
  "rules": [
      {
        "id": "rule identifier",
        "name": "intuitive rule name",
        "regex": "golang flavor regex",
        "allowRules": [
          {
            "description": "brief description about the cases to exclude",
            "regex": "golang flavor regex"
          }
        ]
      }
  ],
    "allowRules": [
          {
            "description": "brief description about the cases to exclude",
            "regex": "golang flavor regex"
          }
    ]
}
```

#### Example

The present rule defines a pattern that finds generic tokens.
Since, in Terraform, we can come across cases like `token_key = data.terraform_remote_state.rancher.outputs.token_key`, we can use a **specific allowRules** (Avoiding TF resource access) to exclude these cases.

Moreover, to exclude scenarios like `automountServiceAccountToken: false`, we can use a **generic allowRules** (Avoiding Boolean's) to be applied not only in this rule but also in the remaining ones.

```json
{
  "rules": [
     {
          "id": "baee238e-1921-4801-9c3f-79ae1d7b2cbc",
          "name": "Generic Token",
          "regex": "(?i)['\"]?token(_)?(key)?['\"]?\\s*[:=]\\s*['\"]?([[A-Za-z0-9/~^_!@&%()=?*+-]+)['\"]?",
          "allowRules": [
            {
              "description": "Avoiding TF resource access",
              "regex": "(?i)['\"]?password['\"]?\\s*=\\s*([a-zA-z_]+(.))?[a-zA-z_]+(.)[a-zA-z_]+(.)[a-zA-z_]+"
            }
          ]
     }
  ],
  "allowRules": [
          {
            "description": "Avoiding Boolean's",
            "regex": "(?i)['\"]?[a-zA-Z_]+['\"]?\\s*[=:]\\s*['\"]?(true|false)['\"]?"
          }
   ]
}
```

#### Test Samples and Commenting Convention

All samples in `assets/queries/common/passwords_and_secrets/test/` (`positive*` / `negative*`) are self-documenting. Each file starts with a comment header, or a dummy `metadata` field(s) for JSON since comments are not allowed, stating exactly what the sample should flag, or why it should not flag.

| Sample type | Header format | How target lines are marked |
|---|---|---|
| Positive | `query_name - query_id positive-test` | `positiveX` inline (`X = 1, 2, 3...`), or `(line Z/Y...)` in header when inline comments are not possible |
| Positive, multiple queries | `query_name - query_id positive-test - #n` (one header line per query, `n = 1, 2, 3...`) | `#n` inline matching the header |
| Negative | `query_name - query_id negative-test (<why it does not flag>)` **or** `Generic Negative Test - <why it does not flag>` | Often no explicit marker; a comment may point at the relevant line(s) |
| Allow-rule (expected negative) | `query_name - query_id - <allow_rule_name> allow-rule-test` | `negativeX` if only one allow rule is relevant, otherwise `#n` matching the header |

Notes:
- Allow rules have no UUID of their own, hence the extra `<allow_rule_name>` field. Allow rules applied to all queries use `Global allow rule` as `query_name`.
- Really short positive tests may omit any line marker since the trigger line is obvious.
- When positives and allow-rules share a file, both header styles are combined (see example '_Positive + allow-rule mixed, grouped markers_').

##### Examples (click to expand)

<details><summary>Positive: single query, inline markers</summary>

```yaml
# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test (k8s)
stringData:
  password: "root"  # positive1
```

</details>
<details><summary>Positive: multiple queries, numbered markers</summary>

```yaml
# "Password in URL" - c4d3b58a-e6d4-450f-9340-04f1e702eaae  positive-test - #1
# "Slack Webhook"   - ccde326f-ebc7-4772-8ad5-de66e90a8cc3  positive-test - #2
servers:
  - url: http://bob:sekret@example.invalid/some/path  #1
  - url: https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX  #2
```

</details>
<details><summary>Positive: no inline comment possible, lines in header</summary>

```yaml
# "AWS Access Key" - 76c0bcde-903d-456e-ac13-e58c34987852  positive-test (line 18)
# "AWS Secret Key" - 83ab47ff-381d-48cd-bac5-fb32222f54af  positive-test (line 19)
export AWS_ACCESS_KEY_ID=AKIASXANV9XVIJ1YCIJ5
export AWS_SECRET_ACCESS_KEY=ZH6HDV/EolIbS2UTxbLplGpukOdaGmlq9MtAg1Xv
```

</details>
<details><summary>Positive: JSON fallback via metadata fields</summary>

```json
{
  "metadata1": "'Password in URL' - c4d3b58a-e6d4-450f-9340-04f1e702eaae  positive-test (line 10)",
  "metadata2": "'Slack Webhook'   - ccde326f-ebc7-4772-8ad5-de66e90a8cc3  positive-test (line 20)"
}
```

</details>
<details><summary>Positive + allow-rule mixed, grouped markers</summary>

```dockerfile
# "Square Access Token"   - 0b1b2482-51e7-49d1-893d-522afa4a6bd0  positive-test   - #1
# "Generic Token"         - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding Square Access Token"  allow-rule-test - #2
#1 & #2:
ARG token=sq0atp-812erere3wewew45678901
```

</details>
<details><summary>Negative: query-specific reason</summary>

```yaml
# "Twilio API Key" - e0f01838-b1c2-4669-b84b-981949ebe5ed  negative-test (is not a hardcoded key)
twilio_api_key: '{{ TWILIO_API_KEY }}'
```

</details>
<details><summary>Negative: generic, no single target rule</summary>

```yaml
# Generic Negative Test - no secrets (k8s)
```

</details>
<details><summary>Allow-rule: single rule, negativeX markers</summary>

```yaml
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding CloudFormation intrinsic functions"  allow-rule-test
MasterUserPassword: !Ref PasswordMaster  # negative1
```

</details>
<details><summary>Allow-rule: multiple rules, numbered markers</summary>

```yaml
# "Generic Token"   - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding TF resource access"  allow-rule-test - #1
# Global allow rule - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables"        allow-rule-test - #2
token = var.auth_token  #2
token = module.auth_service.token_output.value  #1
```

</details>

##### How to maintain them

- Keep the header in sync when adding, renaming, or changing a rule/allow rule: `query_name`, `query_id` (from `regex_rules.json`), and `allow_rule_name` (`description` field) must match exactly.
- Start `positiveX` / `negativeX` / `#n` counters at 1 per file and keep them sequential.
- If a sample cannot hold an inline comment (JSON, heredoc, one-liners), use `(line Z)` / `(line Z/Y...)` in the header, or a `metadata` key for JSON, and update the line numbers after any edit that shifts lines.
- Every rule and every allow rule must keep at least one dedicated sample; do not remove samples when fixing regexes  add or shorten them instead.
- Allow-rule samples must remain negative (no result expected).

#### Flags

##### Passwords And Secrets Exclusion
It is important to mention that you can disable this query through flag `--disable-secrets`. Furthermore, you also can disable it through flag `--exclude-queries`, which should point to its query ID.

##### Passwords And Secrets Inclusion
When the flag `--include-queries` is not used, the Password and Secrets query is included for default. However, when this flag is used, the Password and Secrets query is not included for default. So, to include this query, you can use the flag `--include-queries`, which should point to the Password and Secrets query ID.

##### New Rules Addition
If you want to use your own rules, you can point the path through the flag `--secrets-regexes-path`. KICS is prepared for two cases:
- only the use of the user's rule (through the flag `--secrets-regexes-path`)
- the use of the user's rules plus all KICS rules (through the flag `--secrets-regexes-path` and `--include-queries`, which should point to the Passwords and Secrets query ID)

#### Entropies

The password and secret regex queries utilize an object array called `entropies` to reduce the false positive rate. This
array contains information about the entropy of the strings that are being searched.

```json
{
    "id": "3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99",
    "name": "Generic Secret",
    "regex": "(?i)['\"]?secret[_]?(key)?['\"]?\\s*(:|=)\\s*['\"]?([A-Za-z0-9/~^_!@&%()=?*+-]{10,})['\"]?",
    "entropies": [
        {
            "group": 3,
            "min": 2.8,
            "max": 8
        }
    ]
}
```

The `entropies` array contains information about the minimum and maximum entropy values that are expected for a
particular group of characters in the regex pattern. Entropy is a measure of the randomness or unpredictability of a
string or set of strings, and is calculated using the Shannon formula. It takes into
account the frequency of occurrence of each character in the string, and the total length of the string. For every given
entropy, the result of the regex group should be between the maximum and minimum values specified in the `entropies`
array.
