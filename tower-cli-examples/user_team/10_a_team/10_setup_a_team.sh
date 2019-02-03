#! /bin/bash
# 
#
set -ex

# Login and save credential info as needed.
timeout 5 tower-cli version 2>/dev/null >/dev/null || tower-cli login admin

# Organization
tower-cli organization create --name "Default"

# Teams
tower-cli team create --name "System_A_Team" --organization Default --description "Team develop and maintain System A"

# Project
tower-cli project create --name hello_project --organization Default --scm-type git --scm-url https://github.com/ansible/ansible-tower-samples --monitor
tower-cli project create --name system_A_project --organization Default --description "Playbooks and roles for System A" --scm-type git --scm-url https://github.com/ansible/ansible-tower-samples --monitor

# Inventories
tower-cli inventory create --name localhost --organization Default
tower-cli host create --name "127.0.0.1" --inventory localhost
tower-cli group create --name localhost --inventory localhost

tower-cli inventory create --name System_A_Inventory --organization Default
tower-cli host create --name "127.0.0.1" --inventory System_A_Inventory
tower-cli group create --name system_A --inventory System_A_Inventory

# Credentials
#useradd foo && echo pass | passwd --stdin foo
#tower-cli credential create --name foo --team System_A_Team --credential-type Machine --inputs '{"username":"foo","password":"pass"}'
tower-cli credential create --name System_A_Cred --team System_A_Team --organization Default --credential-type Machine --inputs '{}'

# Job templates
tower-cli job_template create --name hello_system_A --inventory System_A_Inventory --credential System_A_Cred --project hello_project --playbook hello_world.yml
tower-cli job_template create --name system_A_setup --inventory System_A_Inventory --credential System_A_Cred --project system_A_project --playbook hello_world.yml

# Users
tower-cli user create --username taadmin --password pass --email taadmin@example.com --first-name TeamA --last-name Admin
tower-cli user create --username john --password pass --email john@example.com --first-name John --last-name Doe
tower-cli user create --username jane --password pass --email jane@example.com --first-name Jane --last-name Doe
tower-cli user create --username taop --password pass --email taop@example.com --first-name TeamA --last-name Operator

# Users - Teams
tower-cli team associate --team System_A_Team --user taadmin
tower-cli team associate --team System_A_Team --user john
tower-cli team associate --team System_A_Team --user jane
tower-cli team associate --team System_A_Team --user taop

# Permissions for teams
tower-cli role grant --team System_A_Team --type use --project hello_project
tower-cli role grant --team System_A_Team --type use --project system_A_project
tower-cli role grant --team System_A_Team --type use --inventory localhost
tower-cli role grant --team System_A_Team --type use --inventory System_A_Inventory
tower-cli role grant --team System_A_Team --type use --credential System_A_Cred
tower-cli role grant --team System_A_Team --type execute --job-template hello_system_A
tower-cli role grant --team System_A_Team --type execute --job-template system_A_setup

# Permissions for users
tower-cli role grant --user taadmin --type admin --project system_A_project
tower-cli role grant --user taadmin --type admin --inventory System_A_Inventory
#tower-cli role grant --user taadmin --type admin --credential System_A_Cred
tower-cli role grant --user taadmin --type admin --job-template system_A_setup
tower-cli role grant --user jane --type admin --inventory System_A_Inventory
tower-cli role grant --user john --type admin --project system_A_project
#tower-cli role grant --user john --type admin --credential System_A_Cred

# vim:sw=2:ts=2:et:
