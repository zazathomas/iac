# Security controls

This repository contains identity configuration. Treat changes as security-
sensitive infrastructure changes.

## Required controls

- Keep provider credentials outside the repository and inject them through a
  secret manager or short-lived CI identity.
- Keep Terraform state in an access-controlled remote backend with encryption,
  locking, retention, and audit logging.
- Review redirect URIs, web origins, audiences, scopes, roles, and protocol
  mappers as authorization changes.
- Run the Rego policies against every reviewed plan.
- Do not use wildcard redirects, wildcard origins, broad scopes, or direct grant
  flows without a documented exception.
- Rotate client credentials through the approved secret-management workflow.
- Keep master-realm administration separate from tenant application changes.

## Security exceptions

An exception must include the application owner, reason, affected client or
scope, compensating control, expiry date, and approving security reviewer. An
exception belongs in the tenant model and the change request. Do not hide it in
`ignore_changes` or an unreviewed provider escape hatch.

## Incident response

If a client credential, redirect URI, role mapping, or protocol mapper is
suspected to be compromised:

1. Disable the affected client if safe to do so.
2. Rotate credentials in the secret manager and Keycloak.
3. Review Keycloak admin and client login events.
4. Revoke active sessions or grants where required.
5. Preserve the Terraform plan, state audit, and change approval records.
