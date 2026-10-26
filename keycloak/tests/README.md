# Tests

`tests/unit` contains offline Python tests for discovery and deterministic
rendering. They do not require a Keycloak instance.

`tests/fixtures` contains small plan and inventory fixtures for policy and
renderer tests. Live provider tests should run in a separately provisioned
Keycloak environment and must never use production state.
