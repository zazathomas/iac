locals {
  dns_records = {
    a_addr = {
      name    = "addr.z3cyber.tech"
      type    = "A"
      content = "79.97.31.82"
      ttl     = 1
      proxied = false
    }
    a_traefik_01_local = {
      name    = "traefik-01.local.z3cyber.tech"
      type    = "A"
      content = "192.168.20.11"
      ttl     = 1
      proxied = false
    }
    a_traefik_02_local = {
      name    = "traefik-02.local.z3cyber.tech"
      type    = "A"
      content = "192.168.20.12"
      ttl     = 1
      proxied = false
    }
    a_apex = {
      name    = "z3cyber.tech"
      type    = "A"
      content = "132.145.185.154"
      ttl     = 1
      proxied = false
    }

    cname_argocd_home = {
      name    = "argocd-home.z3cyber.tech"
      type    = "CNAME"
      content = "a6e7a343-87b1-45e6-b62a-2c70a7a3b7f1.cfargotunnel.com"
      ttl     = 1
      proxied = true
    }
    cname_argocd = {
      name    = "argocd.z3cyber.tech"
      type    = "CNAME"
      content = "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
      ttl     = 1
      proxied = true
    }
    cname_blacwoodstudios = {
      name    = "blacwoodstudios.z3cyber.tech"
      type    = "CNAME"
      content = "addr.z3cyber.tech"
      ttl     = 1
      proxied = false
    }
    cname_blog = {
      name    = "blog.z3cyber.tech"
      type    = "CNAME"
      content = "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
      ttl     = 1
      proxied = true
    }
    cname_chat = {
      name    = "chat.z3cyber.tech"
      type    = "CNAME"
      content = "addr.z3cyber.tech"
      ttl     = 1
      proxied = true
    }
    cname_em585137 = {
      name    = "em585137.z3cyber.tech"
      type    = "CNAME"
      content = "return.smtp2go.net"
      ttl     = 1
      proxied = false
    }
    cname_jellyfin = {
      name    = "jellyfin.z3cyber.tech"
      type    = "CNAME"
      content = "addr.z3cyber.tech"
      ttl     = 1
      proxied = false
    }
    cname_link = {
      name    = "link.z3cyber.tech"
      type    = "CNAME"
      content = "track.smtp2go.net"
      ttl     = 1
      proxied = false
    }
    cname_s3_api = {
      name    = "s3-api.z3cyber.tech"
      type    = "CNAME"
      content = "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
      ttl     = 1
      proxied = true
    }
    cname_s3 = {
      name    = "s3.z3cyber.tech"
      type    = "CNAME"
      content = "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
      ttl     = 1
      proxied = true
    }
    cname_dkim = {
      name    = "s585137._domainkey.z3cyber.tech"
      type    = "CNAME"
      content = "dkim.smtp2go.net"
      ttl     = 1
      proxied = false
    }
    cname_seerr = {
      name    = "seerr.z3cyber.tech"
      type    = "CNAME"
      content = "addr.z3cyber.tech"
      ttl     = 1
      proxied = false
    }
    cname_sso = {
      name    = "sso.z3cyber.tech"
      type    = "CNAME"
      content = "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
      ttl     = 1
      proxied = true
    }
    cname_termix = {
      name    = "termix.z3cyber.tech"
      type    = "CNAME"
      content = "addr.z3cyber.tech"
      ttl     = 1
      proxied = false
    }
    cname_terrapod = {
      name    = "terrapod.z3cyber.tech"
      type    = "CNAME"
      content = "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
      ttl     = 1
      proxied = true
    }
    cname_wg_cloud = {
      name    = "wg.z3cyber.tech"
      type    = "CNAME"
      content = "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
      ttl     = 1
      proxied = true
    }
    cname_workflows = {
      name    = "workflows.z3cyber.tech"
      type    = "CNAME"
      content = "a2364c18-6dbc-4824-973b-af1e25830511.cfargotunnel.com"
      ttl     = 1
      proxied = true
    }

    test_record = {
      name    = "test-rec.z3cyber.tech"
      type    = "A"
      content = "192.168.0.1"
      ttl     = 1
      proxied = true
    }

    mx_primary = {
      name     = "z3cyber.tech"
      type     = "MX"
      content  = "route2.mx.cloudflare.net"
      priority = 5
      ttl      = 1
      proxied  = false
    }
    mx_secondary = {
      name     = "z3cyber.tech"
      type     = "MX"
      content  = "route1.mx.cloudflare.net"
      priority = 9
      ttl      = 1
      proxied  = false
    }
    mx_tertiary = {
      name     = "z3cyber.tech"
      type     = "MX"
      content  = "route3.mx.cloudflare.net"
      priority = 94
      ttl      = 1
      proxied  = false
    }

    txt_dkim = {
      name    = "cf2024-1._domainkey.z3cyber.tech"
      type    = "TXT"
      content = "\"v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78k\" \"m4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB\""
      ttl     = 1
      proxied = false
    }
    txt_spf = {
      name    = "z3cyber.tech"
      type    = "TXT"
      content = "\"v=spf1 include:_spf.mx.cloudflare.net ~all\""
      ttl     = 1
      proxied = false
    }
  }
}

resource "cloudflare_dns_record" "this" {
  for_each = local.dns_records

  zone_id  = cloudflare_zone.this.id
  name     = each.value.name
  type     = each.value.type
  content  = each.value.content
  ttl      = each.value.ttl
  proxied  = each.value.proxied
  priority = try(each.value.priority, null)
}
