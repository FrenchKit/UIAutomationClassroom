//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public protocol MockServerProtocol {
    var session: URLSession! { get }
    var address: String { get }
    func startTest()
    func stopTest()
    func mock(response: MockServerResponse, for request: MockServerRequest)
}


public struct MockServerRequest {

    var url: String
    var parameters: [String: String]
    var method: String

    public init(url: String, parameters: [String: String] = [:], method: String = "GET") {
        self.url = url
        self.parameters = parameters
        self.method = method
    }
}

public struct MockServerResponse {

    let path: String
    var body: String

    let encoding: String
    let mimeType: String

    public init(path: String) {
        self.init(path: path, body: path)
    }

    public init(path: String, body: String, mimeType: String = "application/json", encoding: String = "base64") {
        self.path = path
        self.body = body
        self.encoding = encoding
        self.mimeType = mimeType

        do {
            self.body = try String(contentsOfFile: path)
        } catch {
            // Left intentionally empty
            // accept content string rather than file
            // contents
            // TODO: do this with separate body/path
            // initializers
        }
    }

}

public final class MockServer: NSObject, MockServerProtocol {

    enum HTTPMethod: String {
        case GET, POST, PUT, DELETE, PATCH, HEAD
    }

    public static let defaultAddress = "http://0.0.0.0:4567"

    public let address: String
    public var session: URLSession!

    let testID: String

    public init(address: String = MockServer.defaultAddress, testID: String) {
        self.address = address
        self.testID = testID
        super.init()
        self.session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
    }

    public func startTest() {
        execute(request(for: "test", method: .POST))
    }

    public func stopTest() {
        execute(request(for: "test", method: .DELETE))
    }

    public func mock(response mockResponse: MockServerResponse, for mockRequest: MockServerRequest) {
        var parameters: [String: String] = ["url": mockRequest.url,
                                            "method": mockRequest.method,
                                            "mime_type": mockResponse.mimeType,
                                            "encoding": mockResponse.encoding,
                                            "status_code": "200"]
        if let mockParameters = parameterString(from: mockRequest.parameters) {
            parameters["parameters"] = mockParameters
        }
        execute(request(for: "mock", method: .POST, parameters: parameters, body: mockResponse.body.data(using: .utf8)!, mimeType: mockResponse.mimeType))
    }

    private func request(for path: String, method: HTTPMethod, parameters: [String: String] = [:], body: Data? = nil, mimeType: String? = nil) -> URLRequest? {
        guard let baseUrl = URL(string: address) else { return nil }
        var url = baseUrl.appendingPathComponent(path)
        if method == .GET {
            url = urlWithGETParameters(url: url, parameters: parameters)
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.setValue(testID, forHTTPHeaderField: "x-test-name")
        request.httpMethod = method.rawValue
        if method != .GET {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = multipartBody(parameters: parameters,
                                             boundary: boundary,
                                             data: body,
                                             mimeType: mimeType ?? "application/json",
                                             filename: "file")
        }
        return request
    }

    private func multipartBody(parameters: [String: String],
                               boundary: String,
                               data: Data?,
                               mimeType: String,
                               filename: String) -> Data {
        let body = NSMutableData()

        let boundaryPrefix = "--\(boundary)\r\n"

        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        if let data = data {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
        }

        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }

    private func urlWithGETParameters(url: URL, parameters: [String: String]) -> URL {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
        var queryItems = components.queryItems ?? [URLQueryItem]()
        let additionalParameters = parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
        queryItems.append(contentsOf: additionalParameters)
        guard !queryItems.isEmpty else { return url }
        components.queryItems = queryItems
        return components.url ?? url
    }

    private func parameterString(from parameters: [String: String]) -> String? {
        var components = URLComponents()
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.query
    }

    @discardableResult
    private func execute(_ request: URLRequest?) -> Data? {
        guard let request = request else { return nil }
        let semaphore = DispatchSemaphore(value: 0)
        var result: Data? = nil
        let task = session.dataTask(with: request) { data, response, error in
            if let e = error {
                print(e)
            }
            result = data
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return result
    }
}

extension String {
    func removingPrefix(_ prefix: String) -> String {
        return substring(from: index(startIndex, offsetBy: prefix.unicodeScalars.count))
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
