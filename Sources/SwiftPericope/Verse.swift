import Foundation

struct Verse {
    let book: Book
    let chapter: Int
    let verse: Int
    
    init(book: Book, chapter: Int, verse: Int) throws {
        guard chapter > 0, chapter <= Pericope.maxChapter(of: book) else { throw PericopeParsingError.invalidChapter }
        guard verse > 0, let maxVerse = try? Pericope.maxVerse(ofBook: book, chapter: chapter), verse <= maxVerse else { throw PericopeParsingError.invalidVerse }
        
        self.book = book
        self.chapter = chapter
        self.verse = verse
    }
}

// MARK: - Verse ID

extension Verse {
    var number: Int {
        book.rawValue * 1_000_000 + chapter * 1000 + verse
    }
    
    init(_ verseId: Int) throws {
        guard let book = Book(rawValue: verseId / 1_000_000) else { throw PericopeParsingError.invalidVerseId }
        let chapter = (verseId % 1_000_000) / 1000
        let verse = verseId % 1000
        
        try self.init(book: book, chapter: chapter, verse: verse)
    }
}

// MARK: - Stridable conformance

extension Verse: Strideable {
    static var max: Verse { try! Verse(book: .revelation, chapter: 22, verse: 21) }

    var absoluteVerseCount: Int {
        var count: Int = 0
        
        // Count verses in preceding books
        for bookNum in 1..<self.book.rawValue {
            if let book = Book(rawValue: bookNum) {
                let maxChapter = Pericope.maxChapter(of: book)
                for chapterNum in 1...maxChapter {
                    count += try! Pericope.maxVerse(ofBook: book, chapter: chapterNum)
                }
            }
        }
        
        // Count verses in preceding chapters
        for chapterNum in 1..<self.chapter {
            count += try! Pericope.maxVerse(ofBook: self.book, chapter: chapterNum)
        }
        
        // Add verse
        count += verse
        
        return count
    }
    
    func advanced(by n: Int) -> Verse {
        var nextVerse = verse
        var nextChapter = chapter
        var nextBook = book
        
        var currentMaxVerse: Int
        
        let next: Verse?
        
        nextVerse += n
        do {
            currentMaxVerse = try Pericope.maxVerse(ofBook: nextBook, chapter: nextChapter)
            while nextVerse > currentMaxVerse {
                nextVerse -= currentMaxVerse
                nextChapter += 1
                if nextChapter > Pericope.maxChapter(of: nextBook) {
                    nextChapter -= Pericope.maxChapter(of: nextBook)
                    guard let advancedBook = Book(rawValue: nextBook.rawValue + 1) else { throw PericopeParsingError.invalidBook }
                    nextBook = advancedBook
                }
                currentMaxVerse = try Pericope.maxVerse(ofBook: nextBook, chapter: chapter)
            }
            
            next = try Verse(book: nextBook, chapter: nextChapter, verse: nextVerse)
        } catch {
            next = nil
        }
        
        return next ?? Verse.max
    }
    
    func distance(to other: Verse) -> Int {
        absoluteVerseCount - other.absoluteVerseCount
    }
}
