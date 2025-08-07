import Foundation

protocol QuoteMapperProtocol {
    func toDomain(_ dto: QuoteResponseDTO) -> Quote
    func toDomain(_ dtos: [QuoteResponseDTO]) -> [Quote]
}

final class QuoteMapper: QuoteMapperProtocol {
    
    func toDomain(_ dto: QuoteResponseDTO) -> Quote {
        return Quote(
            text: dto.quote,
            author: dto.author,
            date: Date() // Use current date since API doesn't provide date
        )
    }
    
    func toDomain(_ dtos: [QuoteResponseDTO]) -> [Quote] {
        return dtos.map { toDomain($0) }
    }
}