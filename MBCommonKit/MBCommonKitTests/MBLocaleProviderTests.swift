//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

@testable import MBCommonKit

class MBLocaleProviderTests: QuickSpec {
    
    override func spec() {
        
        var localeProvider: MBLocaleProvider!
        var mockSystemLocaleProvider: MockSystemLocaleProviding!
        var mockCarrierLocaleProvider: MockCarrierLocaleProviding!
        
        beforeEach {
            mockSystemLocaleProvider = MockSystemLocaleProviding()
            mockCarrierLocaleProvider = MockCarrierLocaleProviding()
            
            localeProvider = MBLocaleProvider(systemLocaleProvider: mockSystemLocaleProvider,
                                              carrierLocaleProvider: mockCarrierLocaleProvider)
        }
        
        describe("locale") {
            it("should return a formatted locale for valid system locale") {
                expect(localeProvider.locale) == "it-CH"
            }
            
            it("should use region identifier fallback if needed") {
                mockSystemLocaleProvider.mockRegionCode = nil
                expect(localeProvider.locale) == "it-FR"
            }
            
            it("should use region carrier fallback if needed") {
                mockSystemLocaleProvider.mockRegionCode = nil
                mockSystemLocaleProvider.mockIdentifier = ""
                expect(localeProvider.locale) == "it-AT"
            }
            
            it("should use region carrier fallback if needed and language fallback") {
                mockSystemLocaleProvider.mockRegionCode = nil
                mockSystemLocaleProvider.mockIdentifier = ""
                mockSystemLocaleProvider.mockLanguageCode = nil
                expect(localeProvider.locale) == "en-AT"
            }
            
            it("should use language identifier fallback if needed") {
                mockSystemLocaleProvider.mockLanguageCode = nil
                expect(localeProvider.locale) == "fr-CH"
            }
            
            it("should use default fallbacks if needed") {
                mockSystemLocaleProvider.mockRegionCode = nil
                mockSystemLocaleProvider.mockLanguageCode = nil
                mockSystemLocaleProvider.mockIdentifier = ""
                mockCarrierLocaleProvider.mockRegionCode = nil
                expect(localeProvider.locale) == "en-GB"
            }
            
            it("should use country defaults if the locale only contains language") {
                mockSystemLocaleProvider.mockRegionCode = nil
                mockSystemLocaleProvider.mockLanguageCode = "en"
                mockSystemLocaleProvider.mockIdentifier = "en"
                expect(localeProvider.locale) == "en-AT"
            }
            
            it("should use defaults if the locale contains a number") {
                mockSystemLocaleProvider.mockRegionCode = nil
                mockSystemLocaleProvider.mockLanguageCode = "en"
                mockSystemLocaleProvider.mockIdentifier = "en_150"
                expect(localeProvider.locale) == "en-AT"
            }

        }
        
        describe("languageCode") {
            it("should use language identifier fallback if needed") {
                mockSystemLocaleProvider.mockLanguageCode = nil
                expect(localeProvider.languageCode) == "fr"
            }
            
            it("should use the correct language code for three comp identifiers") {
                mockSystemLocaleProvider.mockLanguageCode = nil
                mockSystemLocaleProvider.mockIdentifier = "zh_Hant_HK"
                expect(localeProvider.languageCode) == "zh"
            }
            
            it("should use language default fallback if needed") {
                mockSystemLocaleProvider.mockLanguageCode = nil
                mockSystemLocaleProvider.mockIdentifier = ""
                expect(localeProvider.languageCode) == "en"
            }
        }
        
        describe("regionCode") {
            it("should use region identifier fallback if needed") {
                mockSystemLocaleProvider.mockRegionCode = nil
                expect(localeProvider.regionCode) == "FR"
            }
            
            it("should use the correct region code for three comp identifiers") {
                mockSystemLocaleProvider.mockRegionCode = nil
                mockSystemLocaleProvider.mockIdentifier = "zh_Hant_HK"
                expect(localeProvider.regionCode) == "HK"
            }
            
            it("should not use the region code for three comp identifiers that miss the region") {
                mockSystemLocaleProvider.mockRegionCode = nil
                mockSystemLocaleProvider.mockIdentifier = "zh_Hant"
                mockCarrierLocaleProvider.mockRegionCode = nil
                expect(localeProvider.regionCode) == "GB"
            }
            
            it("should use carrier fallback if needed") {
                mockSystemLocaleProvider.mockRegionCode = nil
                mockSystemLocaleProvider.mockIdentifier = ""
                expect(localeProvider.regionCode) == "AT"
            }
            
            it("should use region default fallback if needed") {
                mockSystemLocaleProvider.mockRegionCode = nil
                mockSystemLocaleProvider.mockIdentifier = ""
                mockCarrierLocaleProvider.mockRegionCode = nil
                expect(localeProvider.regionCode) == "GB"
            }
            
            it("should not use regions that are numberic") {
                mockSystemLocaleProvider.mockRegionCode = "150"
                mockSystemLocaleProvider.mockIdentifier = ""
                mockCarrierLocaleProvider.mockRegionCode = nil
                expect(localeProvider.regionCode) == "GB"
            }
            
            it("should not use regions that are empty") {
                mockSystemLocaleProvider.mockRegionCode = ""
                mockSystemLocaleProvider.mockIdentifier = ""
                mockCarrierLocaleProvider.mockRegionCode = nil
                expect(localeProvider.regionCode) == "GB"
            }
            
            it("should not use regions that are not upper cased") {
                mockSystemLocaleProvider.mockRegionCode = "us"
                mockSystemLocaleProvider.mockIdentifier = ""
                mockCarrierLocaleProvider.mockRegionCode = nil
                expect(localeProvider.regionCode) == "GB"
            }
            
            it("should not use country codes that are unknown") {
                mockSystemLocaleProvider.mockRegionCode = "XX"
                mockSystemLocaleProvider.mockIdentifier = ""
                mockCarrierLocaleProvider.mockRegionCode = nil
                expect(localeProvider.regionCode) == "GB"
            }
        }
        
    }
    
    class MockSystemLocaleProviding: SystemLocaleProviding {
        var mockRegionCode: String? = "CH"
        var mockLanguageCode: String? = "it"
        var mockIdentifier: String = "fr_FR"
        
        var regionCode: String? {
            return mockRegionCode
        }
        
        var languageCode: String? {
            return mockLanguageCode
        }
        
        var identifier: String {
            return mockIdentifier
        }
    }
    
    class MockCarrierLocaleProviding: CarrierLocaleProviding {
        var mockRegionCode: String? = "AT"
        
        var regionCode: String? {
            return mockRegionCode
        }
    }
}
