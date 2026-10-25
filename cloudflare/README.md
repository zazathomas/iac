# z3cyber.tech Cloudflare DNS

Terraform configuration for the `z3cyber.tech` Cloudflare zone and the DNS records.

The provider uses the `CLOUDFLARE_API_TOKEN` environment variable. The token should have zone read/edit permissions for `z3cyber.tech`.

## Usage

```sh
cd terraform/cloudflare
export TF_VAR_cloudflare_account_id='your-cloudflare-account-id'
export TF_VAR_cloudflare_zone_id='your-z3cyber-tech-zone-id'
export CLOUDFLARE_API_TOKEN='...'
terraform login terrapod.z3cyber.tech
terraform init
terraform plan
```

State is stored in the `cloudflare` workspace in the `default` organization on `https://terrapod.z3cyber.tech`. Configure that workspace for local execution if it is not already configured. The zone import is declared in `zone.tf` and will be performed by `terraform apply`.

## Import existing DNS records

DNS record IDs are not present in the BIND export. First import the zone, then use the included script to look up and import all 31 DNS records:

```sh
terraform apply -target=cloudflare_zone.this
./import-records.sh
```

The script requires `curl`, `jq`, and the `TF_VAR_cloudflare_zone_id` environment variable. It imports records using addresses such as:

```sh
terraform import 'cloudflare_dns_record.this["a_apex"]' "$TF_VAR_cloudflare_zone_id/<dns-record-id>"
```

Use the keys in `local.dns_records` in `records.tf`; the complete list can be printed with:

```sh
terraform console
> keys(local.dns_records)
```

A record ID can be found with the Cloudflare API, for example:

```sh
curl --fail-with-body \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  "https://api.cloudflare.com/client/v4/zones/$TF_VAR_cloudflare_zone_id/dns_records?per_page=100"
```

After importing the zone and all existing records, run `terraform plan` and review any normalization differences before applying.

## Notes

- SOA and apex NS records from the export are omitted because Cloudflare manages them for the zone.
- TTL `1` is retained as Cloudflare's automatic TTL setting.
- Proxy settings are preserved from the export comments.
- Terraform state is stored remotely in the Terraform Enterprise workspace; the local `.terraform` directory remains ignored by git.
