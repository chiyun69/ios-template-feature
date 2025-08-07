import XCTest
@testable import template_feature

final class GetTodayQuoteUseCaseTests: XCTestCase {
    
    private var mockRepository: MockQuoteRepository!
    private var useCase: GetTodayQuoteUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockQuoteRepository()
        useCase = GetTodayQuoteUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() async throws {
        let expectedQuote = Quote(
            text: "Test quote",
            author: "Test Author",
            date: Date()
        )
        mockRepository.mockQuote = expectedQuote
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result, expectedQuote)
        XCTAssertTrue(mockRepository.getTodayQuoteCalled)
    }
    
    func testExecuteFailure() async {
        let expectedError = NSError(domain: "test", code: 1, userInfo: nil)
        mockRepository.mockError = expectedError
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
            XCTAssertTrue(mockRepository.getTodayQuoteCalled)
        }
    }
}

final class MockQuoteRepository: QuoteRepository {
    var mockQuote: Quote?
    var mockError: Error?
    var getTodayQuoteCalled = false
    
    func getTodayQuote() async throws -> Quote {
        getTodayQuoteCalled = true
        
        if let error = mockError {
            throw error
        }
        
        guard let quote = mockQuote else {
            throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No mock quote set"])
        }
        
        return quote
    }
}