# The provider reads its endpoint and credentials from environment variables:
# KEYCLOAK_URL, KEYCLOAK_CLIENT_ID, KEYCLOAK_CLIENT_SECRET, and KEYCLOAK_REALM.
# Set KEYCLOAK_BASE_PATH=/auth for legacy WildFly-based installations.
provider "keycloak" {}
