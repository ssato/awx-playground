#! /bin/bash
# 
#
set -ex

CURDIR=${0%/*}

# Setup users, teams and so on for System A
#source ${CURDIR}/10_setup_a_team.sh

# Teams
tower-cli team create --name "System_B_Team" --organization Default --description "Team develop and maintain System B"
tower-cli team create --name "X_System_Team" --organization Default --description "Virtual Team crosssing System A and B"

# Project
tower-cli project create --name system_B_project --organization Default --description "Playbooks and roles for System B" --scm-type git --scm-url https://github.com/ansible/ansible-tower-samples --monitor

# Inventories
tower-cli inventory create --name System_B_Inventory --organization Default
tower-cli host create --name "127.0.0.1" --inventory System_B_Inventory
tower-cli group create --name system_B --inventory System_B_Inventory

# Credentials
tower-cli credential create --name System_B_Cred --team System_B_Team --organization Default --credential-type Machine --inputs '{}'

# Job templates
tower-cli job_template create --name system_B_setup --inventory System_B_Inventory --credential System_B_Cred --project system_B_project --playbook hello_world.yml

# Users
tower-cli user create --username tbadmin --password pass --email tbadmin@example.com --first-name TeamB --last-name Admin
tower-cli user create --username bob --password pass --email bob@example.com --first-name Mr --last-name Bob

# Users - Teams
tower-cli team associate --team System_B_Team --user tbadmin
tower-cli team associate --team System_B_Team --user bob
tower-cli team associate --team System_B_Team --user jane  # jane also takes care of System B
tower-cli team associate --team X_System_Team --user jane  # likewise
tower-cli team associate --team X_System_Team --user john

# Permissions for teams
tower-cli role grant --team System_B_Team --type use --project hello_project
tower-cli role grant --team System_B_Team --type use --project system_B_project
tower-cli role grant --team System_B_Team --type use --inventory System_B_Inventory
tower-cli role grant --team System_B_Team --type use --credential System_B_Cred
tower-cli role grant --team System_B_Team --type execute --job-template system_B_setup
tower-cli role grant --team X_System_Team --type read --job-template system_B_setup

# Permissions for users
tower-cli role grant --user tbadmin --type admin --project system_B_project
tower-cli role grant --user tbadmin --type admin --inventory System_B_Inventory
tower-cli role grant --user tbadmin --type admin --job-template system_B_setup
tower-cli role grant --user jane --type admin --inventory System_B_Inventory
tower-cli role grant --user john --type admin --project system_B_project

# vim:sw=2:ts=2:et:
