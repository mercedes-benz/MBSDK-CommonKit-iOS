//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import CoreTelephony

protocol CarrierLocaleProviding {
    var regionCode: String? { get }
}

class CarrierLocaleProvider: CarrierLocaleProviding {
    
    private let networkInfo = CTTelephonyNetworkInfo()
    
    private var carrier: CTCarrier? {
		return self.networkInfo.serviceSubscriberCellularProviders?.values.first
    }
    
    var regionCode: String? {
        // for whatever reasons, the isoCountryCode from the carrier is lower case...
		return self.carrier?.isoCountryCode?.uppercased()
    }
}
