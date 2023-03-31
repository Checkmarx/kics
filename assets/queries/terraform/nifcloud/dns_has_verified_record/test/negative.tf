resource "nifcloud_dns_record" "negative" {
  zone_id = nifcloud_dns_zone.example.id
  name    = "test.example.test"
  type    = "TXT"
  ttl     = 300
  record  = "negative"
}
