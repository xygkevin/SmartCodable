//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SmartCodable
import HandyJSON
import CleanJSON
import BTPrint


/** 字典的值情况
 1. @Published 修饰的属性的解析。
 2. 继承关系！！！！
 *
 */


/**
 V4.1.12 发布公告
 1. 【新功能】支持Combine，允许@Published修饰的属性解析。
 2. 【新功能】支持@igonreKey修饰的属性在encode时，不出现在json中（屏蔽这个属性key）
 3. 【新功能】支持encode时候的options，同decode的options使用。
 4. 【优化】Data类型在decode和encode时，只能使用base64解析.
 */


class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartSentinel.debugMode = .verbose
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dict2: [String: Any] =  [
            "hobby": 123,
            "age": [],
        ]
        
        let dict1: [String: Any] =  [
            
//            "hobby": 123,
//            "age": "13",
            "sub":  dict2
        ]

        guard let model = Father.deserialize(from: dict1) else { return }
        print("model = \(model)")
        
//        guard let models = [Son].deserialize(from: [dict1, dict2]) else { return }
//        print("models = \(models)")
        
    }
    struct Father: SmartCodable {
        var hobby: String?
        var age: Int = 0
        var name: String = "Mccc"
        var firstSon: Son?
        var secondSon: Son = Son()
        var sons: [Son] = []
    }
    
    struct Son: SmartCodable {
        var hobby: String?
        var age: Int = 0
    }
    
}




