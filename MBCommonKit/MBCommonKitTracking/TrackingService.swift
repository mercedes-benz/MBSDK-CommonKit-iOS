//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public protocol TrackingService {
	
	func startSession()
    func track(event: TrackingEvent)
	func cancelSession()
}
