# Changes in v1.3.0
---

## Breaking Changes

- KICS does not execute scan as default anymore
- Semantic exit code added based on scan results

---
## New Flags

| flag        | Description                                                                    |
| ----------- | ------------------------------------------------------------------------------ |
| `timeout`   | number of seconds the query has to execute before being canceled (default 60)  |
| `profiling` | enables performance profiler that prints resource consumption metrics in the logs during the execution (CPU, MEM) |
| `fail-on`   | which kind of results should return an exit code different from 0 accepts: critical, high, medium, low and info example: "high,low" (default [critical,high,medium,low,info]) |
| `ignore-on-exit` | defines which kind of non-zero exits code should be ignored accepts: all, results, errors, none example: if 'results' is set, only engine errors will make KICS exit code different|

## Updated Flags

| flag        | shorthand | Description                   | Change  |
| ----------- | --------- | ----------------------------- | ------- |
| `path`      | `-p`      | paths or directories to scan  | `path` flag now accepts multiple values       |


## KICS Engine
---
#### Timeout Queries

Query execution timeout is now parametrized, the flag `timeout` will override the default value (60 seconds)

#### Multiple paths

KICS can now scan multiple paths (WARNING: For multiple paths, kics.config will not be loaded automatically, configuration flag must be explicitly used to load any configuration file.)

#### Concurrent Scans

For performance improvements, KICS will now run scans concurrently by parser.

#### Analyzer

KICS will now do a pre-scan analysis to determine which type of queries and parsers to load. The analyzer will also exclude non Infrastructure as Code files. (WARNING: Using the `type` flag will disable the analyzer)
