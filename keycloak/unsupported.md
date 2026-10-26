# Deferred or externally owned resources

This file records resources intentionally outside the current steady-state
configuration. Each entry should have an owner and a migration path before it
is added to Terraform.

- The `master` realm is owned by the bootstrap boundary under `stacks/bootstrap`.
- Users and passwords are owned by the configured identity source.
- Keycloak built-in roles, default clients, internal clients, and generated
  objects remain unmanaged unless explicitly added to the tenant model.
- Federated groups and groups whose membership is managed by an external source
  remain outside Terraform. Role bindings are managed only where this repository
  owns the group.
- SMTP credentials remain outside Terraform. Non-secret SMTP settings should be
  brought under the realm security baseline when their ownership is approved.
- Authentication flows, event listeners, and provider capabilities not exposed
  by the pinned provider require a reviewed bootstrap or Admin API migration.
- Any resource that the provider cannot import safely belongs under
  `migrations/adoption/` until it has an approved steady-state owner.

Update this file when discovery finds an object skipped by policy or when the
provider adds support for a deferred resource.
