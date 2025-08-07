import Foundation

@MainActor
final class QuoteScreenViewModel: ObservableObject {
    @Published var state: QuoteScreenState = .idle
    
    private let getTodayQuoteUseCase: GetTodayQuoteUseCaseProtocol
    
    init(getTodayQuoteUseCase: GetTodayQuoteUseCaseProtocol) {
        self.getTodayQuoteUseCase = getTodayQuoteUseCase
    }
    
    func loadTodayQuote() {
        Task {
            await fetchTodayQuote()
        }
    }
    
    func refreshQuote() {
        Task {
            await fetchTodayQuote()
        }
    }
    
    private func fetchTodayQuote() async {
        state = .loading
        
        do {
            let quote = try await getTodayQuoteUseCase.execute()
            state = .loaded(quote)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}