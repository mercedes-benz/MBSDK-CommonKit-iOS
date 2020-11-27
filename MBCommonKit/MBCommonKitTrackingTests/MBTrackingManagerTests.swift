//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//
	

import Quick
import Nimble
@testable import MBCommonKitTracking

class MBTrackingManagerTests: QuickSpec {

    override func spec() {
        
        var service1: MockTrackingService!
        var service2: MockTrackingService!
        var service3: MockTrackingService!
        
        var subject: MBTrackingManager!
        
        beforeEach {
            subject = MBTrackingManager()
            service1 = MockTrackingService()
            service2 = MockTrackingService()
            service3 = MockTrackingService()
        }
        
        describe("hasRegisteredServices") {
            it("should return false if no service has been registered") {
                expect(subject.hasRegisteredServices).to(beFalse())
            }
            
            it("should return true if at least one service has been registered") {
                expect(subject.hasRegisteredServices).to(beFalse())
                
                subject.register(service: service1)
                
                expect(subject.hasRegisteredServices).to(beTrue())
                
                subject.register(service: service2)
                
                expect(subject.hasRegisteredServices).to(beTrue())
                
                subject.register(service: service3)
                
                expect(subject.hasRegisteredServices).to(beTrue())
            }
        }
        
        describe("when startSession is called") {
            it("should startSession of all registered Services") {
                
                subject.register(service: service1)
                subject.register(service: service2)
                
                subject.startSession()
                
                subject.register(service: service3)
                
                expect(service1.hasStartSessionBeenCalled).to(beTrue())
                expect(service2.hasStartSessionBeenCalled).to(beTrue())
                expect(service3.hasStartSessionBeenCalled).to(beFalse())
                
                expect(service1.isSessionStarted).to(beTrue())
                expect(service2.isSessionStarted).to(beTrue())
                expect(service3.isSessionStarted).to(beFalse())
                
                expect(service1.hasCancelSessionBeenCalled).to(beFalse())
                expect(service2.hasCancelSessionBeenCalled).to(beFalse())
                expect(service3.hasCancelSessionBeenCalled).to(beFalse())
            }
        }
        
        
        describe("when cancelSession is called") {
            it("should cancelSession of all registered Services") {
                
                subject.register(service: service1)
                subject.register(service: service2)
                
                subject.startSession()
                
                subject.register(service: service3)
                
                expect(service1.hasStartSessionBeenCalled).to(beTrue())
                expect(service2.hasStartSessionBeenCalled).to(beTrue())
                expect(service3.hasStartSessionBeenCalled).to(beFalse())
                
                subject.cancelSession()
                
                expect(service1.hasCancelSessionBeenCalled).to(beTrue())
                expect(service2.hasCancelSessionBeenCalled).to(beTrue())
                expect(service3.hasCancelSessionBeenCalled).to(beTrue())
                
                expect(service1.isSessionStarted).to(beFalse())
                expect(service2.isSessionStarted).to(beFalse())
                expect(service3.isSessionStarted).to(beFalse())
            }
        }
        
        describe("when an event is being tracked") {
            
            beforeEach {
                subject.register(service: service1)
                subject.register(service: service2)
                
                subject.startSession()
                
                subject.register(service: service3)
            }
            
            it("should appear at each tracking service if tracking is enabled") {
                for service in [service1, service2, service3] {
                    guard let service = service else {
                        XCTFail()
                        return
                    }
                    
                    expect(service.trackedEvents.count) == 0
                }
                
                subject.isTrackingEnabled = true
                
                subject.track(event: TestEvent.testEvent)
                
                for service in [service1, service2, service3] {
                    guard let service = service else {
                        XCTFail()
                        return
                    }
                    
                    expect(service.trackedEvents.count) == 1
                    expect(service.trackedEvents.first?.name) == "TestEvent"
                    expect(service.trackedEvents.first?.parameters) == [:]
                }
            }
            
            it("should not appear at no tracking service if tracking is disabled") {
                for service in [service1, service2, service3] {
                    guard let service = service else {
                        XCTFail()
                        return
                    }
                    
                    expect(service.trackedEvents.count) == 0
                }
                
                subject.isTrackingEnabled = false
                
                subject.track(event: TestEvent.testEvent)
                
                for service in [service1, service2, service3] {
                    guard let service = service else {
                        XCTFail()
                        return
                    }
                    
                    expect(service.trackedEvents.count) == 0
                }
            }
            
            it("should appear at each tracking service as tracking is enabled by default") {
                for service in [service1, service2, service3] {
                    guard let service = service else {
                        XCTFail()
                        return
                    }
                    
                    expect(service.trackedEvents.count) == 0
                }
                
                subject.track(event: TestEvent.testEvent)
                
                for service in [service1, service2, service3] {
                    guard let service = service else {
                        XCTFail()
                        return
                    }
                    
                    expect(service.trackedEvents.count) == 1
                    expect(service.trackedEvents.first?.name) == "TestEvent"
                    expect(service.trackedEvents.first?.parameters) == [:]
                }
            }
            
            it("should appear at each tracking service twice if it is being tracked twice") {
                for service in [service1, service2, service3] {
                    guard let service = service else {
                        XCTFail()
                        return
                    }
                    
                    expect(service.trackedEvents.count) == 0
                }
                
                subject.track(event: TestEvent.testEvent)
                
                for service in [service1, service2, service3] {
                    guard let service = service else {
                        XCTFail()
                        return
                    }
                    
                    expect(service.trackedEvents.count) == 1
                    expect(service.trackedEvents.first?.name) == "TestEvent"
                    expect(service.trackedEvents.first?.parameters) == [:]
                }
                
                subject.track(event: TestEvent.testEvent)
                
                for service in [service1, service2, service3] {
                    guard let service = service else {
                        XCTFail()
                        return
                    }
                    
                    expect(service.trackedEvents.count) == 2
                    expect(service.trackedEvents.first?.name) == "TestEvent"
                    expect(service.trackedEvents.first?.parameters) == [:]
                    expect(service.trackedEvents.last?.name) == "TestEvent"
                    expect(service.trackedEvents.last?.parameters) == [:]
                }
            }
        }
    }

}

class MockTrackingService: TrackingService {
    
    var hasStartSessionBeenCalled: Bool = false
    var hasCancelSessionBeenCalled: Bool = false
    var isSessionStarted: Bool = false
    
    var trackedEvents: [TrackingEvent] = []
    
    func startSession() {
        hasStartSessionBeenCalled = true
        isSessionStarted = true
    }
    
    func track(event: TrackingEvent) {
        trackedEvents.append(event)
    }
    
    func cancelSession() {
        isSessionStarted = false
        hasCancelSessionBeenCalled = true
    }
}

enum TestEvent: TrackingEvent {
    var name: String {
        return "TestEvent"
    }
    var parameters: [String : String] {
        return [:]
    }
    
    case testEvent
}
