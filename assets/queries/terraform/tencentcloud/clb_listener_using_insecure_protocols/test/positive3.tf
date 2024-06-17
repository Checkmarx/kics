resource "tencentcloud_clb_listener" "listener" {
  clb_id        = "lb-0lh5au7v"
  listener_name = "test_listener"
  protocol      = "UDP"
  port          = 8090
}
