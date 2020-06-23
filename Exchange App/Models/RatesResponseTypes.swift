//
//  RatesResponseTypes.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

public protocol RatesResponseDecodable { }

/// Do not use this structure outside of RatesResponse. His scope is to wrapper decodables for custom types on RatesResponse
/**
    * Decode method will detect nested Rate Response types and will try to decode them as well.
    * Else, will try to decode primitive data instead.
 */
public struct RatesResponseType {
    public typealias Default = [Currency: Double]
    public typealias DateGrouped = [Date: Default]

    /**

     */
    public static func isValidExchangeRateType<T>(_ type: T.Type) -> Bool {
        switch type {
        case is Default.Type,
             is DateGrouped.Type: return true
        default: return false
        }
    }

    // MARK: - Decoding

    /// Method will decode rate type from decoding containers
    /** * Do not use this method outside of RatesResponse model
        * If ResponseType is not recognised will try to decode it as a primitive type
        * It will rise an error for unknown data types.*/
    public static func decode<T: Decodable, K>(_ type: T.Type,
                                               from container: KeyedDecodingContainer<K>,
                                               forKey key: KeyedDecodingContainer<K>.Key) throws -> T? {
        switch type {
        case is Default.Type:
            return try container.decode(RatesResponseTypeDecoder<Default.Key, Default.Value>.self,
                                        forKey: key).decoded as? T
        case is DateGrouped.Type:
            return try container.decode(RatesResponseTypeDecoder<DateGrouped.Key, DateGrouped.Value>.self,
                                        forKey: key).decoded as? T
        default: return nil
        }
    }
}
