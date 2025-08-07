import Foundation

final class QuoteModule {
    static let shared = QuoteModule()
    
    private init() {}
    
    // MARK: - API Services
    private lazy var zenQuotesAPIService: ZenQuotesAPIServiceProtocol = {
        ZenQuotesAPIService()
    }()
    
    // MARK: - Mappers
    private lazy var quoteMapper: QuoteMapper = {
        QuoteMapper()
    }()
    
    // MARK: - Repositories
    private lazy var quoteRepository: QuoteRepository = {
        QuoteRepositoryImpl(
            apiService: zenQuotesAPIService,
            mapper: quoteMapper
        )
    }()
    
    // MARK: - Use Cases
    private lazy var getTodayQuoteUseCase: GetTodayQuoteUseCase = {
        GetTodayQuoteUseCase(repository: quoteRepository)
    }()
    
    // MARK: - ViewModels
    @MainActor
    func makeQuoteScreenViewModel() -> QuoteScreenViewModel {
        return QuoteScreenViewModel(getTodayQuoteUseCase: getTodayQuoteUseCase)
    }
}