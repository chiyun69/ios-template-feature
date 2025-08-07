import Foundation

protocol QuoteRepository {
    func getTodayQuote() async throws -> Quote
}