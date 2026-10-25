#!/usr/bin/env bash
set -euo pipefail

: "${CLOUDFLARE_API_TOKEN:?Set CLOUDFLARE_API_TOKEN first}"
: "${TF_VAR_cloudflare_zone_id:?Set TF_VAR_cloudflare_zone_id first}"

command -v jq >/dev/null || {
  echo "jq is required" >&2
  exit 1
}

records_json="$(curl --fail-with-body --silent --show-error \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  -H "Content-Type: application/json" \
  "https://api.cloudflare.com/client/v4/zones/${TF_VAR_cloudflare_zone_id}/dns_records?per_page=100")"

if ! jq -e '.success == true' >/dev/null <<<"${records_json}"; then
  echo "Cloudflare API returned an unsuccessful response:" >&2
  jq . <<<"${records_json}" >&2
  exit 1
fi

import_record() {
  local key="$1"
  local name="$2"
  local type="$3"
  local content="$4"
  local priority="${5:-}"
  local record_id

  if [[ -n "${priority}" ]]; then
    record_id="$(jq -r --arg name "${name}" --arg type "${type}" --arg content "${content}" --argjson priority "${priority}" \
      '[.result[] | select(.name == $name and .type == $type and .content == $content and .priority == $priority) | .id] | if length == 1 then .[0] elif length == 0 then empty else error("multiple matching records") end' \
      <<<"${records_json}")"
  else
    record_id="$(jq -r --arg name "${name}" --arg type "${type}" --arg content "${content}" \
      '[.result[] | select(.name == $name and .type == $type and .content == $content) | .id] | if length == 1 then .[0] elif length == 0 then empty else error("multiple matching records") end' \
      <<<"${records_json}")"
  fi

  if [[ -z "${record_id}" || "${record_id}" == "null" ]]; then
    echo "Could not find exactly one Cloudflare record for ${key} (${type} ${name})" >&2
    exit 1
  fi

  echo "Importing ${key} (${type} ${name})"
  terraform import "cloudflare_dns_record.this[\"${key}\"]" "${TF_VAR_cloudflare_zone_id}/${record_id}"
}

import_record a_wildcard_access "*.access.z3cyber.tech" A "152.70.198.238"
import_record a_access "access.z3cyber.tech" A "152.70.198.238"
import_record a_addr "addr.z3cyber.tech" A "79.97.31.82"
import_record a_traefik_01_local "traefik-01.local.z3cyber.tech" A "192.168.20.11"
import_record a_traefik_02_local "traefik-02.local.z3cyber.tech" A "192.168.20.12"
import_record a_apex "z3cyber.tech" A "132.145.185.154"

import_record cname_argocd_home "argocd-home.z3cyber.tech" CNAME "a6e7a343-87b1-45e6-b62a-2c70a7a3b7f1.cfargotunnel.com"
import_record cname_argocd "argocd.z3cyber.tech" CNAME "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
import_record cname_blacwoodstudios "blacwoodstudios.z3cyber.tech" CNAME "addr.z3cyber.tech"
import_record cname_blog "blog.z3cyber.tech" CNAME "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
import_record cname_chat "chat.z3cyber.tech" CNAME "addr.z3cyber.tech"
import_record cname_echoserver "echoserver.z3cyber.tech" CNAME "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
import_record cname_echo "echo.z3cyber.tech" CNAME "a6e7a343-87b1-45e6-b62a-2c70a7a3b7f1.cfargotunnel.com"
import_record cname_em585137 "em585137.z3cyber.tech" CNAME "return.smtp2go.net"
import_record cname_jellyfin "jellyfin.z3cyber.tech" CNAME "addr.z3cyber.tech"
import_record cname_link "link.z3cyber.tech" CNAME "track.smtp2go.net"
import_record cname_s3_api "s3-api.z3cyber.tech" CNAME "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
import_record cname_s3 "s3.z3cyber.tech" CNAME "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
import_record cname_dkim "s585137._domainkey.z3cyber.tech" CNAME "dkim.smtp2go.net"
import_record cname_seerr "seerr.z3cyber.tech" CNAME "addr.z3cyber.tech"
import_record cname_sso "sso.z3cyber.tech" CNAME "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
import_record cname_termix "termix.z3cyber.tech" CNAME "addr.z3cyber.tech"
import_record cname_terrapod "terrapod.z3cyber.tech" CNAME "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
import_record cname_wg_cloud "wg-cloud.z3cyber.tech" CNAME "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
import_record cname_wg "wg.z3cyber.tech" CNAME "homebaymeadows.z3cyber.tech"
import_record cname_workflows "workflows.z3cyber.tech" CNAME "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"

import_record mx_primary "z3cyber.tech" MX "route2.mx.cloudflare.net" 5
import_record mx_secondary "z3cyber.tech" MX "route1.mx.cloudflare.net" 9
import_record mx_tertiary "z3cyber.tech" MX "route3.mx.cloudflare.net" 94

import_record txt_dkim "cf2024-1._domainkey.z3cyber.tech" TXT '"v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78k" "m4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB'
import_record txt_spf "z3cyber.tech" TXT '"v=spf1 include:_spf.mx.cloudflare.net ~all"'
