// 
//  CleanJSONDecoder.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation



open class SmartJSONDecoder: JSONDecoder {
    
    /// Options set on the top-level encoder to pass down the decoding hierarchy.
    struct Options {
        let dateDecodingStrategy: DateDecodingStrategy
        let dataDecodingStrategy: DataDecodingStrategy
        let nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy
        let keyDecodingStrategy: KeyDecodingStrategy
        let userInfo: [CodingUserInfoKey : Any]
    }
    
    /// The options set on the top-level decoder.
    var options: Options {
        return Options(
            dateDecodingStrategy: dateDecodingStrategy,
            dataDecodingStrategy: dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: keyDecodingStrategy,
            userInfo: userInfo
        )
    }
    
    // MARK: - Decoding Values

    /// Decodes a top-level value of the given type from the given JSON representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    open override func decode<T : Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let topLevel: Any
        do {
            topLevel = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        } catch {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: error))
        }
        return try _decode(type, from: topLevel)
    }
    
    
    open func decode<T : Decodable>(_ type: T.Type, from dict: [String: Any]) throws -> T {
        return try _decode(type, from: dict)
    }
    
    
    open func decode<T : Decodable>(_ type: T.Type, from array: [Any]) throws -> T {
        return try _decode(type, from: array)
    }
}

extension SmartJSONDecoder {
    
    private func _decode<T : Decodable>(_ type: T.Type, from container: Any) throws -> T {
        let decoder = _CleanJSONDecoder(referencing: container, options: self.options)
        guard let value = try decoder.unbox(container, as: type) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON."))
        }
        return value
    }
}