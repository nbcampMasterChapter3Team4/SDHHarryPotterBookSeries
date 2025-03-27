//
//  BookResponse.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/26/25.
//


import Foundation

// MARK: - BookResponse
struct BookResponse: Codable {
    let data: [Book]
}

// MARK: - Book
struct Book: Codable {
    let attributes: Attributes
}

// MARK: - Attributes
struct Attributes: Codable {
    let title, author: String
    let pages: Int
    let releaseDate, dedication, summary: String
    let wiki: String
    let chapters: [Chapter]

    enum CodingKeys: String, CodingKey {
        case title, author, pages
        case releaseDate = "release_date"
        case dedication, summary, wiki, chapters
    }
}

// MARK: - Chapter
struct Chapter: Codable {
    let title: String
}
