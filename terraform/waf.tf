# resource "aws_wafv2_web_acl" "cert-conv" {
#   name        = "cert-conv-wafv2"
#   description = "WAFv2 for cert-conv"
#   scope       = "REGIONAL"

#   default_action {
#     allow {}
#   }

#   rule {
#     name     = "AWSManagedRulesCommonRuleSet"
#     priority = 0

#     override_action {
#       none {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = false
#       metric_name                = "AWSManagedRulesCommonRuleSet"
#       sampled_requests_enabled   = false
#     }
#   }

#   rule {
#     name     = "RateLimit"
#     priority = 10

#     action {
#       block {}
#     }

#     statement {
#       rate_based_statement {
#         limit              = 100
#         aggregate_key_type = "IP"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = false
#       metric_name                = "RateLimit"
#       sampled_requests_enabled   = false
#     }
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = false
#     metric_name                = "cert-conv-metric-name"
#     sampled_requests_enabled   = false
#   }
# }

# resource "aws_wafv2_web_acl_association" "waf_alb_association" {
#   resource_arn = aws_lb.my_lb.arn
#   web_acl_arn  = aws_wafv2_web_acl.cert-conv.arn

#   depends_on = [
#     aws_lb.my_lb
#   ]
# }