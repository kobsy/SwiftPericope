//
//  Verse.swift
//  
//
//  Created by Matt Kobs on 1/10/20.
//

import Foundation

enum VerseParsingError: Error {
    case invalidBook, invalidChapter, invalidVerse
}

struct Verse {
    let book: Book
    let chapter: Int
    let verse: Int
    let letter: Character?
    
    init(book: Book, chapter: Int, verse: Int, letter: Character? = nil) throws {
        self.book = book
        self.chapter = chapter
        self.verse = verse
        self.letter = letter
    }
}
