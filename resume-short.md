---
layout: resume
---

{{ site.data.introduction.name }}
{{ site.data.introduction.location }}
{{ site.data.introduction.education }}
{{ site.data.introduction.github }}
{{ site.data.introduction.country }}
{{ site.data.introduction.contact }}

## About

{{ site.data.about.text }}

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
