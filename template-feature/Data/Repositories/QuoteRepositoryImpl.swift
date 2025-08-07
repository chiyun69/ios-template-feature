import Foundation

final class QuoteRepositoryImpl: QuoteRepository {
    private let apiService: ZenQuotesAPIServiceProtocol
    private let mapper: QuoteMapperProtocol
    
    init(apiService: ZenQuotesAPIServiceProtocol, mapper: QuoteMapperProtocol) {
        self.apiService = apiService
        self.mapper = mapper
    }
    
    func getTodayQuote() async throws -> Quote {
        let dtos = try await apiService.fetchTodayQuote()
        let quotes = mapper.toDomain(dtos)
        
        guard let firstQuote = quotes.first else {
            throw RepositoryError.noQuoteFound
        }
        
        return firstQuote
    }
}

enum RepositoryError: Error {
    case noQuoteFound
}