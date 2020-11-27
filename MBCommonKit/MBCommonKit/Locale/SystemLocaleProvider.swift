//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

protocol SystemLocaleProviding {
    var regionCode: String? { get }
    var languageCode: String? { get }
    var identifier: String { get }
}

class SystemLocaleProvider: SystemLocaleProviding {
    private var locale: Locale {
        return Locale.autoupdatingCurrent
    }
    
    var regionCode: String? {
        return self.locale.regionCode
    }
    
    var languageCode: String? {
        return self.locale.languageCode
    }
    
    var identifier: String {
        return self.locale.identifier
    }
}
