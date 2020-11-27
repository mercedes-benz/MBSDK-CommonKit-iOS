//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

extension Notification.Name {
    
    static let loggerDidShake = Notification.Name("LoggerDidShake")
}


extension UIWindow {
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            NotificationCenter.default.post(Notification(name: Notification.Name.loggerDidShake))
        }
    }
}
