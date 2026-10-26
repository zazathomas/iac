# Master realm bootstrap

The master realm is intentionally a separate ownership and lifecycle boundary.
This directory documents the bootstrap contract without mixing master-realm
administration with tenant application configuration.

The bootstrap service identity must have only the permissions required to manage
the intended tenant realms. Store its credential outside Terraform state when
possible and rotate it through the platform secret-management workflow.

Add executable Terraform here only when master-realm ownership, state, and
break-glass procedures have been approved separately.
