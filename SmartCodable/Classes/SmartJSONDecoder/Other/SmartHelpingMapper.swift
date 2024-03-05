//
//  SmartHelpingMapper.swift
//  SmartCodable
//
//  Created by qixin on 2024/3/4.
//

import Foundation

public typealias SmartMapping = (olds: [String], new: CodingKey)

infix operator <--

public func <--(left: CodingKey, right: String) -> SmartMapping {
    left <-- [right]
}

public func <--(left: CodingKey, right: [String]) -> SmartMapping {
    (right, left)
}



struct SmartHelpingMapper<T> {
    static func mapping(value: Any) -> Any {
        
        // 如果是解析的是Model
        guard let t = T.self as? SmartDecodable.Type else { return value }
        
        if let string = value as? String, let jsonObject = string.toJSONObject() { // 可以对象化的json数据
            if let dict = jsonObject as? [String: Any] {
                return mappingDict(t: t, dict: dict)
            } else {
                return jsonObject
            }
        } else if let dict = value as? [String: Any] {
            return mappingDict(t: t, dict: dict)
        } else {
            return value
        }
    }
    
    // 处理key的映射
    private static func mappingDict(t: SmartDecodable.Type, dict: [String: Any]) -> [String: Any] {
    
        var dict = dict
        let arr = t.mapping() ?? []
        
            
        for item in arr {
            
            for old in item.olds {
                if dict.keys.contains(old) {
                    let new = item.1.stringValue
                    // dict是原始值
                    dict.updateKeyName(oldKey: old, newKey: new)
                    break
                }
            }
        }
        
        return dict
    }
}
extension String {
    
    fileprivate func toJSONObject() -> Any? {
        // 过滤掉非 JSON 格式字符串
        guard hasPrefix("{") || hasPrefix("[") else { return nil }
        
        guard let data = data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data) else {
            return nil
        }
        
        return jsonObject
    }
}

