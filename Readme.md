Introduction
implementation of the exam requirements for skyworkz azure DevOps position

Description
The goal was to create a basic get/set api that can pull/push data into a DB with the next reqs:
    - Billing mode for api based in num of requests
    - Backend SQL must be elastic and scale up/down based in performance
    - Automate IaaC with ARM
    - Include yaml CICD pipelines for the solution

The implementation is PoC so it's using the minimal setup without taking into account advanced security requirements

Arquitecture

The solution is based in Azure Functions with PS Core runtime. The function includes two methods (getinfo and setinfo) to insert and retrieve data from Azure SQL. The function uses PS Core as framework but could be done easily in Python as well
The function is configured in consumption mode SKU so the billing will be based in the number of http requests
The backend is an Azure SQL Server with an elastic pool with 100DTUs, the DB will increase/decrease the DTUs from the pool based in its real time requirements. It's not a really good setup for a single database, because the idea of pools is to balance resources across different DBs and in this case it's  single one. There could be other implementation approachs based on the customer reqs or the expected growth for a real service. For instance:
	- Create an AKS stateful set (mysql) with 2 services for read ops in master and superreadOnly mode in slaves pool. That way we would increase the tier based in the read/write requirements
	- Another option would be a single DB without elastic pool and creating a LogAnalytics rule to capture performance metrics and send a webhook call to an automation account to scale it up/down. This would be the cheaper option but not for a prd environment imo.
Inside the ARM folder there are two files, the json includes the ARM file with the platform description, the PS1 is just to trigger the pipeline and create the RG in case it does not exist
The yaml file in the root is the Azure DevOps deployment pipeline configured to start the CI process when a change is commited in the repo master branch

Service

The DB is a basic table with only 2 fields, name and lastname
GetInfo -> https://sw-exam-api.azurewebsites.net/api/getinfo Returns a json response with all elements in the DB
SetInfo -> https://sw-exam-api.azurewebsites.net/api/setinfo Including a json content in the body, it will be deserialized and inserted into DB
The setinfo method json schema would be something like [{"name": "julio", "lastname": "rosua"}]


No error control is added, just the basic I/O so sending another schema will probably return 500