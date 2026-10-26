# Infrastructure as Code

Terraform and Ansible configuration for the homelab:

- `cloudflare/`: Cloudflare zone and DNS records.
- `keycloak/`: Keycloak realms, clients, scopes, roles, and groups.
- `ansible-playbooks/`: Server configuration and maintenance playbooks.

GitHub Actions validates both Terraform projects and runs the Keycloak unit tests.
