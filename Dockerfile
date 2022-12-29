# use a distroless base image with glibc
FROM gcr.io/distroless/base-debian11:nonroot

# copy our compiled binary
COPY --chown=frp ./bin/* /usr/local/bin/

# run as non-privileged user
USER frp

# command / entrypoint of container
ENTRYPOINT ["frpc", "--version"]
