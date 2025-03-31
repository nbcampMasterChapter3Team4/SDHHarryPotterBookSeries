//
//  BookViewModel.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/27/25.
//

import UIKit
import Combine

final class BookViewModel {
    
    // MARK: - Properties
    
    private let dataService = DataService()
    
    private var books: [Book]?
    var selectedBook: CurrentValueSubject<Book?, Never>
    var selectedBookIndex: Int
    var loadBookError = PassthroughSubject<String, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(selectedBookIndex: Int) {
        self.selectedBook = CurrentValueSubject(nil)
        self.selectedBookIndex = selectedBookIndex
        self.loadBooks()
    }
    
    // MARK: - Data ➡️ Output
    
    var image: UIImage? {
        if selectedBook.value != nil {
            return BookImage.allCases[selectedBookIndex].image
        }
        
        return nil
    }
    
    var title: String {
        return selectedBook.value?.attributes.title ?? "n/a"
    }
    
    var author: String {
        return selectedBook.value?.attributes.author ?? "n/a"
    }
    
    var pages: Int {
        return selectedBook.value?.attributes.pages ?? 0
    }
    
    var releaseDate: String {
        return selectedBook.value?.attributes.releaseDate ?? "n/a"
    }
    
    var dedication: String {
        return selectedBook.value?.attributes.dedication ?? "n/a"
    }
    
    var summary: String {
        return selectedBook.value?.attributes.summary ?? "n/a"
    }
    
    var wiki: String {
        return selectedBook.value?.attributes.wiki ?? "n/a"
    }
    
    // MARK: - User Action ➡️ Input
    
    
}

extension BookViewModel {
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                self.books = books
                selectedBook = CurrentValueSubject(books[selectedBookIndex])
                
            case .failure(let error):
                books = nil
                selectedBook = CurrentValueSubject(nil)
                
                let message: String
                if let dataError = error as? DataService.DataError {
                    switch dataError {
                    case .fileNotFound:
                        message = "데이터 파일을 찾을 수 없습니다."
                    case .parsingFailed:
                        message = "데이터를 불러오는 중 오류가 발생했습니다."
                    }
                } else {
                    message = error.localizedDescription
                }
                loadBookError.send(message)
            }
        }
    }
    
    /// 시리즈 버튼 눌렀을 때 selectedBook 변경
    func loadSelectedBook(selectedBookIndex: Int) {
        self.selectedBookIndex = selectedBookIndex
        selectedBook = CurrentValueSubject(books?[selectedBookIndex])
    }
}
