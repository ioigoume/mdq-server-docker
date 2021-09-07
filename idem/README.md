# `cnafsd/mdq-server`

## `mdq-server` Proof of Concept Deployment

This project is a proof of concept deployment of the
[`mdq-server`](https://github.com/iay/mdq-server) web application
customised to serve up metadata from:

* [IDEM federation](https://www.idem.garr.it/) metadata exchange service, which belongs to the
[eduGAIN inter-federation](http://www.edugain.org) service
* test entities, *i.e.* `test-idp.cloud.cnaf.infn.it` and a cloud of test idps configured on `kc-test.cloud.cnaf.infn.it`.

For IDEM/EduGain aggregate it basically checks the "valid until" field, checks the IDEM signature, filters out the service providers and signs the new metadata; for test entities it just apply the signing phase.

Deployment is via a [Docker](http://www.docker.com) container built
on top of the `ianayoung/mdq-server` image.

## Configuration and Build

Configuration of the application is performed by modifying the files
in `resources/`, in particular the `config.xml` and `config/application.properties`
files; the `entities.xml` file contains metadata of test entities. These assume the baseline configuration from the upstream
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
`config/application.properties` accordingly.

If you want to sign responses but don't have existing credentials you
want to use, just execute the `./keygen` script once. This will create a
`creds` directory and populate it with a 2048-bit private key and a
corresponding 10-year self-signed certificate.

The metadata source refresh interval is set to 6 hours. If you want to customize it, change the `metadataService.SAML.refreshInterval` property in `config/application.properties`.

To build the image, execute the `./build-image` script. This will tag the
resulting image as `cnafsd/mdq-server`, but won't push it anywhere.

An image constructed from the very latest push to this repository can be found on [Docker Hub](https://hub.docker.com/r/cnafsd/mdq-server).

## Simple Container Operation

A `docker-compose.yml` file is provided in order to run a container called `mdq-server`.

Basically, it binds the files located in the `resource` directory as volumes
connected to the container and maps the host port 8080 to the container port 80.

Three local directories are binded as volumes connected to the container:

* The `creds` directory, `/opt/mdq-server/creds` in the container,
  is the volume the application pulls its credentials from.

* The `logs` directory, `/opt/mdq-server/logs` in the container,
  is the volume the application logs into. The log file is called
  `spring.log` by default.

* The `shared-volume` directory, `/root/shared-volume` in the container,
  is the volume the application saves output files:  
  * `discofeed.json` and `filtered-aggregate.xml` files with filtered aggregate obtained from IDEM/EduGain and test entities metadata;
  * filtered and signed xml metadata files, one for each entityID

Because they are mounted as volumes, the contents of these two directories
persist between container invocations.

## Fetch data from server

A simple shell script ([mdq_url.sh](scripts/mdq_url.sh)) compute the request URL for the given IDENTIFIER as specified by the MDQ protocol. 

Set  the environment variable MDQ_BASE_URL before using this script if you don't want to use the default url `mdq-test.cloud.cnaf.infn.it`. If you do not pass any argument to the script, the INFN idp's entityID is used as default identifier.

Usage example:
```
 $ export MDQ_BASE_URL=mdq.example.com/public
 $ ./scripts/mdq_url.sh -v https://sso.example.org/idp
 Using base URL http://mdq.example.com/public
 http://mdq.example.com/public/entities/https%3A%2F%2Fsso.example.org%2Fidp
```
