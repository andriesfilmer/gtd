## Basic commands

List containers

    podman ps -a [--pod]          # Running containers and optional with podnames
    podman images                 # Available containers
    podman search docker.io/library/[container-name[:latest]
    podman pull docker.io/library/[container-name[:latest]
    podman inspect [container-id|container-name]

Download and run image (Official build of Nginx)

    podman run -it docker.io/library/nginx

Run ubuntu 22.04 interactive with a bash shell

    podman run -dt -p 8080:80/tcp localhost/ubuntu:22.04-v2
    podman exec -it [container-id] bash
    podman run -it [container-id]


Modify your container and save/commit your changes

    apt update && apt install nginx
    echo 'Hello from podman container.' > /var/www/html/index.html

From a other terminal while running this container

    podman commit [--include-volumes] [container-id] ubuntu:v1
    podman run -p 8080:80 ubuntu:22.04-v1

Stop and remove container

    podman stop [container-id]
    podman rm --force [container-id] # Remove container
    podman rmi [container-id] # Remove image

## Bundling with pods

First create a pod

    podman run --name appcontainer -dt -p 80:80/tcp docker.io/nginx

Execute a command in the container

    podman exec  appcontainer ps aux

Remove a pod

    podman pod rm -fa appcontainer

Save and re-run manifest

    podman generate kube -f pod.yml appcontainer
    podman play kube pod.yml

## Run at boot

Create a systemd file `/etc/systemd/system/appcontainer.service`

````
Systemd Service Text:
[Unit]
Description=App Container

[Service]
ExecStart=/usr/bin/podman run -d --name appcontainer nginx
Restart=always

[Install]
WantedBy=multi-user.target
````

Enable this server with `systemctl enable appcontainer`

## Nice to know

Everything is stored in `/var/lib/containers/storage/`

For example:

    cat /var/lib/containers/storage/overlay-images/images.json | jq .
    cat /var/lib/containers/storage/overlay-containers/containers.json | jq .


## Reset all

    podman system reset
