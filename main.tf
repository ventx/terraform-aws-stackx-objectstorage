# Tagging
locals {
  tags = merge(
    var.tags,
    {
      "Module" = "terraform-aws-stackx-objectstorage"
      "Github" = "https://github.com/ventx/terraform-aws-stackx-objectstorage"
    }
  )
}


# --------------------------------------------------------------------------
# S3 Bucket
# --------------------------------------------------------------------------
# Without Replication
#tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "bucket" { #tfsec:ignore:AWS002
  #bucket        = substr(lower(trimspace("${var.cluster_name}-${var.name}")), 0, 62) // expected length of bucket to be in the range (0 - 63)
  bucket        = trimsuffix(replace(substr(lower("${var.name}${var.static_unique_id != "" ? "-" : ""}${var.static_unique_id != "" ? var.static_unique_id : ""}"), 0, 62), "_", "-"), "-")
  force_destroy = var.force_destroy

  tags = local.tags
}


# --------------------------------------------------------------------------
# Public Access Block
# --------------------------------------------------------------------------
# Manages S3 bucket-level Public Access Block configuration.
# https://docs.aws.amazon.com/AmazonS3/latest/dev/access-control-block-public-access.html
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-encryption.html
# https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#enable-default-server-side-encryption
#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_logging" "bucket" {
  count = var.target_bucket != "" ? 1 : 0

  bucket        = aws_s3_bucket.bucket.id
  target_bucket = var.target_bucket
  target_prefix = var.target_prefix == "" ? "${var.name}/" : var.target_prefix
}

#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_policy" "bucket" {
  count = var.bucket_policy == "" ? 0 : 1


  bucket = aws_s3_bucket.bucket.id
  policy = var.bucket_policy
}


resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  # Current object version (only object version when versioning is disabled)
  ## Enable / Disable lifecycle to another storage class (e.g. for cost-optimization)
  rule {
    id = "Current Version: Soft"

    filter {
      and {
        prefix = var.current_soft_prefix
      }
    }

    status = var.current_soft_rule_enabled ? "Enabled" : "Disabled"

    transition {
      days          = var.current_soft_transition_days
      storage_class = var.current_soft_transition_storage_class
    }
  }


  ## Enable / Disable lifecycle to another (second) storage class (e.g. for archiving)
  rule {
    id = "Current Version: Hard"

    filter {
      and {
        prefix = var.current_hard_prefix
      }
    }

    status = var.current_hard_rule_enabled ? "Enabled" : "Disabled"

    transition {
      days          = var.current_hard_transition_days
      storage_class = var.current_hard_transition_storage_class
    }
  }


  ## Enable / Disable expiration of current objects
  rule {
    id = "Current Version: Expiration / Deletion"

    filter {
      and {
        prefix = var.current_expiration_prefix
      }
    }

    status = var.current_expiration_enabled ? "Enabled" : "Disabled"

    expiration {
      days = var.current_expiration_days
    }
  }

  ## Enable / Disable lifecycle to another storage class (e.g. for cost-optimization)
  rule {
    id = "Noncurrent Versions: Soft"

    filter {
      and {
        prefix = var.noncurrent_soft_prefix
      }
    }

    status = var.noncurrent_soft_rule_enabled ? "Enabled" : "Disabled"

    noncurrent_version_transition {
      noncurrent_days = var.noncurrent_soft_transition_days
      storage_class   = var.noncurrent_soft_transition_storage_class
    }
  }


  ## Enable / Disable lifecycle to another (second) storage class (e.g. for archiving)
  rule {
    id = "Noncurrent Versions: Hard"

    filter {
      and {
        prefix = var.noncurrent_hard_prefix
      }
    }

    status = var.noncurrent_hard_rule_enabled ? "Enabled" : "Disabled"

    noncurrent_version_transition {
      noncurrent_days = var.noncurrent_hard_transition_days
      storage_class   = var.noncurrent_hard_transition_storage_class
    }
  }

  ## Enable / Disable expiration of noncurrent objects
  rule {
    id = "Noncurrent Versions: Expiration / Deletion"

    filter {
      and {
        prefix = var.noncurrent_expiration_prefix
      }
    }

    status = var.noncurrent_expiration_enabled ? "Enabled" : "Disabled"

    expiration {
      days = var.noncurrent_expiration_days
    }
  }
}
