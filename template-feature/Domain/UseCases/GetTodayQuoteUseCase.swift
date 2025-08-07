import Foundation

protocol GetTodayQuoteUseCaseProtocol {
    func execute() async throws -> Quote
}

final class GetTodayQuoteUseCase: GetTodayQuoteUseCaseProtocol {
    private let repository: QuoteRepository
    
    init(repository: QuoteRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> Quote {
        return try await repository.getTodayQuote()
    }
}