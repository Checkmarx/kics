resource "google_pubsub_topic_iam_binding" "binding" {
  project = google_pubsub_topic.example.project
  topic = google_pubsub_topic.example1.name
  role = "roles/viewer"
  members = [
    "user:jane@example.com",
  ]
}

resource "google_pubsub_topic_iam_member" "member" {
  project = google_pubsub_topic.example.project
  topic = google_pubsub_topic.example2.name
  role = "roles/viewer"
  member = "user:jane@example.com"
}

resource "google_pubsub_topic_iam_binding" "binding_public" {
  project = google_pubsub_topic.example.project
  topic = google_pubsub_topic.example3.name
  role = "roles/pubsub.publisher"
  members = [
    "allUsers",
    "allAuthenticatedUsers"
  ]
}

resource "google_pubsub_topic_iam_member" "member_public" {
  project = google_pubsub_topic.example.project
  topic = google_pubsub_topic.example4.name
  role = "roles/pubsub.publisher"
  member = "allUsers"
}

resource "google_pubsub_topic" "example1" {
  name         = "example-topic"
  kms_key_name = google_kms_crypto_key.crypto_key.id
}

resource "google_pubsub_topic" "example2" {
  name         = "example-topic"
  kms_key_name = google_kms_crypto_key.crypto_key.id
}

resource "google_pubsub_topic" "example3" {
  name = "example-topic"

  labels = {
    foo = "bar"
  }

  message_retention_duration = "86600s"
}

resource "google_pubsub_topic" "example4" {
  name = "example-topic"

  labels = {
    foo = "bar"
  }

  message_retention_duration = "86600s"
}
