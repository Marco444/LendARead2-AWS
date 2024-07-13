<<<<<<< HEAD
resource "random_pet" "bucket_suffix" {
  length    = 3
  separator = "-"
}

=======
>>>>>>> 467a75c22045879425b0622f665bbf5787daf83a

resource "aws_s3_bucket" "spa_bucket" {
  bucket = "${var.bucket_name}-${random_pet.bucket_suffix.id}"
}

resource "aws_s3_bucket_public_access_block" "spa_bucket" {
  bucket = aws_s3_bucket.spa_bucket.id

<<<<<<< HEAD
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
=======
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
>>>>>>> 467a75c22045879425b0622f665bbf5787daf83a
}

resource "aws_s3_bucket_website_configuration" "spa_bucket" {
  bucket = aws_s3_bucket.spa_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "spa_bucket" {
<<<<<<< HEAD
  bucket = aws_s3_bucket.spa_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "spa_bucket" {
  bucket = aws_s3_bucket.spa_bucket.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.spa_bucket,
    aws_s3_bucket_public_access_block.spa_bucket
  ]
}

# resource "aws_s3_bucket_policy" "spa_bucket_policy" {
#   bucket = aws_s3_bucket.spa_bucket.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "AllowCloudFrontAccessOnly"
#         Effect    = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.cloudfront_origin_access_identity_id}"
#         }
#         Action    = "s3:GetObject"
#         Resource  = "${aws_s3_bucket.spa_bucket.arn}/*"
#       }
#     ]
#   })
# }

resource "null_resource" "spa_bucket_deploy" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<-EOF
      export VITE_APP_BASE_PATH='/'
      export VITE_API_BASE_URL='http://${var.alb}:8080'
      cd ../../LendARead2/frontend
      npm install

      npm run build

      aws s3 sync dist/ "s3://${aws_s3_bucket.spa_bucket.bucket}" --delete --region ${var.region}
    EOF
  }


  depends_on = [
    aws_s3_bucket.spa_bucket,
    aws_s3_bucket_acl.spa_bucket,
    aws_s3_bucket_policy.spa_bucket_policy
  ]
}

resource "aws_s3_bucket_policy" "spa_bucket_policy" {
=======
>>>>>>> 467a75c22045879425b0622f665bbf5787daf83a
  bucket = aws_s3_bucket.spa_bucket.id
  rule {
  object_ownership = "BucketOwnerPreferred"
  }
}

<<<<<<< HEAD
=======
resource "aws_s3_bucket_acl" "spa_bucket" {
  bucket = aws_s3_bucket.spa_bucket.id
  acl = "public-read"
  depends_on = [
  aws_s3_bucket_ownership_controls.spa_bucket,
  aws_s3_bucket_public_access_block.spa_bucket
  ]
}



resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.spa_bucket.id
  policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
    Sid       = "PublicReadGetObject"
    Effect    = "Allow"
    Principal = "*"
    Action    = "s3:GetObject"
    Resource = [
      aws_s3_bucket.spa_bucket.arn,
      "${aws_s3_bucket.spa_bucket.arn}/*",
    ]
    },
  ]
  })
  depends_on = [
  aws_s3_bucket_public_access_block.spa_bucket
  ]
}



resource "null_resource" "spa_bucket" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOF
      set -e
      echo "Setting environment variables"
      export VITE_APP_BASE_PATH='/'
      export VITE_API_BASE_URL='http://${var.alb}:8080'
      
      echo "Listing contents of the cloned repository"
      
      echo "Navigating to frontend directory"
      cd ../../LendARead2/frontend
      
      echo "Installing dependencies"
      npm install
      
      echo "Building the SPA"
      npm run build
      
      echo "Syncing build output to S3"
      aws s3 sync dist/ s3://${aws_s3_bucket.spa_bucket.bucket} --delete --region ${var.region}

    EOF
  }

  depends_on = [
    aws_s3_bucket.spa_bucket
  ]
}
>>>>>>> 467a75c22045879425b0622f665bbf5787daf83a
