# Bundling prebuilt librdkafka

confluent-kafka-go bundles prebuilt statically linked
versions of librdkafka for the following platforms:

 * MacOSX x64      (aka Darwin)
 * Linux glibc x64 (Ubuntu, CentOS, etc)
 * Linux musl x64  (Alpine)

## Update bundled libraries

    $ ./setup.sh ~/path/to/librdkafka-static-bundle-v1.1.0.tgz

This will copy the static libraries, pkg-config files, licences, rdkafka.h, etc,
to this directory, as well as generate updated ../build_..go files.
