variable "name" {
  description = "Base Name for all resources (preferably generated by terraform-null-label)"
  type        = string
  default     = "stackx-bucket"
}

variable "tags" {
  description = "User specific Tags / Labels to attach to resources (will be merged with module tags)"
  type        = map(string)
  default     = {}
}

variable "static_unique_id" {
  description = "Static unique ID, defined in the root module once, to be suffixed to all resources for uniqueness (if you choose uuid / longer id, some resources will be cut of at max length - empty means disable and NOT add unique suffix)"
  type        = string
  default     = ""
}

variable "bucket_acl" {
  description = "The canned ACL to apply. We recommend `private` to avoid exposing sensitive information"
  type        = string
  default     = "private"
}

variable "bucket_policy" {
  description = "A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy"
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "A boolean string that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket"
  type        = bool
  default     = true
}

# variable logging_bucket {
#   description = "S3 Bucket for central access logging"
#   type        = string
# }

variable "sse_algorithm" {
  description = "The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`"
  type        = string
  default     = "AES256"
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
  default     = true
}


# Object lifecycle rule variables
## Current objects
## (when versioning enabled: most-recent version - when versioning disabled: the only version available)
variable "current_soft_rule_enabled" {
  description = "Enable or disable the soft lifecycle rule"
  type        = bool
  default     = false
}

variable "current_soft_prefix" {
  description = "Prefix identifying one or more objects to which the soft rule applies (e.g. '*' applies to all )"
  type        = string
  default     = ""
}

variable "current_soft_transition_days" {
  description = "Number of days to persist in the standard storage tier before moving to another (e.g. IA) tier (e.g. '90' => 90d => 3m)"
  type        = number
  default     = 90
}

variable "current_soft_transition_storage_class" {
  description = "Storage Class to move objects after noncurrent_version_soft_transition_days (e.g. 'GLACIER', 'STANDARD_IA')"
  type        = string
  default     = "STANDARD_IA"
}

variable "current_hard_rule_enabled" {
  description = "Enable or disable the hard lifecycle rule"
  type        = bool
  default     = false
}

variable "current_hard_prefix" {
  description = "Prefix identifying one or more objects to which the hard rule applies"
  type        = string
  default     = ""
}

variable "current_hard_transition_days" {
  description = "Number of days to persist in the standard storage tier before moving to another (e.g. Glacier) tier (e.g. '180' => 180d => 6m)"
  type        = number
  default     = 180
}

variable "current_hard_transition_storage_class" {
  description = "Storage Class to move objects after noncurrent_version_hard_transition_days (e.g. 'GLACIER', 'STANDARD_IA')"
  type        = string
  default     = "GLACIER"
}

variable "current_expiration_enabled" {
  description = "Enable or disable the expiration (deletion) lifecycle rule"
  type        = bool
  default     = false
}

variable "current_expiration_prefix" {
  description = "Prefix identifying one or more objects to which the expiration rule applies"
  type        = string
  default     = ""
}

variable "current_expiration_days" {
  description = "Specifies when noncurrent object versions expire (e.g. '365' => 365d => 1y)"
  type        = number
  default     = 365
}

## Noncurrent objections
## (when versioning enabled, older versions and not the most-recent version)
variable "noncurrent_soft_rule_enabled" {
  description = "Noncurrent versions: Enable or disable the soft lifecycle rule"
  type        = bool
  default     = false
}

variable "noncurrent_soft_prefix" {
  description = "Noncurrent versions: Prefix identifying one or more objects to which the soft rule applies"
  type        = string
  default     = ""
}

variable "noncurrent_soft_transition_days" {
  description = "Noncurrent versions: Number of days to persist in the standard storage tier before moving to another (e.g. IA) tier (e.g. '90' => 90d => 3m)"
  type        = number
  default     = 90
}

variable "noncurrent_soft_transition_storage_class" {
  description = "Noncurrent versions: Storage Class to move objects after noncurrent_version_soft_transition_days (e.g. 'GLACIER', 'STANDARD_IA')"
  type        = string
  default     = "STANDARD_IA"
}

variable "noncurrent_hard_rule_enabled" {
  description = "Noncurrent versions: Enable or disable the hard lifecycle rule"
  type        = bool
  default     = false
}

variable "noncurrent_hard_prefix" {
  description = "Noncurrent versions: Prefix identifying one or more objects to which the hard rule applies"
  type        = string
  default     = ""
}

variable "noncurrent_hard_transition_days" {
  description = "Noncurrent versions: Number of days to persist in the standard storage tier before moving to another (e.g. Glacier) tier (e.g. '180' => 180d => 6m)"
  type        = number
  default     = 180
}

variable "noncurrent_hard_transition_storage_class" {
  description = "Noncurrent versions: Storage Class to move objects after noncurrent_version_hard_transition_days (e.g. 'GLACIER', 'STANDARD_IA')"
  type        = string
  default     = "GLACIER"
}

variable "noncurrent_expiration_enabled" {
  description = "Noncurrent versions: Enable or disable the expiration (deletion) lifecycle rule"
  type        = bool
  default     = false
}

variable "noncurrent_expiration_prefix" {
  description = "Noncurrent versions: Prefix identifying one or more objects to which the expiration rule applies"
  type        = string
  default     = ""
}

variable "noncurrent_expiration_days" {
  description = "Noncurrent versions: Specifies when noncurrent object versions expire (e.g. '365' => 365d => 1y)"
  type        = number
  default     = 365
}

variable "target_bucket" {
  description = "Bucket to use for bucket logging as the target to send logs to"
  type        = string
  default     = ""
}

variable "target_prefix" {
  description = "Bucket Logging prefix to use - if empty it will be set to `var.name/` (name of the bucket)"
  type        = string
  default     = ""
}
