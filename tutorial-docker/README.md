# Getting started

This repository is a sample application for users following the getting started guide at https://docs.docker.com/get-started/.

The application is based on the application from the getting started tutorial at https://github.com/docker/getting-started

# My notes
> I've explicitly added support for debugging. You can do so using Visual Studio Code. Simply `docker compose up` and hit f5 to debug web app

Notes from [get-started tutorial](https://docs.docker.com/get-started/).
1. Containerize an application.
	1. Create a [[Dockerfile]].
	2. Create an [[Docker image]] `docker build -t tagName source`. `-t` is the tag. source is the dir where the command will look for a dockerfile. We'll use getting-started for this.
	3. Start a [[Docker container]] with the image. `docker run -dp 127.0.0.1:3000:3000 getting-started`.
		1. -d is detach so it can run in the background.
		2. -p is publish to create a port mapping between host and container. It takes a string HOST:CONTAINER. HOST is address and CONTAINER is port. 
		3. getting-started. The image tag.
	4. Container now runs, see running containers with `docker ps`.
2. Update an application.
	1. Simply build with same tag, and then docker ps, stop and run the new version.
3. Share the application.
	1. [[Docker image]] are shared via a [[Docker registry]]. [[Docker Hub]] is the default registry. Can we change the registry we target?
	2. Push with `docker push id/getting-started:tagname`. Which will fail cuz we only have `getting-started`, not `id/getting-started`.
		1. In case of failure.
		2. Sign into [[Docker Hub]] with `docker login -u NAME`.
		3. Retag an image with `docker tag getting-started id/getting-started`.
	4. Run step 2 again.
4. Persist the DB.
	1. Each container has it's own "scratch space" to create/update/remove files. 
	2. We can work around this with [[Docker volume]]. 
5. Multi container apps.
	1. We'll transition to MySQL, where should it run? In general, have one container do 1 thing for several reasons.
		1. Likely that front end and apis scales differently from databases.
		2. Separate containers allow version updates in isolation.
		3. For testing you run a local database, but in production you might want to use a managed service, so you don't want to ship a database with your app then.
		4. Running multiple processes require a process manager (container only starts one process). This adds complexity to container startup/shutdown.
	2. Since containers run in isolation, we communicate using [[Docker networking]]. There are 2 ways to put a container on a network.
		1. Assign the network when starting the container.
		2. Connect an already running container to a network.
	3. Create a network `docker network create todo-app`.
	4. Run a MySQL container `docker run -d --network todo-app --network-alias mysql -v todo-mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=todos mysql:8.0`
		1. --network-alias is used as a hostname, so we can find it in our network without using ip.
		2. -v is done but there might not be a volume yet. Docker will make one automatically for you.
		3. -e are environment variables.
	5. Now that MySQL is running on a network, how do you access?
	6. Use nicolaka/netshoot to troubleshoot and debug networking
		1. `docker run -it --network todo-app nicolaka/netshoot`
		2. Use dig mysql for some data
	7. Start the app with network now `docker run -dp 127.0.0.1:3000:3000 -w /app -v "$(pwd):/app" --network todo-app -e MYSQL_HOST=mysql -e MYSQL_USER=root -e MYSQL_PASSWORD=secret -e MYSQL_DB=todos node:18-alpine sh -c "yarn install && yarn run dev"`
	8. Verify if it has connected by reading the logs `docker logs -f container`.
		1. -f to follow
6. [[Docker compose]]
	1. A tool to aid in multi container apps. Defined using a YAML file.