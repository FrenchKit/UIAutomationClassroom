//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import ObjectMapper
import UIKit

/**
 https://en.wikipedia.org/wiki/.har
 
 .har files are a JSON-based archive of
 "a web browser's interaction with a site". Can be exported
 from a Charles session. Format contains a lot of non-
 essential meta-data, so not 100% of this is parsed here.
 Most important is requests/responses and some of the
 more simple/essential meta-data
 
 @note Collection conformance allows convenience
 access to the contained request/response entries.
 */

public struct HarArchive: Mappable, Collection {

    private(set) public var version: String?
    private(set) public var creator: Creator?
    private(set) public var entries = [Entry]()

    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        version <- map["log.version"]
        creator <- map["log.creator"]
        entries <- map["log.entries"]
    }

    public struct Creator: Mappable {

        private(set) public var name: String?
        private(set) public var version: String?

        public init?(map: Map) {}

        public mutating func mapping(map: Map) {
            version <- map["version"]
            name <- map["name"]
        }

    }

    public struct Entry: Mappable {

        private(set) public var started: Date?
        private(set) public var time: TimeInterval?
        private(set) public var ipAddress: String?

        private(set) public var request: Request?
        private(set) public var response: Response?
        private(set) public var cache: [AnyHashable: Any]?
        private(set) public var timings: [AnyHashable: Any]?

        public init?(map: Map) {}

        public mutating func mapping(map: Map) {
            time <- map["time"]
            ipAddress <- map["serverIPAddress"]
            started <- (map["startedDateTime"], DateTransform())
            request <- map["request"]
            response <- map["response"]
            cache <- map["cache"]
            timings <- map["timings"]
        }

    }

    public class BaseEntry {

        private(set) public var httpVersion: String?
        private(set) public var headersSize: Int?
        private(set) public var bodySize: Int?

        private(set) public var cookies: [[String: Any]]?
        private(set) public var headers: [MapEntry]?

        public required init?(map: Map) {}

        public func mapping(map: Map) {
            headersSize <- map["headersSize"]
            bodySize <- map["bodySize"]
            httpVersion <- map["httpVersion"]
            cookies <- map["cookies"]
            headers <- (map["headers"], MapEntryTransform())
        }

    }


    public final class Request: BaseEntry, Mappable {

        private(set) public var method: HTTPMethod?
        private(set) public var queryString: [MapEntry]?
        private(set) public var url: URL?

        public override func mapping(map: Map) {
            super.mapping(map: map)
            method <- map["method"]
            url <- (map["url"], URLTransform())
            queryString <- (map["queryString"], MapEntryTransform())
        }

    }

    public final class Response: BaseEntry, Mappable {

        private(set) public var status: Int?
        private(set) public var statusText: String?
        private(set) public var content: Content?
        private(set) public var redirectURL: URL?

        public override func mapping(map: Map) {
            super.mapping(map: map)
            status <- map["status"]
            statusText <- map["statusText"]
            content <- map["content"]
            redirectURL <- (map["redirectURL"], URLTransform())
        }

    }

    public struct Content: Mappable {

        private(set) public var size: Int?
        private(set) public var mimeType: String?
        private(set) public var text: String?
        private(set) public var encoding: Encoding?

        public enum Encoding: String {
            case base64
        }

        public init?(map: Map) {}

        public mutating func mapping(map: Map) {
            size <- map["size"]
            text <- map["text"]
            mimeType <- map["mimeType"]
            encoding <- map["encoding"]
        }
    }

    public typealias MapEntry = (name: String, value: String)

    struct MapEntryTransform: TransformType {

        typealias Object = MapEntry
        typealias JSON = [String: Any]

        func transformFromJSON(_ value: Any?) -> MapEntry? {
            guard let json = value as? JSON,
                let name = json["name"] as? String,
                let value = json["value"] as? String
                else { return nil }
            return (name: name, value: value)
        }

        func transformToJSON(_ value: MapEntry?) -> JSON? {
            guard let value = value else { return nil }
            return ["name": value.name, "value": value.value]
        }

    }

    struct URLTransform: TransformType {

        typealias Object = URL
        typealias JSON = String

        func transformFromJSON(_ value: Any?) -> URL? {
            guard let json = value as? JSON else { return nil }
            return URL(string: json)
        }

        func transformToJSON(_ value: URL?) -> String? {
            guard let value = value else { return nil }
            return value.absoluteString
        }

    }

    struct DateTransform: TransformType {

        typealias Object = Date
        typealias JSON = String

        static let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            return formatter
        }()

        func transformFromJSON(_ value: Any?) -> Date? {
            guard let json = value as? JSON else { return nil }
            return DateTransform.formatter.date(from: json)
        }

        func transformToJSON(_ value: Date?) -> String? {
            guard let value = value else { return nil }
            return DateTransform.formatter.string(from: value)
        }

    }

    public enum HTTPMethod: String {
        case GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH
    }

}

public extension HarArchive {

    public init?(fixtureName: String, subdirectory: String? = "Fixtures", bundle: Bundle = Bundle.main) {
        if let url = bundle.url(forResource: fixtureName, withExtension: "har", subdirectory: subdirectory),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictionary = json as? [String: Any]
        {
            self.init(JSON: dictionary)
        } else {
            return nil
        }
    }

}

public extension HarArchive.Content {

    var data: Data? {
        guard let text = text, let base64Data = text.data(using: .utf8) else { return nil }
        return Data(base64Encoded: base64Data)
    }

    func decode<T: Base64Decodable>(_ type: T.Type) -> T? {
        guard let data = data else { return nil }
        return type.instantiateWithBase64(data)
    }

}

/**
 Some type-safe convenience accessors for response content.
 JSON String/JSON Dictionary and image/jpeg only provided
 at this time.
 */
public protocol Base64Decodable {

    static func instantiateWithBase64(_ data: Data) -> Self?

}

extension String: Base64Decodable {

    public static func instantiateWithBase64(_ data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }

}

extension Dictionary: Base64Decodable {

    public static func instantiateWithBase64(_ data: Data) -> Dictionary<Key, Value>? {
        guard let json = try? JSONSerialization.jsonObject(with: data),
            let dict = json as? [Key: Value] else { return nil }
        return dict
    }

}

extension UIImage: Base64Decodable {

    public static func instantiateWithBase64(_ data: Data) -> Self? {
        return self.init(data: data)
    }
    
}

// Convenience Collection access to the archive's Entries
extension HarArchive {
    
    public var startIndex: Int {
        return entries.startIndex
    }
    
    public var endIndex: Int {
        return entries.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return entries.index(after: i)
    }
    
    public subscript(index: Int) -> Entry {
        return entries[index]
    }
    
}
