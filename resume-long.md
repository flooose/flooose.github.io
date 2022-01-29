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

## Academic Background

| 2005 &ndash; 2010 |University of Arizona, Tucson, Arizona, USA – Major: German Studies, Minor: Computer Science|
| 2003 &ndash; 2005 |Pima Community College, Tucson, Arizona, USA – Welding Technology|
| 2002 &ndash; 2003 |University of Arizona, Tucson, Arizona, USA – Major, Mathematics|
| 1999 &ndash; 2002 |Santa Fe Community College, Gainesville, Florida, USA|
| 1997 &ndash; 1998 |Brevard Community College, Melbourne, Florida, USA|

## Academic Achievements and Participation

- Charles Polzer, S. J., Grant for constributions made to the translations of letters of the Swiss missionary Phillipp Segesser
- Participant in the STORK research project for secure package management – www.cs.arizona.edu/stork/packagemanagersecurity

## Languages

- English (native)
- German (fluent)

## Other Employment

<table>
	{% for job in site.data.jobs %}
	<tr>
		<td>{{job.when}}</td>
		<td>
			<em>{{job.who}}</em>
			<ul class="project-details">
				<li>Project description: {{job.description}}</li>
				<li>Role: {{job.role}}</li>
				<li>Technologies: {{job.technologies}}</li>
			</ul>
		</td>
	</tr>
	{% endfor %}
</table>
