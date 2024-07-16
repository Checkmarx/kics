## {{platform}} Queries List
This page contains all queries from {{platform}}.

{%- for sub_platform in data -%}
{%- if sub_platform != 'default' %}

### {{sub_platform | upper}}
Below are listed queries related to {{platform}} {{sub_platform | upper}}:

{% endif %}

|            Query             |Severity|Category|More info|
|------------------------------|--------|--------|-----------|
{%- for severity in data[sub_platform] -%}
  {%- for id in data[sub_platform][severity] %}
|{{data[sub_platform][severity][id]['queryName']}}<br/><sup><sub>{{id}}</sub></sup>|<span style="color:{{colors[severity]}}">{{severity}}</span>|{{data[sub_platform][severity][id]['category'] -}}
    |{{data[sub_platform][severity][id]['descriptionText'] -}}<br><a href="{{data[sub_platform][severity][id]['descriptionUrl']}}">Documentation</a><br/>|
  {%- endfor -%}
{%- endfor -%}
{%- endfor -%}