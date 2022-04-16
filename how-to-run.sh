 #!/bin/sh

# Check Dynamic  Inventory - Both Linux / Windows
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.local --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-inventory -i inventory/in-azure_rm.yml --list" 
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.local --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-inventory -i inventory/in-azure_rm.yml --graph" 

# Check Inventory - Both Linux / Windows
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.local --rm gustavmk/ansiblecontainer:latest "ansible-inventory -i inventory/00.inventory --list" 

# Windows - WIN_PING 
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.local --rm gustavmk/ansiblecontainer:latest "ansible-playbook -i inventory/00.inventory play-win-ping.yml"


docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.local --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-playbook -i inventory/in-azure_rm.yml play-win-ping.yml"

# Windows - SSH Role
docker run -v ${PWD}:/work:ro --env-file ${PWD}/env.local -v  ${PWD}/roles:/root/.ansible/roles:ro --rm gustavmk/ansiblecontainer:latest "ansible-playbook -i inventory/00.inventory play-win-ssh.yml"


# Create a new role - Both
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.local --rm gustavmk/ansiblecontainer:latest "ansible-galaxy init ${PWD}/tools"

# linux - Docker role
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.linux.local -v  ${PWD}/roles:/root/.ansible/roles:ro --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-playbook -i inventory/in-azure_rm.yml play-linux-role-docker.yml" 

# Linux - Swarm Traefik
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.linux.local -v  ${PWD}/roles:/root/.ansible/roles:ro --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-playbook -i inventory/in-azure_rm.yml play-linux-role-swarm-traefik.yml" 

# Windows - IIS Role
docker run -v ${PWD}:/work:ro --env-file ${PWD}/.env.local -v  ${PWD}/roles:/root/.ansible/roles:ro --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-playbook -i inventory/in-azure_rm.yml play-win-role-app1.yml"


# LINUX - Running with compose  

source .env.linux.local
docker-compose run --rm ansiblecontainer  "./auth_azcli.sh ; az vm list -o table"

docker-compose run --rm ansiblecontainer  "./auth_azcli.sh ; ansible-inventory -i inventory/ubuntu-azure_rm.yml --graph"

docker-compose run --rm ansiblecontainer "./auth_azcli.sh ; ansible-playbook -i inventory/ubuntu-azure_rm.yml play-linux-role-docker.yml"

docker-compose run --rm ansiblecontainer "ansible -i inventory/01.docker servers -m ping -vvv"