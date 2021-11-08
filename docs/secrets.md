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


#### Flags

##### Passwords And Secrets Exclusion
It is important to mention that you can disable this query through flag `--disable-secrets`. Furthermore, you also can disable it through flag `--exclude-queries`, which should point to its query ID.

##### Passwords And Secrets Inclusion
When the flag `--include-queries` is not used, the Password and Secrets query is included for default. However, when this flag is used, the Password and Secrets query is not included for default. So, to include this query, you can use the flag `--include-queries`, which should point to the Password and Secrets query ID.

##### New Rules Addition
If you want to use your own rules, you can point the path through the flag `--secrets-regexes-path`. KICS is prepared for two cases:
- only the use of the user's rule (through the flag `--secrets-regexes-path`)
- the use of the user's rules plus all KICS rules (through the flag `--secrets-regexes-path` and `--include-queries`, which should point to the Passwords and Secrets query ID)
