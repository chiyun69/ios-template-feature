import Foundation

enum QuoteScreenState: Equatable {
    case idle
    case loading
    case loaded(Quote)
    case error(String)
}