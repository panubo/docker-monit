# Monit Docker Container

[![Docker Repository on Quay.io](https://quay.io/repository/panubo/monit/status "Docker Repository on Quay.io")](https://quay.io/repository/panubo/monit)

Docker optimised [Monit](https://mmonit.com/) container.

## Environment config

- `SMTP_HOST` - define this or link with an SMTP container that provides `SMTP_PORT_587_TCP_ADDR`
- `USERNAME` - auth username (default: admin)
- `PASSWORD` - auth password (required)
- `ALERT_EMAIL` - alert email address

## Special features

- Mount the host filesystems to /host and they will be added to the configuration automatically.
- Mount `/etc/monit/results` to the host and place the exit code of services to have them monitored. eg `example.service.result`

## Usage Example

```
docker run --rm --hostname myhost \
  -v /:/host/:ro \
  -v /dev:/host/dev \
  quay.io/panubo/monit
```
