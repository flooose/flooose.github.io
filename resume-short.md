---
layout: resume
---

|Name| Christopher Floess|
| Location | Melbourne, Florida |
| Education	|Bachelor of Arts German Studies, Minor: Computer Science|
| Github | https://github.com/flooose |
| Citizenship |German/U.S. Dual Citizenship|
| Contact|+1.321.266.0505 or chris.floess@mailbox.org |

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

## Non-Developer Employment

Available upon request
