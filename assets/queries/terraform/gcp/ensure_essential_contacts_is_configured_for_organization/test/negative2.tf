data "google_organization" "org" {
  organization = "123456789012"
}

resource "google_essential_contacts_contact" "negative2" {
  parent = data.google_organization.org.name
  email  = "foo@bar.com"
  language_tag = "en-GB"

  notification_category_subscriptions = ["ALL"]
}
