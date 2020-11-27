//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public protocol TrackingManager {
    
    /// Disabling this will prevent Tracking Events to be sent to registered TrackingServices
    var isTrackingEnabled: Bool { get set }
    
    /// Returns true if at least one tracking service has been previously registered
    var hasRegisteredServices: Bool { get }
    
    /// Registers a TrackingService for receiving TrackingEvents in the fitire
    func register(service: TrackingService)
    
    /// Starts a TrackingSession for every registered service
    func startSession()
    
    /// Dispatch a track event to all registered services
    func track(event: TrackingEvent)
    
    /// Cancels the previously started TrackingSession for every registered service
    func cancelSession()
}

public class MBTrackingManager: TrackingManager {
    
    public static let shared = MBTrackingManager()
	
	// MARK: - Properties
    
	public var isTrackingEnabled = true
    
    public var hasRegisteredServices: Bool {
        return self.services.isEmpty == false
    }
    
	private var services = [TrackingService]()
	
	// MARK: - Functions
    
	public func register(service: TrackingService) {
		self.services.append(service)
	}
	
	public func startSession() {
		
		self.services.forEach { (service) in
			service.startSession()
		}
	}
	
	public func cancelSession() {
		
		self.services.forEach { (service) in
			service.cancelSession()
		}
	}
	
	public func track(event: TrackingEvent) {
		
		guard self.isTrackingEnabled else {
			return
		}
		
		self.services.forEach { (service) in
            service.track(event: event)
		}
	}
}
