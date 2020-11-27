//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public extension String {
    private static let bearerPrefix: String = "Bearer "
    
    func addBearerAuthHeaderPrefix() -> String {
        
        guard !self.hasPrefix(Self.bearerPrefix) else {
            return self
        }
        
        return Self.bearerPrefix + self
    }
}
