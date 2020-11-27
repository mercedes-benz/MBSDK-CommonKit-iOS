//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

private let swizzling: (UIViewController.Type) -> Void = { viewController in
    
    let originalSelector = #selector(viewController.viewWillAppear(_:))
    let swizzledSelector = #selector(viewController.proj_viewWillAppear(animated:))
    
    let originalMethod = class_getInstanceMethod(viewController, originalSelector)
    let swizzledMethod = class_getInstanceMethod(viewController, swizzledSelector)
    
    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}


extension UIViewController {
	
    class func startSwizzle() {
		
        guard self === UIViewController.self else {
			return
		}
        swizzling(self)
    }
    
    
    @objc func proj_viewWillAppear(animated: Bool) {
		
        self.proj_viewWillAppear(animated: animated)
        let controllerName = self.string(fromClass: type(of: self))
        MBLogger.shared.U("VC APPEARED -> " + controllerName)
    }
    
    
    private func string(fromClass origClass: AnyClass) -> String {
        
        let nameSpaceClassName = NSStringFromClass(origClass)
        let className = nameSpaceClassName.components(separatedBy: ".").last! as String
        return className
    }
}

public extension DispatchQueue {
    
    static func defaultLoggingQueue() -> DispatchQueue {
        
        /// Serial utility queue for logging
        /// Reason for target param, see `DispatchQueue`documentation:  "Avoiding Excessive Thread Creation"
        return DispatchQueue(label: "defaultSDKLoggingQueue",
                             qos: .utility,
                             target: .global())
    }
}
