 #!/bin/sh


# Check inventory - Both Linux / Windows
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.local --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-inventory -i inventory/in-azure_rm.yml --list" 
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.local --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-inventory -i inventory/in-azure_rm.yml --graph" 

# Create a new role - Both
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.local --rm gustavmk/ansiblecontainer:latest "ansible-galaxy init ${PWD}/tools"


# linux - Docker role
 docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.linux.local -v  ${PWD}/roles:/root/.ansible/roles:ro --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-playbook -i inventory/in-azure_rm.yml play-linux-role-docker.yml" 

# Windows - IIS Role
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.local -v  ${PWD}/roles:/root/.ansible/roles:ro --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-playbook -i inventory/in-azure_rm.yml play-win-role-app1.yml"


# Windows - SSH Role
docker run -v ${PWD}:/work:ro --env-file ${PWD}/linx.env.local -v  ${PWD}/roles:/root/.ansible/roles:ro --rm gustavmk/ansiblecontainer:latest "ansible-playbook -i inventory/00.inventory play-win-ssh.yml"
