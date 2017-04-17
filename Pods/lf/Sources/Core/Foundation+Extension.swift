import Foundation

extension Data {
    var bytes:[UInt8] {
        return withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: count))
        }
    }

    init<T>(fromArray values:[T]) {
        var values = values
        self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
    }

    func toArray<T>(type: T.Type) -> [T] {
        return withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0, count: count / MemoryLayout<T>.stride))
        }
    }
}

extension URL {
    var absoluteWithoutAuthenticationString:String {
        var target:String = ""
        if let user:String = user {
            target += user
        }
        if let password:String = password {
            target += ":" + password
        }
        if (target != "") {
            target += "@"
        }
        return absoluteString.replacingOccurrences(of: target, with: "")
    }

    var absoluteWithoutQueryString:String {
        guard let query:String = self.query else {
            return self.absoluteString
        }
        return absoluteString.replacingOccurrences(of: "?" + query, with: "")
    }

    func dictionaryFromQuery() -> [String:String] {
        var result:[String:String] = [:]
        guard
            let comonents:URLComponents = URLComponents(string: absoluteString),
            let queryItems = comonents.queryItems else {
            return result
        }
        for item in queryItems {
            if let value:String = item.value {
                result[item.name] = value
            }
        }
        return result
    }
}
