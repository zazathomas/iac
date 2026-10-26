# Terraform policies

The Rego policies in this directory evaluate `terraform show -json` plan output.
They enforce repository-level identity rules that generic Terraform scanners do
not understand.

Run them against a saved plan with:

```sh
make policy POLICY_INPUT=/path/to/plan.json
```

The current policy set covers wildcard redirect and origin values, broad client
scope, direct access grants, PKCE for public clients, offline access, and basic
resource naming. Exceptions should be represented in the tenant input model and
reviewed by platform security rather than silently bypassed in policy.
