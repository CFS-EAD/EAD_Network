# CFS-EAD Network Visualization

**Description**

This R script produces a network visualization of all current employees in the Canadian Forest Service - Economic Analysis Division as of December 11, 2023.

Vertices are placed on the plane using a force-directed Fruchterman-Reingold layout algorithm, resulting in adjacent/connected vertices (i.e. employees within the same team) positioned near each other and non-adjacent vertices positioned further apart. Employees are grouped and colour-coded by team. The size of vertices and the width of connecting edges are scaled based on betweenness centrality (i.e. number of "shortest path" connections).

**Input Data Sources**

Both the vector and edge list are author-created and refer to information provided by the [EAD Organizational Chart](https://041gc.sharepoint.com/:p:/r/sites/CFS-SCF/_layouts/15/Doc.aspx?sourcedoc=%7B63C0E5C1-9147-4E81-B00D-38447E11205B%7D&file=CFS%20-%20EAD%20-%20Org%20Chart.pptx&action=edit&mobileredirect=true). Vector attributes include employee name, team, and job title (not visualized). The edge list contains connections from directors to managers, and managers to employees.

**Results**

![](output/EAD_Network_Plot.jpg)
