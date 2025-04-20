## This is system include 3 components: Frontend, Backend & Database 
## Before we can start, we can try to run application with docker-compose:
- `docker-compose -f docker-compose.yaml up -d`
- After that access our application at `localhost:3000`. Try to add/list use and test connection with mongoDB

## Explain the architecture of the project
### Frontend
- Nodejs project has a task: list, add, delete users.
- Dockerfile build image base on Node20, expose port 3000.
- Docker image have variable environment: REACT_APP_API_URL is url of API Backend. Ex: localhost:8080
### Backend
- Java Spring boot has a task provide API list, add, delete users.
- Dockerfile file build image on Java OpenJDK, expose port 8080.
- Docker image have variable environment: MONGO_URL is url of MongoDB. EX: mongodb://database:27017/dev (*do Mongo local no set password, if use DocumentDB connection URL will be different.)
### Database
- Sử dụng image Mongo:5.0, port 27017.

### Task assignment: Deploy on AWS & configure CICD according to method 1 or method 2:


### Method 1:
- Frontend: Serverside Rendering trên ECS, ECR.
- Backend: ECS, ECR.
- Database: Document DB.
- Load Balance: ALB
- CICD: Jenkins, GithubAction or CodePipeline.
- Strategy deploy for backend: Rolling update or Blue-Green.
### Methos 2:
- Frontend: S3 + CloudFront.
- Backend: ECS, ECR.
- Database: Document DB.
- Load Balance: ALB
- CICD: Jenkins, GithubAction or CodePipeline.
- Strategy deploy for backend: Rolling update or Blue-Green.

### Architecture Design 

![alt text](AWS-Infra-01-DeployNodeApp.drawio.svg)

### Implement plan

#### Step 1: Will create terraform file : Network, Security group, Bastion, MongoDB, LoadBalaner, ECS Cluster

##### VPC module
- VPC name `aws-infra-01-vpc`
- Private Subnet: [ "10.0.10.0/24", "10.0.20.0/24" ]  `aws-infra-01-private-subnet-1` `aws-infra-01-private-subnet-2`
- Public Subnet: [ "10.0.1.0/24", "10.0.2.0/24" ]  `aws-infra-01-public-subnet-1` `aws-infra-01-public-subnet-2`
- cidr_block = "10.0.0.0/16"
- availability_zones = [ "ap-southeast-1a", "ap-southeast-1c" ]
- region = "ap-southeast-1"
- Enable VPC endpoint for S3 gateway

##### Create Security Group
- Public-sg (Allow internet port 80/443) `aws-infra-01-public-sg`
- Private-sg (Allow port 3000,8080 from public-sg) `aws-infra-01-private-sg`
- bastion-sg `aws-infra-01-bastion-sg`
- database-sg (Allow port 27017 from Private-sg, bastion-sg) `aws-infra-01-database-sg`

##### Create ECR/ECS of Front-end/Back-end
##### Create ECS Cluster
-Choose name `aws-infra-01-ecs-cluster`
- Choose AWS Fargate  
- Add tagname: Name - `aws-infra-01-ecs-cluster`

##### Create Bastion module and install mongosh
- Choose name `aws-infra-01-bastion-vm`
- Choose `t3.small`
- Install key-par key for SSH login
- Choose VPC: `aws-infra-01-vpc`
- Choose public subnet `aws-infra-01-public-subnet-1`
- Enable Auto Assign public IP 
- Choose security group `aws-infra-01-bastion-sg`
- Choose storage `10GiB`
- Create script mongosh
- SSH test and check `mongosh --version`

##### Create Document DB
- Create custom parameter group `aws-infra-01-param-grp`
- Choose Family docdb5.0 and edit `tls` param disabled
- Create subnet-group `aws-infra-01-subnet-grp`
- Choose VPC `aws-infra-01-vpc`
- Choose `Private Subnet` : [ "10.0.10.0/24", "10.0.20.0/24" ] with `availability_zones` : [ "ap-southeast-1a", "ap-southeast-1c" ]
- Create Cluster -> Choose Instance-based cluster `aws-infra-01-mongodb-cluster`
- Engine version 5.0.0
- Instance class: db.t3.medium
- Number instance: 1
- Cluster storage : Amazon DocoumentDB Standard
- Connectivity: Don't connect EC2 compute resource
- Authentication: `adminmongodb`
- Password: `awsinfra01strongpass`
- Network : Choose `aws-infra-01-vpc`
- Choose security group `aws-infra-01-database-sg`
- Select Cluster parameter group `aws-infra-01-param-grp` and choose subnet-group `aws-infra-01-subnet-grp`
- Disable Deletion protection

##### Go back to bastion machine and test connection with mongodb

##### Create ALB and Target group
- Create front-end target group -> Type IP address -> Chosoe name `aws-infra-01-frontend-tg` -> Port HTTP 3000
    - Choose VPC `aws-infra-01-vpc`
    - Protocol version HTTP1
    - Health check HTTP with path `/`

- Create back-end target group -> Type IP address -> Chosoe name `aws-infra-01-backend-tg` -> Port HTTP 8080
    - Choose VPC `aws-infra-01-vpc`
    - Protocol version HTTP1
    - Health check HTTP with path `/api/students`
    - Healthy threshold: `5`
    - Unhealthy threshold: `2`
    - Timeout: `5`
    - Interval: `10`



- Create Application Loadbalancer `aws-infra-01-alb`
- Choose internet facing mode
- Choose VPC `aws-infra-01-vpc`
- choose AZ [ "ap-southeast-1a", "ap-southeast-1c" ] and choose choose 2 public subnet group
- Choose security group `aws-infra-01-public-sg`
- In listeners and routing
    - HTTP : 80 -> Forward to `aws-infra-01-frontend-tg`
    - HTTP : 80 -> Add condition path `/api/*` -> Forward to `aws-infra-01-backend-tg` (Priority 10)

##### Create CodePipeline to Build docker image and push to ECR
- Go to ECS service and create task difinitions `aws-infra-01-task-define`
- Choose AWS Fargate launch type, (1vCPU and 2 GB ram)
- Maybe need to create TaskExecution Role
- Container name images URI






