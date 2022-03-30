 #!/bin/sh
 
docker run -v ${pwd}:/work:ro --env-file ${pwd}/.env.local --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-inventory -i inventory/in-azure_rm.yml --list"


docker run -v ${pwd}:/work:ro --env-file ${pwd}/.env.local -v   ${pwd}/roles:/root/.ansible/roles:ro --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-playbook -i inventory/in-azure_rm.yml myRole.yml"


# IIS Role
docker run -v ${pwd}:/work:ro --env-file ${pwd}/.env.local -v  ${pwd}/roles:/root/.ansible/roles:ro --rm gustavmk/ansiblecontainer:latest "./auth_azcli.sh ; ansible-playbook -i inventory/in-azure_rm.yml play-win-role-app1.yml"
