## Queries List
This page contains all queries.

|            Query            |Platform|Severity|Category|Description|Help|
|-----------------------------|---|---|---|---|---|
{%- for platform in data %}
  {%- for severity in data[platform] -%}
    {%- for id in data[platform][severity] %}
|{{data[platform][severity][id]['queryName']}}<br/><sup><sub>{{id}}</sub></sup>|{{platform -}}
    |<span style="color:{{colors[severity]}}">{{severity}}</span>|{{data[platform][severity][id]['category'] -}}
    |{{data[platform][severity][id]['descriptionText'] -}}
    |<a href="{{data[platform][severity][id]['descriptionUrl']}}">Documentation</a><br/>|
    {%- endfor -%}
  {%- endfor -%}
{%- endfor -%}