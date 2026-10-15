# Negative Case 2: Correct configuration on a standalone node pool
resource "google_container_node_pool" "pass_pool" {
  name    = "secure-untrusted-pool"
  cluster = "my-cluster"

  node_config {
    image_type = "COS_CONTAINERD"
    sandbox_config {
      sandbox_type = "gvisor"
    }
  }
}