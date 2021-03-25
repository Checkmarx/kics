## {{platform}} Queries List
This page contains all queries from {{platform}}, classified by severity level.

|            Query            |Severity|Category|Description|Help|
|-----------------------------|--------|--------|-----------|----|
{%- for severity in data -%}
  {%- for id in data[severity] %}
|{{data[severity][id]['queryName']}}<br/><sup><sub>{{id}}</sub></sup>|{{severity -}}
    |{{data[severity][id]['category'] -}}
    |{{data[severity][id]['descriptionText'] -}}
    |<a href="{{data[severity][id]['descriptionUrl']}}">Documentation</a><br/>|
  {%- endfor -%}
{%- endfor -%}