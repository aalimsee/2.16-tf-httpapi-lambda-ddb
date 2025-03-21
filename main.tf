data "aws_caller_identity" "current" {}

# --- replace underscore with dash because of name convention in domain eg xxx_ce9.sctp-sandbox.com is not allow
locals {
  name_prefix = replace(split("/", "${data.aws_caller_identity.current.arn}")[1],"_","-")
  //name_prefix = "aalimsee-ce9"
}

