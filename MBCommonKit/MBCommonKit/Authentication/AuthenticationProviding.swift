//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

/// The currently supported authentication types
public enum AuthenticationType: String, Codable {
    case ciam = "CIAMNG"
    case keycloak = "KEYCLOAK"
}

/// Common protocol for all authentication configurations
public protocol AuthenticationProviding {
    var type: AuthenticationType { get }
}
