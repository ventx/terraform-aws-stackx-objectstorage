module "stackx-bucket" {
  source = "../"

  static_unique_id = "f2f6c971-6a3c-4d6e-9dca-7a3ba454d64d" # just random uuid generated for testing cut offs etc

  tags = {
    examples = "example"
  }
}
