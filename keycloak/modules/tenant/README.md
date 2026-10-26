# Tenant module

The tenant module is the composition boundary for one Keycloak realm. It owns
resource relationships between the realm, clients, scopes, roles, groups,
mappings, and protocol mappers.

Callers provide a typed tenant definition. They should not construct provider
resources directly. Stable map keys are used for Terraform addresses and should
not be changed casually after adoption.

The module delegates provider implementation to the smaller modules in this
directory. Security baseline fields are passed through the realm interface so
platform security settings have an explicit owner without being mixed into
application definitions. Group nesting currently supports one child level;
use separate ownership or an approved extension before introducing deeper
hierarchies.
