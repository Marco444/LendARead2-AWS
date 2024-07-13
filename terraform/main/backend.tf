terraform {
  backend "s3" {
    bucket         = "bucket-wholly-optionally-shortly-thankful-barnacle"
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dynamo"
  }
}
