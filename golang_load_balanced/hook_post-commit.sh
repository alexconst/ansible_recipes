#!/usr/bin/env bash

env-ansible 2>/dev/null || true

ansible-playbook -i hosts.ini  main.yml

