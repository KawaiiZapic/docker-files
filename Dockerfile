# use a distroless base image with glibc
FROM gcr.io/distroless/base-debian11:nonroot

# copy our compiled binary
COPY --chown=nonroot ./bin/* /usr/local/bin/

# run as non-privileged user
USER nonroot

