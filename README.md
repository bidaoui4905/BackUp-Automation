# Backup Automation with PowerShell Scripts

This project aims to automate backup jobs using PowerShell scripts. The provided scripts help you to locate backup files, display detailed file information, and automatically manage (retain or delete) backup files with an RPO parametre (recovery time objective).

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Overview

The Backup Automation project is designed for IT administrators who need to automate routine backup tasks. With these PowerShell scripts, you can:
- Search for backup files in specified directories (and subdirectories).
- Display file details such as full path, creation time, and last modification time.
- Permit alignement with your specific backup plan needs.
- Retain the latest backups while deleting older ones.
- Highly customizable through the RPO & PATHS parameters.
- Optionally copy backup files to a designated destination.
- Easily integrate these scripts into scheduled tasks or CI/CD pipelines.

## Features

- **Automated Backup File Detection:**  
  Recursively scans directories for backup files (e.g., files with extensions `.vbk`, `.vib`, `.vbm`).

- **Detailed File Reporting:**  
  Outputs file details including full path, creation date, and last modified date.

- **Selective Retention and Cleanup:**  
  Identifies the latest backup files and specify RPO to deletes older files to free up disk space.

- **Manual Copy Option:**  
  Prompts the user to copy files to a specified destination.

- **Customizable Parameters:**  
  Easily configure source/destination directories, file filters, RPO and retention criteria.

## Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/BackupAutomation.git
   cd BackupAutomation

2.**Requirements:**

- PowerShell 5.1 or later (compatible with Windows PowerShell or PowerShell Core).
- Administrative privileges may be required for certain tasks.
- (Optional) Veeam Backup & Replication if working with specific backup file formats.

## Usage

This repository includes several scripts to help automate backup tasks. For example:

- Backup File Listing & Cleanup
A script that finds all backup files within a specified directory, displays details about each file, and retains only the latest backups (e.g., before a specified date) while deleting older files.

- Manual Copy Option
After listing the backups, the script prompts you to decide whether to copy files to another directory.

- Running a Script
Open PowerShell, navigate to the repository directory, and run the desired script. For instance:

```powershell
.\backup_check.ps1
