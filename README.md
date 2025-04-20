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