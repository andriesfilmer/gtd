To completely remove Immich and its components, follow these steps:

First, find and stop the Docker containers:

    docker ps -a | grep immich
    docker compose down

If docker-compose is running from a specific directory, navigate there first:

    cd ~/Downloads/immich-app
    docker compose down -v

The -v flag removes volumes as well.
Remove all Immich containers:

    docker ps -a | grep immich | awk '{print $1}' | xargs docker rm -f

Remove Immich images:

    docker images | grep immich | awk '{print $3}' | xargs docker rmi -f

Remove Immich volumes (this deletes your photos and database):

    docker volume ls | grep immich | awk '{print $2}' | xargs docker volume rm

Remove the Immich directory:

    sudo rm -rf ~/Downloads/immich-app

Remove any PostgreSQL containers and volumes if they're not used by anything else:

    docker ps -a | grep postgres | awk '{print $1}' | xargs docker rm -f
    docker volume ls | grep postgres | awk '{print $2}' | xargs docker volume rm

Check for any remaining processes:

    docker ps -a
    docker volume ls

If you want to remove Docker's network for Immich:

    docker network ls | grep immich
    docker network rm <network_name>
    docker network rm immich_default

