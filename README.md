# Kubernetes Exmaple of Traefik & Keycloak with ForwardAuth

The is an example setup of using Traefik & Keycloak with the FowardAuth middleware to protect access to a web-app.

Thi s is a very rough POC.  It can be installed using `setup.sh`.

## Traefik
See: https://doc.traefik.io/traefik/v2.6/

Installed as Helm chart using the `answers.traefik.yaml` file.  A second file, `answers.traefik.secrets.yaml` file is required with the following content:
```yaml
# Environment variables to be passed to Traefik's binary
env:
- name: CF_API_EMAIL
  value: user@domain.com
- name: CF_DNS_API_TOKEN
  value: cloudflare_dns_api_token
```
These settings are using for the LetEncypt dns authentication for generating ssl scripts.

Then an IngressRoute is created using the `traefik-dashboard.yaml` file in order to access the Traefik Dashboard for viewing the Traefik resources that are being created below.

##  Keycloak
See: https://www.keycloak.org/

Installed as Helm chart using the `answers.keycloak.yaml` file. 

The an IngressRoute to Keycloak is created using the `keycloak-ingress.yaml` file, in order to access the Keycloak UI in a browser.

 A realm needs to be created and the `traefik.json` file imported to create the client used by this app.

## ForwardAuth pod & middleware
See: https://github.com/mesosphere/traefik-forward-auth

Installed using `forwardauth.yaml` and a second file `forwarauth-secrets.yaml` that needs to be created with the following content:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: forwardauth-secrets
type: Opaque
data:
  SECRET:  "base64-encoded-random-signing-secret"
  CLIENT_SECRET: "base64-encoded-keycloak-client-secret"
```

## App Being Protected
Installed using `nginx-sample.yaml`.  This is just a simple web-app to demonstrate pre-authentication with ForwardAuth.