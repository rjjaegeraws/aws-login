variable keycloak_saml_name{
    description = "Keycloak IDP Name"
    default     = "BCGovKeyCloak"
}

variable master_account_id {
    description = "Master AWS Account Id"
    
}

variable keycloak_referer_url {
    description = "Keycloak referer url. Example: https://mykeycloakurl:8443/auth/realms/Aws/protocol/saml/clients/amazon-aws"
    
}