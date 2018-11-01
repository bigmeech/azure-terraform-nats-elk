## Generic Notification Architecture On the Azure Platform

This respository contains application and infrastructore code for running, deploying and managing a fault-tolerant, highly scalable notification management system on the Azure Cloud Platform

### Architecture Components
- Azure Resource Group
- Azure Kubernetes Service
- Azure VM (ELK and Docker Engine)
- Azure VM Cluster (3 Nats Cluster)

### Architecture diagram

![Notification Architecture](https://ibb.co/hYbPkf)

### Nats Messaging Server, Topic, Publishers and Subscribers
This achitecture comprises of a producer endpoint

### Configuration

`SUBSCRIPTION_ID`, `CLIENT_ID`, `CLIENT_SECRET` and `TENANT_ID` are required to deploy the architecture to azure. These values are to be stored in a dotenv file in the root of the project.
**DO NOT IN ANYWAY ATTEMPT TO COMMIT THESE TO A SOURCE CODE REPOSITORY!!!**


### PubSub Client Application
Environmental variables

| Variable Name | Type | Default | Description |
|---------------|------|---------|-------------|
| NATS_SERVER   |String, List of Strings| null    | Hostname or IP address to nats server(s). Can be comma delimited for a clustered setup|
|NODE_ENV| string|development| Standard NODE_ENV variable config|
|LOG_LEVEL| string
