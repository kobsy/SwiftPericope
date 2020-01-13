import Foundation

struct SwiftPericope {
    var text = "Hello, World!"
}

func coerceToRange<T>(_ item: T, range: ClosedRange<T>) -> T {
    if item < range.lowerBound { return range.lowerBound }
    if item > range.upperBound { return range.upperBound }
    return item
}

public enum PericopeParsingError: Error {
    case invalidBook,
        invalidChapter,
        invalidVerse,
        invalidVerseId
}

public struct Pericope {

}

// MARK: - Data Access

extension Pericope {
    static func maxChapter(of book: Book) -> Int {
        Pericope.chaptersPerBook[book]!
    }
    
    static func maxVerse(ofBook book: Book, chapter: Int) throws -> Int {
        let chapterId = book.rawValue * 1_000_000 + chapter * 1000
        guard let maxVerse = Pericope.versesPerChapter[chapterId] else { throw PericopeParsingError.invalidChapter }
        return maxVerse
    }
}

// MARK: - Parsing

extension Pericope {
    struct ReferenceFragment {
        var chapter: Int
        var verse: Int?
        
        var needsVerse: Bool { verse == nil }
        
        func verse(withBook book: Book) -> Verse? {
            guard let verse = verse else { return nil }
            return try? Verse(book: book, chapter: chapter, verse: verse)
        }
    }
    
    static func parseRanges(book: Book, ranges: [String]) -> [Range<Verse>] {
        var defaultChapter: Int? = nil
        var defaultVerse: Int? = nil
        if !book.hasChapters { defaultChapter = 1 }
        
        var parsed = [Range<Verse>]()
        
        for range in ranges {
            let splitRange = range.split(separator: "-", maxSplits: 2)
            let rangeBeginString = String(splitRange.first!)
            let rangeEndString = String(splitRange.last ?? splitRange.first!)
            
            
        }
        
        // TODO
        
        return parsed
    }
    
    static func parseReferenceFragment(_ input: String, defaultChapter: Int? = nil, defaultVerse: Int? = nil) -> ReferenceFragment {
        let matches = Pericope.fragmentRegex.matches(in: input, range: input.nsRange).first { $0.numberOfRanges > 1 }!
        var chapter = Int((input as NSString).substring(with: matches.range(at: 1)))
        chapter = chapter ?? defaultChapter
        
        var verse = Int((input as NSString).substring(with: matches.range(at: 2)))
        if chapter == nil {
            chapter = verse
            verse = nil
        }
        verse = verse ?? defaultVerse
        
        return ReferenceFragment(chapter: chapter!, verse: verse)
    }
    
    static func toValidChapter(book: Book, chapter: Int) -> Int {
        coerceToRange(chapter, range: 1...Pericope.maxChapter(of: book))
    }
    
    static func toValidVerse(book: Book, chapter: Int, verse: Int) -> Int {
        let maxVerse = (try? Pericope.maxVerse(ofBook: book, chapter: chapter)) ?? 1
        return coerceToRange(verse, range: 1...maxVerse)
    }
}
