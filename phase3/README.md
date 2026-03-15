# Phase 3 – Containerized Deployment with Docker Compose

## Overview

Phase 3 migrates the application from the traditional host-based deployment
model used in Phase 2 to a containerized architecture using Docker.

The application and its supporting services are packaged as Docker images
and deployed using Docker Compose. This approach improves reproducibility,
portability, and operational consistency.

The system is deployed using container images stored in Docker Hub and
pulled to the production server during deployment.

---

# Objectives

The objectives of Phase 3 are:

- Containerize the application using Docker
- Define a multi-service architecture using Docker Compose
- Store container images in Docker Hub
- Deploy the application using container orchestration
- Maintain reverse proxy routing through Nginx
- Ensure service persistence after container restart and server reboot

---

# Directory Structure


phase3
├── docker
│ ├── nginx
│ │ └── myapp.conf
│ ├── Dockerfile
│ ├── docker-compose.yml
│ ├── .env.template
│ └── .dockerignore
│
├── scripts
│ ├── build.sh
│ ├── push.sh
│ ├── pull-run.sh
│ ├── logs.sh
│ └── restart-proof.sh
│
├── evidence
│ ├── Docker_Hub.jpg
│ ├── Docker_PS_Output.jpg
│ ├── Docker_PS_Output_2.jpg
│ ├── Docker_Pull.jpg
│ ├── Docker_Restart.jpg
│ ├── Reverse_Proxy_in_Docker.jpg
│ └── Server_Reboot_in_Docker.jpg
│
└── README.md


---

# Docker Configuration

## Dockerfile

The Dockerfile defines how the application container image is built.

Responsibilities include:

- installing runtime dependencies
- copying application source code
- installing application dependencies
- defining the container startup command

This ensures the application can run consistently across environments.

---

## Docker Compose

The container orchestration is defined in:


docker/docker-compose.yml


Docker Compose defines the services required for the application.

Typical responsibilities include:

- defining service containers
- configuring environment variables
- defining container networks
- managing service dependencies
- mapping ports between host and containers

This file enables the entire application stack to be started with a
single command.

---

## Environment Configuration


docker/.env.template


The environment template provides the structure for required environment
variables without exposing sensitive credentials.

Before deployment, the template is copied and filled with actual values.

---

## Nginx Reverse Proxy


docker/nginx/myapp.conf


Nginx is used as a reverse proxy to route incoming traffic to the
application container.

Responsibilities include:

- forwarding requests to the web container
- handling HTTP and HTTPS traffic
- supporting domain-based routing

---

# Deployment Workflow

Deployment follows a container image workflow.

## Build Image


scripts/build.sh


Builds the application container image.

---

## Push Image to Docker Hub


scripts/push.sh


Uploads the container image to Docker Hub for distribution.

---

## Pull and Run Containers


scripts/pull-run.sh


The production server pulls the container image from Docker Hub and
starts the application using Docker Compose.

---

## View Logs


scripts/logs.sh


Displays logs from running containers.

---

## Restart Verification


scripts/restart-proof.sh


Verifies that containers restart correctly after failures or restarts.

---

# Container Reliability

Docker restart policies are used to ensure service availability.

This guarantees that containers:

- restart automatically if they crash
- restart when Docker daemon restarts
- restart after full server reboot

---

# Evidence

The `evidence` directory contains screenshots demonstrating the
successful operation of the containerized system.

Examples include:

Docker Hub image repository  

Docker_Hub.jpg


Docker container status  

Docker_PS_Output.jpg
Docker_PS_Output_2.jpg


Docker image pull process  

Docker_Pull.jpg


Container restart verification  

Docker_Restart.jpg


Reverse proxy routing through Docker  

Reverse_Proxy_in_Docker.jpg


Server reboot verification  

Server_Reboot_in_Docker.jpg


These images verify that the containerized system runs correctly and
remains operational under restart conditions.

---

# Verification

The containerized deployment can be verified through the following checks:

- Docker containers are running successfully
- The application is accessible through the domain
- Reverse proxy routing functions correctly
- Containers restart automatically
- The system remains operational after full server reboot

---

# Phase 3 Summary

Phase 3 successfully migrates the application into a containerized
architecture using Docker and Docker Compose.

The deployment pipeline includes image building, image distribution
through Docker Hub, and automated container orchestration.

This containerized architecture improves reproducibility, portability,
and operational reliability compared to the traditional deployment model