import XCTest
@testable import template_feature

final class QuoteTests: XCTestCase {
    
    func testQuoteInitialization() {
        let date = Date()
        let quote = Quote(
            text: "Test quote",
            author: "Test Author",
            date: date
        )
        
        XCTAssertEqual(quote.text, "Test quote")
        XCTAssertEqual(quote.author, "Test Author")
        XCTAssertEqual(quote.date, date)
    }
    
    func testQuoteEquality() {
        let date = Date()
        let quote1 = Quote(
            text: "Same quote",
            author: "Same Author",
            date: date
        )
        let quote2 = Quote(
            text: "Same quote",
            author: "Same Author",
            date: date
        )
        
        XCTAssertEqual(quote1, quote2)
    }
    
    func testQuoteInequality() {
        let date = Date()
        let quote1 = Quote(
            text: "Different quote",
            author: "Author",
            date: date
        )
        let quote2 = Quote(
            text: "Another quote",
            author: "Author",
            date: date
        )
        
        XCTAssertNotEqual(quote1, quote2)
    }
    
    func testQuoteInequalityDifferentAuthor() {
        let date = Date()
        let quote1 = Quote(
            text: "Same quote",
            author: "Author 1",
            date: date
        )
        let quote2 = Quote(
            text: "Same quote",
            author: "Author 2",
            date: date
        )
        
        XCTAssertNotEqual(quote1, quote2)
    }
    
    func testQuoteInequalityDifferentDate() {
        let date1 = Date()
        let date2 = Date().addingTimeInterval(3600)
        let quote1 = Quote(
            text: "Same quote",
            author: "Same Author",
            date: date1
        )
        let quote2 = Quote(
            text: "Same quote",
            author: "Same Author",
            date: date2
        )
        
        XCTAssertNotEqual(quote1, quote2)
    }
}