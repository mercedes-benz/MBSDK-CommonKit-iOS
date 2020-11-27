//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Provider of local or related information
public protocol LocaleProviding {
    
    /// the current locale, either from Locale.current, manually build with languageCode
    /// and regionCode or default to "en-GB"
    /// Format: "<language>-<region>"
    var locale: String { get }
    
    /// the current language code, either from Locale.current or default to "en"
    var languageCode: String { get }
    
    /// the current region, either from Locale.current, the current cell phone provider
    /// or default to "GB"
    var regionCode: String { get }
}

public class MBLocaleProvider: LocaleProviding {
    
    private struct Defaults {
        static let languageFallbackIdentifier = "en"
        static let regionFallbackIdentifier = "GB"
    }
    
    private let systemLocaleProvider: SystemLocaleProviding
    private let carrierLocaleProvider: CarrierLocaleProviding
    
    public convenience init() {
        
        self.init(systemLocaleProvider: SystemLocaleProvider(),
                  carrierLocaleProvider: CarrierLocaleProvider())
    }
    
    init(systemLocaleProvider: SystemLocaleProviding,
         carrierLocaleProvider: CarrierLocaleProviding) {
        
        self.systemLocaleProvider = systemLocaleProvider
        self.carrierLocaleProvider = carrierLocaleProvider
    }
    
    public var locale: String {
         return self.languageCode + "-" + self.regionCode
    }
    
    public var languageCode: String {
        if let languageCode = self.systemLocaleProvider.languageCode {
            return languageCode
        }

        return self.localeComponents()?.first ??
               MBLocaleProvider.Defaults.languageFallbackIdentifier
    }
    
    public var regionCode: String {
        
        if let regionCode = self.verifyValidRegion(self.systemLocaleProvider.regionCode) {
            return regionCode
        }

        return self.verifyValidRegion(self.localeComponents()?.last) ??
               self.verifyValidRegion(self.carrierLocaleProvider.regionCode) ??
               MBLocaleProvider.Defaults.regionFallbackIdentifier
    }
    
    private func verifyValidRegion(_ regionCode: String?) -> String? {

        guard let regionCode = regionCode, // not nil
              regionCode.isEmpty == false, // not ""
              Int(regionCode) == nil,      // not an Int, such as "150" for en_150
              self.isUppercased(regionCode), // must be uppercase only
              self.isKnownCountryCode(regionCode) else { // check if its a known region code
                return nil
        }
        
        return regionCode
    }
    
    private func isKnownCountryCode(_ code: String) -> Bool {
        return Locale.isoRegionCodes.contains(code)
    }
    
    private func isUppercased(_ text: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: "[A-Z\\s]+") else {
            return false
        }
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex.firstMatch(in: text, options: [], range: range) != nil
    }
    
    private func localeComponents() -> [String]? {
        let id = self.systemLocaleProvider.identifier
        guard id.isEmpty == false else {
            return nil
        }
        
        // only consider the locale components if it contains both the
        // language and the region part
        let components = id.components(separatedBy: "_")
                           // dont use e.g. "Hant" in "zh_Hant_HK". All ISO identifier are <= 3 chars
                           .compactMap { $0.count <= 3 ? $0 : nil }
        return components.count >= 2 ? components : nil
    }
}
