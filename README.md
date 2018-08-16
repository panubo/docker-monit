# Monit Docker Image

Docker optimised [Monit](https://mmonit.com/) image.

## Environment config

- `SMTP_HOST` - define this or link with an SMTP container that provides `SMTP_PORT_587_TCP_ADDR`
- `USERNAME` - auth username (default: admin)
- `PASSWORD` - auth password (required)
- `ALERT_EMAIL` - alert email address

## Special features

- Mount the host filesystems to /host and they will be added to the configuration automatically.
- Mount `/etc/monit/results` to the host and place the exit code of services to have them monitored. eg `example.service.result`
- Custom scripts in `checks` which will automatically be added and run.

## Usage Example

```
docker run --rm --hostname myhost \
  --security-opt label:disable \
  --privileged \
  -v /:/host/:ro \
  -v /dev:/host/dev \
  quay.io/panubo/monit
```
