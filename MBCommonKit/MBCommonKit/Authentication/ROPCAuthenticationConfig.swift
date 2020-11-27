//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

public struct ROPCAuthenticationConfig: AuthenticationConfig {
    
    public let type: AuthenticationType
    public let clientId: String
    
    public init(clientId: String, type: AuthenticationType) {
        self.clientId = clientId
        self.type = type
    }
}
