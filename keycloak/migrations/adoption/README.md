# Adoption migrations

This directory contains temporary material used to discover and import an
existing Keycloak installation. It is not part of the steady-state Terraform
configuration.

Workflow:

1. Run `scripts/discover.py` with an explicit output directory.
2. Review the inventory and skipped resources.
3. Render migration-only Terraform with `scripts/render_flat.py`; its output is
   for a temporary migration working tree, not the canonical root stack.
4. Copy only reviewed declarations into the tenant input model.
5. Use the checked-in `imports.tf` addresses when importing into the current
   tenant stack, or generate a reviewed equivalent after changing tenant keys.
6. Run a plan from the repository root and apply imports only after review.
7. Remove import declarations and migration output after adoption.

Generated output is ignored by Git because it contains environment-specific
metadata. Keep an approved inventory in a separate audit store when required.
