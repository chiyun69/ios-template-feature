import XCTest
@testable import template_feature

final class QuoteRepositoryImplTests: XCTestCase {
    
    private var mockAPIService: MockZenQuotesAPIService!
    private var mockMapper: MockQuoteMapper!
    private var repository: QuoteRepositoryImpl!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockZenQuotesAPIService()
        mockMapper = MockQuoteMapper()
        repository = QuoteRepositoryImpl(apiService: mockAPIService, mapper: mockMapper)
    }
    
    override func tearDown() {
        mockAPIService = nil
        mockMapper = nil
        repository = nil
        super.tearDown()
    }
    
    func testGetTodayQuoteSuccess() async throws {
        let dto = QuoteResponseDTO(quote: "Test quote", author: "Test Author", html: "<p>Test</p>")
        let expectedQuote = Quote(text: "Test quote", author: "Test Author", date: Date())
        
        mockAPIService.mockResponse = [dto]
        mockMapper.mockQuotes = [expectedQuote]
        
        let result = try await repository.getTodayQuote()
        
        XCTAssertEqual(result, expectedQuote)
        XCTAssertTrue(mockAPIService.fetchTodayQuoteCalled)
        XCTAssertTrue(mockMapper.toDomainCalled)
    }
    
    func testGetTodayQuoteEmptyResponse() async {
        mockAPIService.mockResponse = []
        mockMapper.mockQuotes = []
        
        do {
            _ = try await repository.getTodayQuote()
            XCTFail("Expected RepositoryError.noQuoteFound to be thrown")
        } catch {
            XCTAssertTrue(error is RepositoryError)
            if case RepositoryError.noQuoteFound = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected RepositoryError.noQuoteFound but got \(error)")
            }
        }
    }
    
    func testGetTodayQuoteAPIError() async {
        let expectedError = APIError.networkError
        mockAPIService.mockError = expectedError
        
        do {
            _ = try await repository.getTodayQuote()
            XCTFail("Expected API error to be thrown")
        } catch {
            XCTAssertTrue(error is APIError)
            XCTAssertEqual(error as? APIError, expectedError)
        }
    }
}

final class MockZenQuotesAPIService: ZenQuotesAPIServiceProtocol {
    var mockResponse: [QuoteResponseDTO] = []
    var mockError: Error?
    var fetchTodayQuoteCalled = false
    
    func fetchTodayQuote() async throws -> [QuoteResponseDTO] {
        fetchTodayQuoteCalled = true
        
        if let error = mockError {
            throw error
        }
        
        return mockResponse
    }
}

final class MockQuoteMapper: QuoteMapperProtocol {
    var mockQuotes: [Quote] = []
    var toDomainCalled = false
    
    func toDomain(_ dto: QuoteResponseDTO) -> Quote {
        toDomainCalled = true
        return mockQuotes.first ?? Quote(text: "", author: "", date: Date())
    }
    
    func toDomain(_ dtos: [QuoteResponseDTO]) -> [Quote] {
        toDomainCalled = true
        return mockQuotes
    }
}