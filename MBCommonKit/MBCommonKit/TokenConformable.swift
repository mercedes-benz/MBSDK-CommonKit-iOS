//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Protocol to make a token conformable
public protocol TokenConformable {
    var accessToken: String { get }
    var tokenType: TokenType { get }
    var expirationDate: Date { get }
}

public enum TokenType: String, Codable {
    case ciam
    case keycloak = "Bearer"
}
