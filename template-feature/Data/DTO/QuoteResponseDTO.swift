import Foundation

struct QuoteResponseDTO: Codable {
    let quote: String
    let author: String
    let html: String
    
    enum CodingKeys: String, CodingKey {
        case quote = "q"
        case author = "a"
        case html = "h"
    }
}