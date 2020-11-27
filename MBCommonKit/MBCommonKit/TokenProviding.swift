//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public enum TokenProvidingError: Error {
    case tokenRefreshFailed
}

/// Protocol to implement an own provider for the pin handling
public protocol TokenProviding: class {
    
    /// Request a valid token
    ///
    /// - Parameters:
    ///   - completion: Closure with Result
    func refreshTokenIfNeeded(completion: @escaping (Result<TokenConformable, TokenProvidingError>) -> Void)
    
    // MARK: - deprecated
    
    /// Completion for token providing
    ///
    /// Returns a string (token)
    typealias TokenProvidingCompletion = (TokenConformable) -> Void

    /// Request a valid token
    ///
    /// - Parameters:
    ///   - onComplete: Closure with TokenProvidingCompletion
    @available(*, deprecated, message: "Please use refreshTokenIfNeeded(completion:) instead.")
    func requestToken(onComplete: @escaping TokenProviding.TokenProvidingCompletion)

    init()
}
