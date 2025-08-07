import XCTest
@testable import template_feature

@MainActor
final class QuoteScreenViewModelTests: XCTestCase {
    
    private var mockUseCase: MockGetTodayQuoteUseCase!
    private var viewModel: QuoteScreenViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        mockUseCase = MockGetTodayQuoteUseCase()
        viewModel = QuoteScreenViewModel(getTodayQuoteUseCase: mockUseCase)
    }
    
    override func tearDown() async throws {
        mockUseCase = nil
        viewModel = nil
        try await super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.state, .idle)
    }
    
    func testLoadTodayQuoteSuccess() async {
        let expectedQuote = Quote(
            text: "Test quote",
            author: "Test Author",
            date: Date()
        )
        mockUseCase.mockQuote = expectedQuote
        
        viewModel.loadTodayQuote()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        XCTAssertEqual(viewModel.state, .loaded(expectedQuote))
        XCTAssertTrue(mockUseCase.executeCalled)
    }
    
    func testLoadTodayQuoteError() async {
        let expectedError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockUseCase.mockError = expectedError
        
        viewModel.loadTodayQuote()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        XCTAssertEqual(viewModel.state, .error("Test error"))
        XCTAssertTrue(mockUseCase.executeCalled)
    }
    
    func testLoadTodayQuoteShowsLoadingState() async {
        let expectation = XCTestExpectation(description: "Loading state should be set")
        mockUseCase.shouldDelay = true
        mockUseCase.mockQuote = Quote(text: "Test", author: "Test", date: Date())
        
        // Start the async operation
        viewModel.loadTodayQuote()
        
        // Give it a moment to set loading state
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        
        // Check that we're in loading state
        XCTAssertEqual(viewModel.state, .loading)
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testRefreshQuoteSuccess() async {
        let expectedQuote = Quote(
            text: "Refreshed quote",
            author: "Refresh Author",
            date: Date()
        )
        mockUseCase.mockQuote = expectedQuote
        
        viewModel.refreshQuote()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        XCTAssertEqual(viewModel.state, .loaded(expectedQuote))
        XCTAssertTrue(mockUseCase.executeCalled)
    }
    
    func testRefreshQuoteError() async {
        let expectedError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Refresh error"])
        mockUseCase.mockError = expectedError
        
        viewModel.refreshQuote()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        XCTAssertEqual(viewModel.state, .error("Refresh error"))
        XCTAssertTrue(mockUseCase.executeCalled)
    }
}

final class MockGetTodayQuoteUseCase: GetTodayQuoteUseCaseProtocol {
    var mockQuote: Quote?
    var mockError: Error?
    var executeCalled = false
    var shouldDelay = false
    
    func execute() async throws -> Quote {
        executeCalled = true
        
        if shouldDelay {
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        }
        
        if let error = mockError {
            throw error
        }
        
        guard let quote = mockQuote else {
            throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No mock quote set"])
        }
        
        return quote
    }
}