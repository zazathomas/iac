output "zone_id" {
  description = "The managed Cloudflare zone ID."
  value       = cloudflare_zone.this.id
}

output "managed_record_names" {
  description = "DNS record keys managed by this configuration."
  value       = sort([for record in cloudflare_dns_record.this : record.name])
}
