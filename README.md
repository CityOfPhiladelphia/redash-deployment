## About:
* **What's in  here?**
    * Infrastructure configuration files for deploying redash.data.phila.gov
* **Why redash?:**
    * Municipal analysts lack a flexible tool for creating and organizing different [types of visualizations](https://redash.io/help/visualization/visualization.html#viz_types) (charts, graphs, plots, etc.).
![](http://i.imgur.com/q90MPmR.png)
* **Supported data source connections include:**
    * Oracle
    * PostgreSQL
    * Google Drive
    *  :information_source: [see docs for more info](https://redash.io/help-onpremise/setup/supported-data-sources-options-reqs.html)

## Infrastructure Components:

![Project Diagram](http://i.imgur.com/be9wwvc.png)

* VPC
* Dockerfile
* ELB
* ECS
* Hosted Redis Elasticache
* RDS Postgres
