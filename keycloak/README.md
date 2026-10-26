# Keycloak Terraform configuration

This repository manages tenant realms through a typed identity model. The root
configuration is intentionally small. It passes tenant definitions to the
`stacks/realms` composition stack, which instantiates the reusable modules
under `modules/`.

The current tenant definition is in `tenant_definitions.tf`. Add a new tenant
there only when the same definition belongs in this state. For separate blast
radius, create a separate environment or state configuration.

## Repository layout

- `modules/`: reusable provider-facing modules.
- `stacks/`: composition boundaries such as tenant realms and bootstrap.
- `tenant_definitions.tf`: engineer-facing tenant, application, scope, role,
  group, and mapper model.
- `policies/`: Rego policies for plan-level identity controls.
- `tests/`: offline renderer, discovery, fixture, and policy tests.
- `migrations/adoption/`: temporary discovery and import material only.
- `scripts/`: discovery and migration helpers, never the canonical source.

## Ownership model

- The identity platform team owns realm composition and application registration.
- Platform security owns the realm security baseline and policy files.
- Application owners own redirect URIs, audiences, and requested scopes.
- The configured identity source owns users and federated group membership.
- Secret management owns client credentials. Secrets must not be committed or
  emitted as Terraform outputs.

Ownership is recorded per tenant in the `ownership` object. Changes that cross
an ownership boundary require review from the owning team.

## Required environment variables

```sh
export KEYCLOAK_URL='https://keycloak.example.com'
export KEYCLOAK_REALM='master'
export KEYCLOAK_CLIENT_ID='terraform'
export KEYCLOAK_CLIENT_SECRET='...'
```

For a legacy WildFly installation, also set `KEYCLOAK_BASE_PATH='/auth'`.
Prefer a short-lived CI identity or secret-manager injection over long-lived
local credentials.

## Common workflows

Validate the repository without contacting Keycloak:

```sh
make check
```

Run a plan with the remote workspace after authentication:

```sh
terraform login terrapod.z3cyber.tech
terraform init
terraform plan
```

Evaluate identity policies against a saved plan:

```sh
terraform show -json /tmp/keycloak.tfplan >/tmp/keycloak-plan.json
make policy POLICY_INPUT=/tmp/keycloak-plan.json
```

## Adding a client

1. Add a stable logical key under the appropriate tenant in
   `tenant_definitions.tf`.
2. Select the client protocol and intended client type.
3. Add only the redirect URIs, origins, scopes, audiences, and roles required by
   the application.
4. Add the application owner and security review context.
5. Run `make check` and inspect the full plan.
6. Run policy evaluation before requesting apply approval.

Provider-specific implementation belongs in `modules/tenant` and the reusable
modules, not in application definitions.

## Adoption workflow

Adoption material belongs under `migrations/adoption/` and is not steady-state
configuration:

```sh
python3 scripts/discover.py --realm homelab
python3 scripts/render_flat.py --inventory migrations/adoption/generated/inventory.json
```

Review all skipped resources and imports. Copy only approved values into the
tenant model, apply the import migration, then remove the import declarations
and generated output. Generated migration output is ignored by Git because it
contains environment-specific metadata.

## Safety rules

- Do not commit state, plans, `.tfvars`, credentials, or generated discovery data.
- Do not add wildcard redirects or origins without a reviewed exception.
- Do not bypass policy checks in the tenant model.
- Treat `moved.tf` as temporary state-migration code. Remove it after all states
  have completed the layout migration.
- Review destructive changes separately from normal application changes.
