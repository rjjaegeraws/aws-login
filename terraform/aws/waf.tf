resource "aws_wafv2_web_acl" "saml_waf" {
  name        = "KeycloakAPIGatewayRefererCheck"
  description = "Checks the referer is from keycloak or the api gateway"
  scope       = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "check-referers"
    priority = 1

    action {
      allow {}
    }

    statement {
        or_statement {
          statement {
            byte_match_statement {
                field_to_match {
                    single_header {
                        name = "referer"
                    }
                }
                positional_constraint = "EXACTLY"
                search_string = aws_api_gateway_stage.samlpost.invoke_url
                text_transformation {
                  priority = 0
                  type = "NONE"
                }
            } 
          }

          statement {
            byte_match_statement {
                field_to_match {
                    single_header {
                        name = "referer"
                    }
                }
                positional_constraint = "STARTS_WITH"
                search_string = var.keycloak_referer_url
                text_transformation {
                  priority = 0
                  type = "NONE"
                }
            }
          }
        }  
    }
    

    visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "referer-saml-waf"
        sampled_requests_enabled   = true
    }
      
  }

   visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "saml-waf"
    sampled_requests_enabled   = true
  }

  tags = local.common_tags
}



resource "aws_wafv2_web_acl_association" "saml_waf" {
  resource_arn = aws_api_gateway_stage.samlpost.arn
  web_acl_arn  = aws_wafv2_web_acl.saml_waf.arn
}