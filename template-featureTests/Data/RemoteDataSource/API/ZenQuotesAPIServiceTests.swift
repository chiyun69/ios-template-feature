import XCTest
@testable import template_feature

final class ZenQuotesAPIServiceTests: XCTestCase {
    
    private var service: ZenQuotesAPIService!
    private var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        service = ZenQuotesAPIService(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        service = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testFetchTodayQuoteSuccess() async throws {
        let responseData = """
        [
            {
                "q": "Test quote",
                "a": "Test Author",
                "h": "<p>Test</p>"
            }
        ]
        """.data(using: .utf8)!
        
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://zenquotes.io/api/today")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockURLSession.mockData = responseData
        mockURLSession.mockResponse = httpResponse
        
        let result = try await service.fetchTodayQuote()
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].quote, "Test quote")
        XCTAssertEqual(result[0].author, "Test Author")
        XCTAssertEqual(result[0].html, "<p>Test</p>")
    }
    
    func testFetchTodayQuoteServerError() async {
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://zenquotes.io/api/today")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockURLSession.mockResponse = httpResponse
        mockURLSession.mockData = Data()
        
        do {
            _ = try await service.fetchTodayQuote()
            XCTFail("Expected APIError.serverError to be thrown")
        } catch {
            XCTAssertTrue(error is APIError)
            if case APIError.serverError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected APIError.serverError but got \(error)")
            }
        }
    }
    
    func testFetchTodayQuoteDecodingError() async {
        let invalidResponseData = "Invalid JSON".data(using: .utf8)!
        
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://zenquotes.io/api/today")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockURLSession.mockData = invalidResponseData
        mockURLSession.mockResponse = httpResponse
        
        do {
            _ = try await service.fetchTodayQuote()
            XCTFail("Expected APIError.decodingError to be thrown")
        } catch {
            XCTAssertTrue(error is APIError)
            if case APIError.decodingError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected APIError.decodingError but got \(error)")
            }
        }
    }
    
    func testFetchTodayQuoteNetworkError() async {
        let networkError = URLError(.notConnectedToInternet)
        mockURLSession.mockError = networkError
        
        do {
            _ = try await service.fetchTodayQuote()
            XCTFail("Expected network error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testAPIErrorDescriptions() {
        XCTAssertEqual(APIError.invalidURL.localizedDescription, "Invalid URL")
        XCTAssertEqual(APIError.serverError.localizedDescription, "Server error")
        XCTAssertEqual(APIError.decodingError("test").localizedDescription, "Decoding error: test")
        XCTAssertEqual(APIError.networkError.localizedDescription, "Network error")
    }
}

final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        let data = mockData ?? Data()
        let response = mockResponse ?? HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        return (data, response)
    }
}