resource "google_essential_contacts_contact" "negative3" {
  parent = "organizations/123456789012"
  email = "foo@bar.com"
  language_tag = "en-GB"
  notification_category_subscriptions = [
    "LEGAL",
    "SECURITY",
    "SUSPENSION",
    "TECHNICAL"
  ]
}