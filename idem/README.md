# `cnafsd/mdq-server`

## `mdq-server` Proof of Concept Deployment

This project is a proof of concept deployment of the
[`mdq-server`](https://github.com/iay/mdq-server) web application
customised to serve up metadata from the
[IDEM Federation](https://www.idem.garr.it/) and the
[eduGAIN](http://www.edugain.org) inter-federation metadata exchange service.

Deployment is via a [Docker](http://www.docker.com) container built
on top of the `ianayoung/mdq-server` image.

## Configuration and Build

Configuration of the application is performed by modifying the files
in `resources/`, in particular the `config.xml` and `config/application.properties`
files. These assume the baseline configuration from the upstream
[`mdq-server`](https://github.com/iay/mdq-server) project.

If you don't want to sign the resulting metadata responses at all,
change `spring.profiles.active` to exclude the `sign` profile.

If you want to use signing credentials of your own, create a directory
called `creds` inside the repository and put the private key and
certificate in there. This directory will be mounted as a volume inside
the Docker container, and is `.gitignore`d, so you don't need to worry
about those credentials being saved somewhere you don't want them to be.

The default names for the credential files are `signing.key` and
`signing.crt`. If you want to use other names for some reason, change
`application.properties` accordingly.

If you want to sign responses but don't have existing credentials you
want to use, just execute the `./keygen` script once. This will create a
`creds` directory and populate it with a 2048-bit private key and a
corresponding 10-year self-signed certificate.

To build the image, execute the `./build` script. This will tag the
resulting image as `cnafsd/mdq-server`, but won't push it anywhere.

## Simple Container Operation

A `docker-compose.yml` file is provided in order to run a container called `mdq-server`.

Basically, it binds the files located in the `resource` directory as volumes
connected to the container and maps the host port 8080 to the container port 80.

