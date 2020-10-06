This folder contains a few examples of running locust docker images (using docker compose).

They include:
* running standalone node of locust (docker-compose-standalone.yml)
* running distributed locust cluster (docker-compose-distributed.yml)
* running distributed locust cluster without web ui with timed execution (docker-compose-distributed-headless.yml)

The examples use a simple locustfile (stored in a dedicated locust-scripts directory) that issues HTTP GET '/' requests and logs some information.

The examples for older versions of Locust (before 1.x) are stored in folder [0.13.5](./0.13.5).
The examples for current version of Locust (1.x) are stored in folder [1.x](./1.x).


To run relevant examples use docker-compose, for example:
```
docker-compose -f ./1.x/docker-compose-standalone.yml up
```
or:
```
docker-compose -f ./1.x/docker-compose-distributed.yml up
```
or:
```
docker-compose -f ./1.x/docker-compose-distributed-headless.yml up
```


To shut down example nodes use:
```
docker-compose -f ./1.x/docker-compose-standalone.yml down
```
or:
```
docker-compose -f ./1.x/docker-compose-distributed.yml down
```
or:
```
docker-compose -f ./1.x/docker-compose-distributed-headless.yml down
```

    For older examples (Locust 0.x), replace `./1.x/` with `./0.13.5/` in the path.