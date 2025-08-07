import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol ZenQuotesAPIServiceProtocol {
    func fetchTodayQuote() async throws -> [QuoteResponseDTO]
}

final class ZenQuotesAPIService: ZenQuotesAPIServiceProtocol {
    private let urlSession: URLSessionProtocol
    private let baseURL = "https://zenquotes.io/api"
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchTodayQuote() async throws -> [QuoteResponseDTO] {
        guard let url = URL(string: "\(baseURL)/today") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw APIError.serverError
        }
        
        do {
            let quotes = try JSONDecoder().decode([QuoteResponseDTO].self, from: data)
            return quotes
        } catch {
            print("Decoding error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }
            throw APIError.decodingError(error.localizedDescription)
        }
    }
}

enum APIError: Error, Equatable {
    case invalidURL
    case serverError
    case decodingError(String)
    case networkError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .serverError:
            return "Server error"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .networkError:
            return "Network error"
        }
    }
}