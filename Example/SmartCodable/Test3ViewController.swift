
import SmartCodable

class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var father = Father()
        father.son = Son(name: "Qilin", age: 4)
        print("father = \(father)")
        let dict: [String: Any] = [
            "age": 30,
            "name": "Mccc",
//            "prop3": [
//                "p1": 9,
//                "p2": "nested"
//            ]
        ]
        SmartUpdater.update(&father, from: dict)
        print("father updated = \(father)")
    }
   
}

class Father: NSObject, SmartCodable {
    required override init() {}
    var age = 0
    var name = ""
    var son = Son()
    override var description: String {
        "name: \(name), age: \(age), son: \(son)"
    }
}

class Son: SmartCodable, CustomStringConvertible {
    required init() {}
    var age: Int = 0
    var name: String = ""
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [
            CodingKeys.name <--- "p1",
            CodingKeys.age <--- "p2"
        ]
    }
    
    convenience init(name: String, age: Int) {
        self.init()
        self.name = name
        self.age = age
    }
    
    var description: String {
        "name: \(name), age: \(age)"
    }
}



