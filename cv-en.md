---
layout: cv
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

## Extracurricular

| 2018 |Host of the Remote Work coordinating group at mindmatters GmbH   |
| 2015 |coursera.org, Johns Hopkins Data Science Track|
| 2015 |Coached in Hamburg's second Students on Rails event|
| 2013 |Coached in Hamburg's first Students on Rails event aimed at introducing university students to Agile web development with Rails|
| 2012 |Co-founder Rubyshift Ruby user group in Munich|

## Languages

- English (native)
- German (fluent)

## Professional Interests

- Lisp
- Functional programming
- R
- Math
- Statistics and data mining
- Virtualization with linux containers and docker
- Privacy on the Internet

## Open Source

- Simple terminal based password manager https://github.com/flooose/password-utility
- A simple android client for runkeeper.com https://github.com/flooose/gpxkept
- _Copy Buddy_ Firefox and Chromium plugin for storing things that you want to copy and paste later

## Hobbies

- Surfing
- Sourdough
- Running
- Bicycles

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
