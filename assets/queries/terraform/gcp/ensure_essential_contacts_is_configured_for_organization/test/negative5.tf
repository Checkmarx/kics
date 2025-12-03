resource "google_essential_contacts_contact" "negative5" {
  parent = "folders/987654321"       # Not organization-level
  email  = "foo@bar.com"
  language_tag = "en-GB"

  notification_category_subscriptions = ["ALL"]
}