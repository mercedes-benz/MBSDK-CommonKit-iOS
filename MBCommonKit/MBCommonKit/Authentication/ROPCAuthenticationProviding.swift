//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

/// Authentication configuration for RiS Keycloak
public protocol ROPCAuthenticationProviding: AuthenticationProviding {
    /// client identifier for keycloak
    var clientId: String { get }

    /// default header parameters
    var headerParamProvider: HeaderParamProviding { get }
    
    /// stage name for keycloak
    var stageName: String { get }
    
    /// string-based base url for keycloak
    var urlProvider: UrlProviding { get }
    
    /// oauth scopes in a space separated list, e.g. "openid offline_access"
    ///
    /// - SeeAlso: https://oauth.net/2/scope/
    var scopes: String { get }
}
