//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Quick
import Nimble
import Foundation
@testable import MBCommonKit

class MBCommonKitTests: QuickSpec {

    override func spec() {
        context("String extension") {
            describe("when string already has Bearer prefix") {
                it("should correctly prefix the string with Bearer ") {
                    let tokenString = "Bearer asdasd...asdasd"
                    let expectedTokenString = "Bearer asdasd...asdasd"
                    
                    expect(tokenString.addBearerAuthHeaderPrefix()).to(equal(expectedTokenString))
                }
            }
            
            describe("when string does not have a bearer prefix yet") {
                it("should not prefix the string with Bearer again") {
                    let tokenString = "asdasd...asdasd"
                    let expectedTokenString = "Bearer asdasd...asdasd"
                    
                    expect(tokenString.addBearerAuthHeaderPrefix()).to(equal(expectedTokenString))
                }
            }
            
            describe("When Bearer prefix is wrongly formatted") {
                it("there is no automatic correction happening but it just adds another prefix") {
                    let tokenString = "Bearerasdasd...asdasd"
                    let expectedTokenString = "Bearer Bearerasdasd...asdasd"
                    
                    expect(tokenString.addBearerAuthHeaderPrefix()).to(equal(expectedTokenString))
                }
            }
        }
    }
    
}
