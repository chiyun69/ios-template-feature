import XCTest
@testable import template_feature

final class QuoteMapperTests: XCTestCase {
    
    private var mapper: QuoteMapper!
    
    override func setUp() {
        super.setUp()
        mapper = QuoteMapper()
    }
    
    override func tearDown() {
        mapper = nil
        super.tearDown()
    }
    
    func testToDomainSingleDTO() {
        let dto = QuoteResponseDTO(quote: "Test quote", author: "Test Author", html: "<p>Test</p>")
        
        let result = mapper.toDomain(dto)
        
        XCTAssertEqual(result.text, "Test quote")
        XCTAssertEqual(result.author, "Test Author")
        XCTAssertNotNil(result.date)
    }
    
    func testToDomainMultipleDTOs() {
        let dto1 = QuoteResponseDTO(quote: "First quote", author: "First Author", html: "<p>First</p>")
        let dto2 = QuoteResponseDTO(quote: "Second quote", author: "Second Author", html: "<p>Second</p>")
        let dtos = [dto1, dto2]
        
        let results = mapper.toDomain(dtos)
        
        XCTAssertEqual(results.count, 2)
        
        XCTAssertEqual(results[0].text, "First quote")
        XCTAssertEqual(results[0].author, "First Author")
        XCTAssertNotNil(results[0].date)
        
        XCTAssertEqual(results[1].text, "Second quote")
        XCTAssertEqual(results[1].author, "Second Author")
        XCTAssertNotNil(results[1].date)
    }
    
    func testToDomainEmptyArray() {
        let dtos: [QuoteResponseDTO] = []
        
        let results = mapper.toDomain(dtos)
        
        XCTAssertTrue(results.isEmpty)
    }
    
    func testToDomainWithEmptyStrings() {
        let dto = QuoteResponseDTO(quote: "", author: "", html: "")
        
        let result = mapper.toDomain(dto)
        
        XCTAssertEqual(result.text, "")
        XCTAssertEqual(result.author, "")
        XCTAssertNotNil(result.date)
    }
    
    func testToDomainDateIsRecent() {
        let dto = QuoteResponseDTO(quote: "Test quote", author: "Test Author", html: "<p>Test</p>")
        let beforeMapping = Date()
        
        let result = mapper.toDomain(dto)
        let afterMapping = Date()
        
        XCTAssertGreaterThanOrEqual(result.date, beforeMapping)
        XCTAssertLessThanOrEqual(result.date, afterMapping)
    }
}
