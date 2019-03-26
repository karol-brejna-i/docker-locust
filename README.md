I wanted the image to:
* use Python 3.x
* use the latest version of Locust
* be as small as possible
* be simple to use
* take Locust scripts by means of mounting a volume

Most of the images found on docker hub was old (1-2 yo) so I decided to give it a try.

This one is based on python image for alpine, installs `locustio` package and required dependencies.
It weighs about 130MB.
 
# Repository structure and images tagging
The git project is organized so it can maintain many versions of the image.
Tagging "system" was chosen to easily distinguish between the versions.

## Repository structure

Folder structure looks like this:

```
   .
   |-- locust version a
   |   |--- python version x
   |   |    |--  OS version 1 
   |   |    `--  OS version 2 
   |   `--- python version y
   |        |---  OS version 1 
   |        `---  OS version 2 
   |-- locust version b
   ...
```

Where:
* `locust version` is a specific version of locust (i.e. 0.9.0)
* `python version` is a specific version of python (i.e. 3.6)
* `OS version 1` is a specific version of operating system (i.e. alpine3.9)

## Tagging structure
The tagging reflects the directory structure and contains information about all the components:
* locust version
* python version
* OS version


For example, for locust 0.10.0 that runs on Python 3.6 on Alpine 3.9 the dockerfile is placed in:
```
   \
   |--- 0.10.0
   | `-- python3.6
   |   `-- alpine3.9
```
The tag for this image will be: **grubykarol/locust:0.10.0-python3.6-alpine3.9**.

 
# Usage 
The image does not include locust scripts during build. It assumes, the scripts will be supplied on runtime by mounting a volume (to `/locust` path).

This gives the ability to use the exact same image for different deployments. There is no need to build your image that 
would inherit from this one and only include test scripts (although it's also possible). 

## Pulling the image
Choose locust, python and OS (Operating System) you want and pull an image tagged accordingly (see: [Tagging structure](#tagging-structure)):

```
docker pull grubykarol/locust:0.10.0-python3.6-alpine3.9 
```

## Running the image
The image uses the following environment variables to configure its behavior:

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
|LOCUST_FILE   | Sets the `--locustfile` option. | locustfile.py | |
|ATTACKED_HOST | The URL to test. Required. | - | http://example.com |
|LOCUST_MODE   | Set the mode to run in. Can be `standalone`, `master` or `slave`. | standalone | master |
|LOCUST_MASTER | Locust master IP or hostname. Required for `slave` mode.| - | 127.0.0.1 |
|LOCUST_MASTER_BIND_PORT | Locust master port for communication with slaves. Used in distributed mode.<br>For master: which port master should bind to.<br>For slave: port to connect on master. | 5557 | 6666 |
|LOCUST_OPTS| Additional locust CLI options. | - | "-c 10 -r 10" |


### Standalone

Basic run, with folder (path in $MY_SCRIPTS) holding `locustfile.py`:
```
docker run --rm --name standalone --hostname standalone -e ATTACKED_HOST=http://standalone:8089 -p 8089:8089 -d -v $MY_SCRIPTS:/locust grubykarol/locust:0.10.0-python3.6-alpine3.9
```
or, with additional runtime options:
```
docker run --rm --name standalone --hostname standalone -e ATTACKED_HOST=http://standalone:8089 -e "LOCUST_OPTS=--no-web" -p 8089:8089 -d -v $MY_SCRIPTS:/locust grubykarol/locust:0.10.0-python3.6-alpine3.9
```

### Master-slave

Run master:
```
docker run --name master --hostname master \
 -p 8089:8089 -p 5557:5557 -p 5558:5558 \
 -v $MY_SCRIPTS:/locust \
 -e ATTACKED_HOST='http://master:8089' \
 -e LOCUST_MODE=master \
 --rm -d grubykarol/locust:0.10.0-python3.6-alpine3.9
```

and some slaves:

```
docker run --name slave0 \
 --link master --env NO_PROXY=master \
 -v $MY_SCRIPTS:/locust \
 -e ATTACKED_HOST=http://master:8089 \
 -e LOCUST_MODE=slave \
 -e LOCUST_MASTER=master \
 --rm -d grubykarol/locust:0.10.0-python3.6-alpine3.9

docker run --name slave1 \
 --link master --env NO_PROXY=master \
 -v $MY_SCRIPTS:/locust \
 -e ATTACKED_HOST=http://master:8089 \
 -e LOCUST_MODE=slave \
 -e LOCUST_MASTER=master \
 --rm -d grubykarol/locust:0.10.0-python3.6-alpine3.9
```


For the real brave, Windows PowerShell version:

Basic run:
```
docker run --rm --name standalone `
 -e ATTACKED_HOST=http://localhost:8089 `
 -v c:\locust-scripts:/locust `
 -p 8089:8089 -d `
 grubykarol/locust:0.10.0-python3.6-alpine3.9
```

Run master:
```
docker run --name master --hostname master `
 -p 8089:8089 -p 5557:5557 -p 5558:5558 `
 -v c:\locust-scripts:/locust `
 -e ATTACKED_HOST='http://master:8089' `
 -e LOCUST_MODE=master `
 --rm -d grubykarol/locust:0.10.0-python3.6-alpine3.9
```

Run slave:
```
docker run --name slave0 `
 --link master --env NO_PROXY=master `
 -v c:\locust-scripts:/locust `
 -e ATTACKED_HOST=http://master:8089 `
 -e LOCUST_MODE=slave `
 -e LOCUST_MASTER=master `
 --rm -d grubykarol/locust:0.10.0-python3.6-alpine3.9
```

## Examples
TODO: run standalone headless

# Building the image
```
docker build -t grubykarol/locust:0.10.0-python3.6-alpine3.9 .
```
or (if behind a proxy):
```
docker build --build-arg HTTP_PROXY=$http_proxy --build-arg HTTPS_PROXY=$https_proxy -t grubykarol/locust:0.10.0-python3.6-alpine3.9 . 
```


# TODO

1. Add info about directory structure for maintaining multiple image versions (different locust, python, os versions)
2. Make build-all.sh readable
3. Add info about build (build-all.sh) script