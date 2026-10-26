# Operations guide

## Change workflow

1. Make a change in the typed tenant model or reusable module.
2. Run `make check`.
3. Generate a plan from the intended environment.
4. Run `make policy POLICY_INPUT=/path/to/plan.json`.
5. Review the plan with the application owner and the owning security team.
6. Apply through the approved remote workspace.
7. Record the resulting change and any exceptions.

Terraform applies should be serialized per state. Use a lower provider parallelism
when the Keycloak API or reverse proxy is rate-limited.

## Credential rotation

Client secrets are application credentials, not Terraform outputs. Store them in
the approved secret manager, rotate them on a defined schedule, and update the
application and Keycloak in a coordinated rollout. Use a separate client for
machine-to-machine access rather than reusing a browser client.

## Adoption and migration

Use only `migrations/adoption/` for discovery and imports. After adoption, remove
imports and generated files. Keep `moved.tf` only until every state has completed
the address migration.

## Recovery

The Keycloak deployment and its database are outside this repository's resource
model. The platform runbook must cover:

- highly available Keycloak instances;
- external database backups and point-in-time recovery;
- backup restore testing;
- TLS certificate and DNS recovery;
- provider and Keycloak version upgrades;
- recovery of the remote Terraform state;
- re-running a plan after a restored Keycloak database.
