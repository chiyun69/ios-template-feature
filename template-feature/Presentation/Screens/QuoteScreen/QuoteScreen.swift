import SwiftUI

struct QuoteScreen: View {
    @StateObject private var viewModel: QuoteScreenViewModel
    
    init(viewModel: QuoteScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                switch viewModel.state {
                case .idle:
                    Text("Welcome to Daily Quotes")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    Button("Load Today's Quote") {
                        viewModel.loadTodayQuote()
                    }
                    
                case .loading:
                    VStack(spacing: 16) {
                        ProgressView()
                        Text("Loading today's quote...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                case .loaded(let quote):
                    Image("portrait", bundle: TemplateFeatureResources.bundle)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                    
                    QuoteCardView(quote: quote)
                    
                    Button("Refresh") {
                        viewModel.refreshQuote()
                    }
                    
                case .error(let message):
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text("Something went wrong")
                            .font(.headline)
                        
                        Text(message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Try Again") {
                            viewModel.loadTodayQuote()
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Daily Quote 🤩")
        }
        .onAppear {
            if case .idle = viewModel.state {
                viewModel.loadTodayQuote()
            }
        }
    }
}


#Preview {
    let mockQuote = Quote(
        text: "The only way to do great work is to love what you do.",
        author: "Steve Jobs",
        date: Date()
    )
    
    let mockViewModel = QuoteScreenViewModel(
        getTodayQuoteUseCase: GetTodayQuoteUseCase(
            repository: MockQuoteRepository(quote: mockQuote)
        )
    )
    
    QuoteScreen(viewModel: mockViewModel)
}

class MockQuoteRepository: QuoteRepository {
    private let quote: Quote
    
    init(quote: Quote) {
        self.quote = quote
    }
    
    func getTodayQuote() async throws -> Quote {
        return quote
    }
}
