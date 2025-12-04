resource "google_essential_contacts_contact" "positive4" {
  parent = "organizations/123456789012"
  email  = "foo@bar.com"
  language_tag = "en-GB"

  notification_category_subscriptions = [
    "BILLING", 
    "PRODUCT_UPDATES",
  ]
}
