---
layout: resume
title: Resume
---

{{ site.data.introduction.name }}
{{ site.data.introduction.location }}
{{ site.data.introduction.education }}
{{ site.data.introduction.github }}
{{ site.data.introduction.country }}
{{ site.data.introduction.contact }}

## About and Core Skills

<p class="mb-1_0">
{{ site.data.about.text }}
</p>

<ul class="no-border">
    {% for c in site.data.about.core_competencies %}
    <li>{{c}}</li>
    {% endfor %}
</ul>

## Projects

<table>
	{% for project in site.data.projects %}
    <tr>
		<td>{{project.when}}</td>
		<td>
			<em>{{project.who}}</em>
			<ul class="project-details">
				<li>Project description: {{project.description}}</li>
				<li>Role: {{project.role}}</li>
				<li>Technologies: {{project.technologies}}</li>
			</ul>
		</td>
	</tr>
	{% endfor %}
</table>

## Non-Developer Employment

{{ site.data.upon_request.text }}
