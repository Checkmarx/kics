## Creating a badge

To create a badge and update it the user should run KICS in their CI.

This can be done differently for each [integration we have](https://docs.kics.io/1.3.1/integrations/).

Let's assume a manual CLI process using docker:

```bash
#!/usr/bin/env bash
echo "running KICS in the current dir and writing results.json"
docker run -t -v $PWD:/path checkmarx/kics:latest scan -p /path -o "/path/"
```

This will generate a results.json file under `path`.
Parse the `results.json` and request a badge to img.shields.io.

For this example, let's assume HIGH and MEDIUM results are bad:

```bash
#!/usr/bin/env bash
CRITICAL=$(jq '.severity_counters.CRITICAL' results.json)
HIGH=$(jq '.severity_counters.HIGH' results.json)
MEDIUM=$(jq '.severity_counters.MEDIUM' results.json)
LOW=$(jq '.severity_counters.LOW' results.json)
INFO=$(jq '.severity_counters.INFO' results.json)

MESSAGE="passing"
COLOR="green"
if (( $HIGH > 0 )) || (( $MEDIUM > 0)); then
    MESSAGE="failing"
    COLOR="red"
fi

curl -sL "https://img.shields.io/badge/KICS-${MESSAGE}-${COLOR}.svg" > kics-status.svg
```

An example SVG produced:

![KICS](https://img.shields.io/badge/KICS-passing-green.svg)

If you have github pages configured under `gh-pages` branch configured you can commit and push the badge to it and reference on your README.md, e.g:

`![KICS](https://raw.githubusercontent.com/Checkmarx/kics/gh-pages/kics-status.svg)`
