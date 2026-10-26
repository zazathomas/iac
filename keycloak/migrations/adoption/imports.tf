# Temporary import declarations for the homelab tenant composition.
# Copy into a reviewed root migration branch before applying.
# Remove this file after the adoption apply.
import {
  to = module.realms.module.tenant["homelab"].module.realm.keycloak_realm.this
  id = "homelab"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_client["actual"].keycloak_openid_client.this
  id = "homelab/1910e4a3-5cb7-419b-a418-ea1bd4288db5"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_client["argocd"].keycloak_openid_client.this
  id = "homelab/d3d1ccb4-cf02-4532-af64-ea0f206d0086"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_client["gateway"].keycloak_openid_client.this
  id = "homelab/610d504d-5e6a-47b1-af84-3905f0a6d732"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_client["grafana"].keycloak_openid_client.this
  id = "homelab/6988a335-57c7-496b-bfa8-7091c1b485a1"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_client["harbor"].keycloak_openid_client.this
  id = "homelab/a77ca314-1c21-4a32-b8e4-e33aa30bc4af"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_client["karakeep"].keycloak_openid_client.this
  id = "homelab/2b6e8a7a-7604-4dbe-8b61-8499b779bc6d"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_client["kubernetes"].keycloak_openid_client.this
  id = "homelab/ed650e3a-07c9-462e-80ce-5eb3b297f0e2"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_client["pomerium"].keycloak_openid_client.this
  id = "homelab/60c7751d-c512-4b2b-9fc8-eed0b6748332"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_client["traefik_dmz"].keycloak_openid_client.this
  id = "homelab/9b47e4b2-06b3-49a8-9775-b60a533cdd2a"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_client["vikunja"].keycloak_openid_client.this
  id = "homelab/de1b808a-865c-4684-924b-213e1dfa5a10"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_client["workflows"].keycloak_openid_client.this
  id = "homelab/f0ba2ed2-fc1d-4987-a979-7f55f7bdebac"
}

import {
  to = module.realms.module.tenant["homelab"].module.saml_scope["role_list"].keycloak_saml_client_scope.this
  id = "homelab/0c3599f5-1a2a-448e-abfd-65fd719bdebb"
}

import {
  to = module.realms.module.tenant["homelab"].module.saml_scope["saml_organization"].keycloak_saml_client_scope.this
  id = "homelab/a6912fc0-8837-4919-a4c3-b1593efdd21c"
}

import {
  to = module.realms.module.tenant["homelab"].module.saml_scope["authn_context"].keycloak_saml_client_scope.this
  id = "homelab/a9e84737-e9c6-4887-817e-e57ac2cf8923"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_scope["organization"].keycloak_openid_client_scope.this
  id = "homelab/2c07bd0e-d2cb-41fe-a3c0-0c51ab95d442"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_scope["sample"].keycloak_openid_client_scope.this
  id = "homelab/b9741450-de31-4451-9bb8-cffe0d7ba6d6"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_scope["service_account"].keycloak_openid_client_scope.this
  id = "homelab/893f5654-130b-4d60-b137-d79596cbdf68"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_scope["groups"].keycloak_openid_client_scope.this
  id = "homelab/ee9390e8-dae5-41e8-94e8-358633b55156"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_default_scopes["actual"].keycloak_openid_client_default_scopes.this
  id = "homelab/1910e4a3-5cb7-419b-a418-ea1bd4288db5"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_optional_scopes["actual"].keycloak_openid_client_optional_scopes.this
  id = "homelab/1910e4a3-5cb7-419b-a418-ea1bd4288db5"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_default_scopes["argocd"].keycloak_openid_client_default_scopes.this
  id = "homelab/d3d1ccb4-cf02-4532-af64-ea0f206d0086"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_optional_scopes["argocd"].keycloak_openid_client_optional_scopes.this
  id = "homelab/d3d1ccb4-cf02-4532-af64-ea0f206d0086"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_default_scopes["gateway"].keycloak_openid_client_default_scopes.this
  id = "homelab/610d504d-5e6a-47b1-af84-3905f0a6d732"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_optional_scopes["gateway"].keycloak_openid_client_optional_scopes.this
  id = "homelab/610d504d-5e6a-47b1-af84-3905f0a6d732"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_default_scopes["grafana"].keycloak_openid_client_default_scopes.this
  id = "homelab/6988a335-57c7-496b-bfa8-7091c1b485a1"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_optional_scopes["grafana"].keycloak_openid_client_optional_scopes.this
  id = "homelab/6988a335-57c7-496b-bfa8-7091c1b485a1"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_default_scopes["harbor"].keycloak_openid_client_default_scopes.this
  id = "homelab/a77ca314-1c21-4a32-b8e4-e33aa30bc4af"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_optional_scopes["harbor"].keycloak_openid_client_optional_scopes.this
  id = "homelab/a77ca314-1c21-4a32-b8e4-e33aa30bc4af"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_default_scopes["karakeep"].keycloak_openid_client_default_scopes.this
  id = "homelab/2b6e8a7a-7604-4dbe-8b61-8499b779bc6d"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_optional_scopes["karakeep"].keycloak_openid_client_optional_scopes.this
  id = "homelab/2b6e8a7a-7604-4dbe-8b61-8499b779bc6d"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_default_scopes["kubernetes"].keycloak_openid_client_default_scopes.this
  id = "homelab/ed650e3a-07c9-462e-80ce-5eb3b297f0e2"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_optional_scopes["kubernetes"].keycloak_openid_client_optional_scopes.this
  id = "homelab/ed650e3a-07c9-462e-80ce-5eb3b297f0e2"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_default_scopes["pomerium"].keycloak_openid_client_default_scopes.this
  id = "homelab/60c7751d-c512-4b2b-9fc8-eed0b6748332"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_optional_scopes["pomerium"].keycloak_openid_client_optional_scopes.this
  id = "homelab/60c7751d-c512-4b2b-9fc8-eed0b6748332"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_default_scopes["traefik_dmz"].keycloak_openid_client_default_scopes.this
  id = "homelab/9b47e4b2-06b3-49a8-9775-b60a533cdd2a"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_optional_scopes["traefik_dmz"].keycloak_openid_client_optional_scopes.this
  id = "homelab/9b47e4b2-06b3-49a8-9775-b60a533cdd2a"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_default_scopes["vikunja"].keycloak_openid_client_default_scopes.this
  id = "homelab/de1b808a-865c-4684-924b-213e1dfa5a10"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_optional_scopes["vikunja"].keycloak_openid_client_optional_scopes.this
  id = "homelab/de1b808a-865c-4684-924b-213e1dfa5a10"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_default_scopes["workflows"].keycloak_openid_client_default_scopes.this
  id = "homelab/f0ba2ed2-fc1d-4987-a979-7f55f7bdebac"
}

import {
  to = module.realms.module.tenant["homelab"].module.openid_optional_scopes["workflows"].keycloak_openid_client_optional_scopes.this
  id = "homelab/f0ba2ed2-fc1d-4987-a979-7f55f7bdebac"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["homelab_admin"].keycloak_role.this
  id = "homelab/0ca67f6b-e13f-4bfa-a7fb-2c2240989b6e"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["argocd_admin"].keycloak_role.this
  id = "homelab/c3b570a1-9a3b-40b1-bd51-8f6af92fbc15"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["argocd_user"].keycloak_role.this
  id = "homelab/76222faf-cd56-4d42-8511-11c7924fbe57"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["grafana_admin"].keycloak_role.this
  id = "homelab/92ec2076-8083-463b-8969-007590c4d25b"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["grafana_editor"].keycloak_role.this
  id = "homelab/091cab52-c4d7-49f7-8824-df467e4713d2"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["grafana_admin_named"].keycloak_role.this
  id = "homelab/8af3b68b-d2d1-4281-9b06-a0831e1f8956"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["grafana_viewer"].keycloak_role.this
  id = "homelab/f743f571-e3f9-4757-b861-df743efe5817"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["harbor_admin"].keycloak_role.this
  id = "homelab/7bffc969-9ce0-4b68-9c0e-a409b173e16c"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["harbor_user"].keycloak_role.this
  id = "homelab/369625c6-6d56-447e-8b5a-7a075227e9c4"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["harbor_uma_protection"].keycloak_role.this
  id = "homelab/504b665b-6d28-45df-b142-e87f135a83a4"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["workflows_admin"].keycloak_role.this
  id = "homelab/0625e6da-cb1e-4b39-a87c-e075e96978e5"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["workflows_default"].keycloak_role.this
  id = "homelab/0437f0cf-6222-4558-8c7d-4fa0706e0073"
}

import {
  to = module.realms.module.tenant["homelab"].module.role["workflows_user"].keycloak_role.this
  id = "homelab/82a11b17-f53c-4277-a3c0-7da6c81a8ba8"
}

import {
  to = module.realms.module.tenant["homelab"].module.group["argocd_admins"].keycloak_group.this
  id = "homelab/f1fca0a1-b1a0-4351-83f2-c607e4dd2a80"
}

import {
  to = module.realms.module.tenant["homelab"].module.group["harbor_admins"].keycloak_group.this
  id = "homelab/e12a0236-7ba5-4113-b99e-4812b33dcef3"
}

import {
  to = module.realms.module.tenant["homelab"].module.group["k8s_admins"].keycloak_group.this
  id = "homelab/f75587f0-e476-4b75-bbee-14c28cb416fe"
}

import {
  to = module.realms.module.tenant["homelab"].module.group["k8s_learners"].keycloak_group.this
  id = "homelab/68e4ca1d-3cf5-4a7a-85ec-e581bb55ffec"
}

import {
  to = module.realms.module.tenant["homelab"].module.group["k8s_operators"].keycloak_group.this
  id = "homelab/0747b748-a2f5-4591-823c-dd51877eae3a"
}

import {
  to = module.realms.module.tenant["homelab"].module.group["k8s_readonly"].keycloak_group.this
  id = "homelab/701a879d-122a-406c-85e5-4a90b644b764"
}

import {
  to = module.realms.module.tenant["homelab"].module.group["workflows_admins"].keycloak_group.this
  id = "homelab/b9495757-fd30-4fa9-8f8e-4bbab90c0fab"
}

import {
  to = module.realms.module.tenant["homelab"].module.group_roles["argocd_admins"].keycloak_group_roles.this
  id = "homelab/f1fca0a1-b1a0-4351-83f2-c607e4dd2a80"
}

import {
  to = module.realms.module.tenant["homelab"].module.group_roles["harbor_admins"].keycloak_group_roles.this
  id = "homelab/e12a0236-7ba5-4113-b99e-4812b33dcef3"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["argocd_client_roles"].keycloak_generic_protocol_mapper.this
  id = "homelab/client/d3d1ccb4-cf02-4532-af64-ea0f206d0086/b9c683f0-e3fc-4f72-931f-f7e7dca09854"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["gateway_realm_roles"].keycloak_generic_protocol_mapper.this
  id = "homelab/client/610d504d-5e6a-47b1-af84-3905f0a6d732/681105f3-9f1a-4e72-b9f9-30d5010f9265"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["grafana_roles"].keycloak_generic_protocol_mapper.this
  id = "homelab/client/6988a335-57c7-496b-bfa8-7091c1b485a1/c81309c1-abfc-490e-9992-ec7dc5e1a44e"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["kubernetes_audience"].keycloak_generic_protocol_mapper.this
  id = "homelab/client/ed650e3a-07c9-462e-80ce-5eb3b297f0e2/85f296df-c888-4763-8c93-e7a0cc705e50"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["workflows_client_roles"].keycloak_generic_protocol_mapper.this
  id = "homelab/client/f0ba2ed2-fc1d-4987-a979-7f55f7bdebac/fdd6e202-de3b-459b-9c82-f447b441f077"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["role_list"].keycloak_generic_protocol_mapper.this
  id = "homelab/client-scope/0c3599f5-1a2a-448e-abfd-65fd719bdebb/da21458e-87b3-4383-b021-69d06d6aabb1"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["saml_organization"].keycloak_generic_protocol_mapper.this
  id = "homelab/client-scope/a6912fc0-8837-4919-a4c3-b1593efdd21c/3f09af06-5e84-4907-8f86-946d9f06640c"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["authn_context"].keycloak_generic_protocol_mapper.this
  id = "homelab/client-scope/a9e84737-e9c6-4887-817e-e57ac2cf8923/d4e570ad-3800-49cb-be05-3eabef6300de"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["organization"].keycloak_generic_protocol_mapper.this
  id = "homelab/client-scope/2c07bd0e-d2cb-41fe-a3c0-0c51ab95d442/fc6ce245-1a8a-43f5-92b0-dafbe0adb2f5"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["sample"].keycloak_generic_protocol_mapper.this
  id = "homelab/client-scope/b9741450-de31-4451-9bb8-cffe0d7ba6d6/02410394-c209-4cee-89e0-f7bad4d6eeda"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["service_account_client_id"].keycloak_generic_protocol_mapper.this
  id = "homelab/client-scope/893f5654-130b-4d60-b137-d79596cbdf68/c684dd80-cae8-4e2d-a459-dc09028460c9"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["service_account_client_ip"].keycloak_generic_protocol_mapper.this
  id = "homelab/client-scope/893f5654-130b-4d60-b137-d79596cbdf68/cb3b56ed-5d2f-4a2d-bf54-8e6b783451d8"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["service_account_client_host"].keycloak_generic_protocol_mapper.this
  id = "homelab/client-scope/893f5654-130b-4d60-b137-d79596cbdf68/d6c913e9-2702-4db5-bcbc-a9dbfaaa5a30"
}

import {
  to = module.realms.module.tenant["homelab"].module.protocol_mapper["groups"].keycloak_generic_protocol_mapper.this
  id = "homelab/client-scope/ee9390e8-dae5-41e8-94e8-358633b55156/a713d8c5-9c43-4b13-9940-df0b5158faee"
}
