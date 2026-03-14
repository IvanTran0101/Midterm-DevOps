# Phase 2 – Traditional Deployment on Ubuntu Cloud Server

## Overview

Phase 2 demonstrates the deployment of the application on an Ubuntu cloud server using a traditional host-based deployment model.

The application is deployed directly on the operating system without containerization. A reverse proxy is configured using Nginx, HTTPS is enabled with Let's Encrypt, and the application is managed using a process manager to ensure service persistence after reboot.

---

# Objectives

The objectives of Phase 2 are:

- Provision an Ubuntu cloud server
- Prepare the runtime environment
- Deploy the application to the server
- Configure a reverse proxy using Nginx
- Enable HTTPS using Let's Encrypt
- Ensure the application remains active after server reboot
- Verify DNS configuration and public access to the system

---

# Directory Structure
phase2
├── config
│ ├── env
│ │ └── .env.template
│ └── nginx
│ ├── myapp-http.conf
│ └── myapp-https.conf
│
├── scripts
│ ├── setup-ec2.sh
│ ├── deploy.sh
│ └── nginx-apply.sh
│
├── evidence
│ ├── DNS_Configuration_Setup.jpg
│ ├── DNS_Setting.jpg
│ ├── HTTPS_CertBot.jpg
│ ├── PM2_Demonstration.jpg
│ └── PM2_Status_after_Reboot.jpg
│
└── README.md
---

# Configuration Files

## Environment Configuration


config/env/.env.template


This file contains the template for environment variables required by the application.

Sensitive values are not stored directly in the repository. Instead, the `.env.template` file provides a reference structure for configuring the production environment.

---

## Nginx Configuration


config/nginx/myapp-http.conf
config/nginx/myapp-https.conf


These files configure the reverse proxy used to route traffic from the public domain to the application server.

Responsibilities of the reverse proxy:

- Handle incoming HTTP/HTTPS requests
- Forward requests to the application server
- Manage TLS termination
- Support domain-based routing

---

# Deployment Scripts

All server setup and deployment steps are automated using scripts located in the `scripts` directory.

## setup-ec2.sh

This script prepares the EC2 Ubuntu server by installing required dependencies.

Typical actions include:

- updating system packages
- installing Node.js and npm
- installing Git
- installing PM2 process manager
- preparing application directories

---

## deploy.sh

Responsible for deploying the application to the server.

Typical tasks include:

- pulling the latest application code
- installing application dependencies
- starting the application using PM2

---

## nginx-apply.sh

Applies the Nginx configuration to the server.

This includes:

- copying configuration files to the Nginx sites directory
- enabling the site configuration
- restarting the Nginx service

---

# Service Management

The application is managed using **PM2**, a Node.js process manager.

PM2 ensures that:

- the application remains running in the background
- the application restarts automatically if it crashes
- the service starts automatically when the server reboots

---

# DNS and HTTPS Configuration

The public domain is configured to point to the server's public IP address.

HTTPS is enabled using **Let's Encrypt (Certbot)**.

The HTTPS setup includes:

- obtaining TLS certificates
- configuring Nginx to serve HTTPS
- redirecting HTTP traffic to HTTPS

---

# Evidence

The `evidence` directory contains screenshots verifying the successful deployment.

Included evidence:

DNS configuration  

DNS_Configuration_Setup.jpg
DNS_Setting.jpg


HTTPS certificate setup  

HTTPS_CertBot.jpg


Process manager verification  

PM2_Demonstration.jpg
PM2_Status_after_Reboot.jpg


These images demonstrate that:

- DNS correctly resolves to the server
- HTTPS certificates were successfully installed
- the application is managed by PM2
- the service persists after server reboot

---

# Verification

The deployment can be verified using the following checks:

- the application is accessible via the public domain
- HTTPS is active and secure
- the application process is running under PM2
- the application automatically restarts after server reboot

---

# Phase 2 Summary

Phase 2 successfully deploys the application on an Ubuntu cloud server using a traditional deployment model.

The deployment includes a configured reverse proxy, HTTPS security, automated deployme