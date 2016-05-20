# About

Provisions a Golang "hello world" webapp node.

## Instructions

```bash
# instantiate the nodes and deploy the software
vagrant up
```

**To access the webserver:**
<http://localhost:8484/>




## Notes


**To check that the round-robin mechanism is working properly:**
```bash
for i in $(seq 1 100); do wget -q -O - localhost:8484; done | less
```
HAProxy is nicer


**To deploy new versions of the application:**

For automatic deployments on each new commit:
```bash
cd .git/hooks
ln -s ../../hook_post-commit.sh post-commit
```

For manual deployments:
```bash
ansible-playbook -i hosts.ini main.yml

# or run: vagrant provision
```


**Caveats:**
- Due to the scope of this demo and the nature of Vagrant machine recycling, SSH host key checking was disabled in `ansible.cfg`.
- Vagrant has issues when it comes with sharing gathered facts across nodes. And the only workaround to it is using redis. To avoid making it mandatory, the option was to use hardcoded IPs in the load balancing configuration. This could also be fixed by propagating a hosts file. But this is a demo after all!

