import SwiftUI

struct QuoteCardView: View {
    let quote: Quote
    
    var body: some View {
        VStack(spacing: 16) {
            Text("\"\(quote.text)\"")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("— \(quote.author)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(DateFormatter.displayFormatter.string(from: quote.date))
                .font(.caption)
                .foregroundColor(.primary)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

private extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}