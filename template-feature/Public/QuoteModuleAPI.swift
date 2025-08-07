import SwiftUI

public protocol QuoteModuleAPI {
    @MainActor func makeQuoteScreen() -> AnyView
}

public final class QuoteModuleBuilder: QuoteModuleAPI {
    public init() {}
    
    @MainActor
    public func makeQuoteScreen() -> AnyView {
        let viewModel = QuoteModule.shared.makeQuoteScreenViewModel()
        let screen = QuoteScreen(viewModel: viewModel)
        return AnyView(screen)
    }
}