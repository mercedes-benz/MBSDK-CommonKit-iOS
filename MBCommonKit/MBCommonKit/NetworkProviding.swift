//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation


// MARK: - BffProviding

public protocol BffProviding {
	
	/// default header parameters
	var headerParamProvider: HeaderParamProviding { get }
	
	/// session id for bff
	var sessionId: String { get set }
	
	/// url provider
	var urlProvider: UrlProviding { get }
}


// MARK: - HeaderParamProviding

public protocol HeaderParamProviding {

	/// authorization parameter key
	var authorizationHeaderParamKey: String { get }
    
    /// authorization mode parameter key, e.g. "X-Authmode"
    var authorizationModeParamKey: String { get }
	
	/// country code parameter key
	var countryCodeHeaderParamKey: String { get }
	
	/// default header parameters
	var defaultHeaderParams: [String: String] { get }
	
	/// locale parameter key
	var localeHeaderParamKey: String { get }
    
    /// ldsso agreements app id and version header parameter
    var ldssoAppHeaderParams: [String: String] { get }
}

// MARK: - UrlProviding

public protocol UrlProviding {
	
	/// string-based base url
	var baseUrl: String { get }
	
	/// Timeout for http requests
	var requestTimeout: TimeInterval { get }
}

extension UrlProviding {
	
	/// Timeout for http requests (default is 10s)
	public var requestTimeout: TimeInterval {
		return 60
	}
}


// MARK: - SocketProviding

public protocol SocketProviding {
	
	/// default header parameters
	var headerParamProvider: HeaderParamProviding { get }
	
	/// url provider
	var urlProvider: UrlProviding { get }
}
