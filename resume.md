---
layout: resume
---

|Name| Christopher Floess|
| Location | Melbourne, Florida |
| Education	|Bachelor of Arts German Studies, Minor: Computer Science|
| Github | https://github.com/flooose |
| Citizenship |German/U.S. Dual Citizenship|
| Contact|+1.321.266.0505 or chris.floess@jjff.de |

## About

I'm a full-stack web developer with experience in modern front-end and back-end
technologies. I focus on agile, iterative development practices like Scrum and
Kanban and have experience developing software "in house", as well as remote.

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
