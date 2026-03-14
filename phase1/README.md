# Phase 1 – Repository Setup and Git Workflow

## Overview

Phase 1 establishes the foundation for the project by organizing the repository, defining a collaborative Git workflow, and preparing Linux automation scripts for deployment environments.

This phase ensures that the project repository is structured clearly and that development follows safe collaboration practices using Git and GitHub.

---

## Objectives

The objectives of Phase 1 are:

- Organize the repository structure for the project
- Enforce a collaborative Git workflow using feature branches
- Use pull requests for all code integrations
- Enable branch protection for the main branch
- Prepare Linux automation scripts for deployment environments
- Provide supporting evidence of Git collaboration

---

## Directory Structure

The Phase 1 directory is organized as follows:
phase1/
├── evidence/
├── scripts/
├── src/
└── README.md


### src/

Contains the source code of the web application used for the project.

This application will later be deployed in:

- Phase 2 using traditional server deployment
- Phase 3 using Docker containerization

---

### scripts/

Contains Linux automation scripts used to prepare server environments.

Example:
scripts/setup.sh


The setup script installs required dependencies and prepares the operating system for application deployment.

Typical tasks include:

- updating system packages
- installing runtime dependencies
- installing Node.js and npm
- installing Git
- preparing directories for application deployment

These scripts will later be reused when preparing the cloud server in Phase 2.

---

### evidence/

Contains screenshots demonstrating the Git collaboration workflow.

Typical evidence includes:

- pull request history
- branch protection settings
- commit history
- contributor activity
- code review approvals

These screenshots verify that proper Git collaboration practices were followed during development.

---

## Git Workflow

The project follows a collaborative Git workflow.

### Branching Strategy

The repository uses the following branching structure:

- **main** – stable branch containing approved project state
- **feature branches** – used for implementing specific tasks

Example feature branches:
feature/setup-automation-script
feature/update-documentation


Developers create feature branches from `main`, implement changes, and submit a pull request for review.

---

### Pull Request Process

All changes must go through pull requests before merging into `main`.

The workflow is:

1. create a feature branch
2. implement changes
3. push the branch to GitHub
4. open a pull request
5. request review from a team member
6. merge after approval

This process ensures that all changes are reviewed before integration.

---

### Branch Protection

Branch protection rules are enabled for the `main` branch.

The protection rules include:

- preventing direct commits to `main`
- requiring pull requests before merging
- requiring at least one review approval

These rules help maintain repository stability and code quality.

---

## Automation Script

The automation script is located in:
scripts/setup.sh


The script prepares a Linux environment for application deployment.

Example execution:
chmod +x setup.sh
./setup.sh

This script installs the required dependencies and prepares the system for later deployment phases.

---

## Verification

Phase 1 can be verified through the following:

- repository contains a structured directory layout
- Git workflow uses feature branches and pull requests
- branch protection is enabled
- automation script runs successfully on Linux
- evidence of collaboration is stored in the evidence folder

---

## Phase 1 Summary

Phase 1 establishes the development foundation of the project by organizing the repository, implementing a structured Git workflow, and preparing automation scripts for deployment environments.

These practices ensure that the project is maintainable and ready for the deployment tasks performed in Phase 2 and Phase 3.
