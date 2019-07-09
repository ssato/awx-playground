#! /bin/bash
# 
#
set -ex

# Login and save credential info as needed.
timeout 5 tower-cli version 2>/dev/null >/dev/null || tower-cli login admin

# Organization
tower-cli organization create --name "Default"

# Project
tower-cli project create --name test_vars_project --organization Default \
  --monitor --scm-type git --scm-url https://github.com/ssato/awx-playground

# Inventories
tower-cli inventory_source create --name local_inv_src --organization Default \
  --source scm --source-path hosts --source-project test_vars_project \
  --overwrite true --update-on-launch true --inventory local_inv_src

# Job templates
tower-cli job_template create --name test_vars --inventory local_inv_src \
  --project test_vars_project --playbook test_vars.yml

# vim:sw=2:ts=2:et: