//
//  Copyright © 2017 Zalando. All rights reserved.
//

import Foundation

public extension MockServer {

    public func mockFromArchive(_ archive: HarArchive) {
        archive.entries.forEach {
            if let request = $0.request?.mockServerRequest,
                let response = $0.response?.mockServerResponse {
                self.mock(response: response, for: request)
            }
        }
    }

    public func startMockingFrom(_ archive: HarArchive) {
        startTest()
        mockFromArchive(archive)
    }

}

extension HarArchive.Request {

    var mockServerRequest: MockServerRequest? {
        guard let url = url, let method = method else { return nil }
        let parameters = (queryString ?? []).reduce([String: String]()) {
            var (key, value, result) = ($0.1.name, $0.1.value, $0.0)
            result[key] = value
            return result
        }
        return MockServerRequest(url: url.absoluteString, parameters: parameters, method: method.rawValue)
    }

}

extension HarArchive.Response {

    var mockServerResponse: MockServerResponse? {
        guard let content = content, let text = content.text, let mimeType = content.mimeType else { return nil }
        return MockServerResponse(path: "foo", body: text, mimeType: mimeType)
    }

}
