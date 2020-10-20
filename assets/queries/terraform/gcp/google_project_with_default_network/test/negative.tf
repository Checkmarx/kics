// comment
resource "google_project" "my_project-in-a-folder" {
  name       = "My Project"
  project_id = "your-project-id"
  folder_id  = google_folder.department1.name
  auto_create_network = false
}

resource "google_folder" "department1" {
  display_name = "Department 1"
  parent       = "organizations/1234567"
}