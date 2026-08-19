# todos

This projects scales typical `todo-app` to `Cloud`, it's less about actual coding and more about automating and generalizing its deployment process.

## About

This project plans to show how an app can be taken from **Host Machine** to **Cloud** and be in a position to serve its users. It doesn't boast self-healing, auto-scaling systems, etc and just shows a general deployment process following standard practices to use terraform, ansible, github actions to push it to AWS while making deployment operations easier to reproduce & reason with and manage or debug.

## Tech Stack

- **frontend**: react, nginx
- **backend**: go, gorm, postgresql
- **cloud**: AWS(EC2, ALB, S3, ECR), terraform(IaC)
- **deployment**: github actions(CI/CD), ansible(deployment), docker, docker_compose

## Deployment Architecture
<img width="1620" height="802" alt="Image" src="https://github.com/user-attachments/assets/c0089ab6-49db-47c2-a1ad-d3f6bf3dcee4" />

## Deployment Workflow

- **First**, you provision your **Infrastucture** with a single click of run workflow button
    - thought it can be said its a manual process, it triggers provisioning script
    - terraform script provisions everything from EC2, ALB, S3, etc. along with each's respective configs
- **Second**, you push changes to your code which triggers CI to generate build artifacts and push it to ECR
    - there is separate CI for each module frontend/backend
    - and each has their own process for build and push
- **Third**, you deploy app with a click on run workflow button for deployment, which runs ansible-playbook
    - ansible is used for both installing required dependencies for project like docker, aws cli, etc
    - ansible manages deployment as an idempotent process

Though some process could be automated/incorporated in CI/CD, I chose not to for better debugging experience, for now.

## AWS Runtime architecture

- **DNS**: The application's domain/subdomain is configured with an A record that resolves to Application Load Balancer(ALB)
- **ALB**: ALB provides public entry point and performs layer-7 HTTP routing
  - Here it has two listeners:
    - `HTTP :80` - redirects traffic to HTTP *:443* using HTTP 301
    - `HTPS :443` - evaluates listener rules to determine where the request should be forwarded to

  - Listener rules and Target Groups
    - `/*` - frontend target group, ec2 servers on port :80
    - `/api/*` - backend target group, ec2 servers on port :3000


## Remarks
- This is an ongoing project so, its prone to change whether it be architectural or partial change.
- It aims to stick true to essence of generalizing deployment process.
