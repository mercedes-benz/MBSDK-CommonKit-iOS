//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public protocol TrackingEvent {
    var name: String { get }
    var parameters: [String: String] { get }
}
