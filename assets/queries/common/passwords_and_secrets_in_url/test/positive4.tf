data "http" "example" {
  url = "http://bob:sekret@example.invalid/some/path"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

data "http" "example_2" {
  url = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

data "http" "example_3" {
  url = "https://team_name.webhook.office.com/webhookb2/7aa49aa6-7840-443d-806c-08ebe8f59966@c662313f-14fc-43a2-9a7a-d2e27f4f3478/IncomingWebhook/8592f62b50cf41b9b93ba0c0a00a0b88/eff4cd58-1bb8-4899-94de-795f656b4a18"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}
