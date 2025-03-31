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
    var selectedBookIndex: Int
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(selectedBookIndex: Int) {
        self.selectedBookIndex = selectedBookIndex
    }
    
    // MARK: - Data ➡️ Output
    
    var selectedBook = CurrentValueSubject<Book?, Never>(nil)
    var loadBookError = PassthroughSubject<String, Never>()
    
    var image: UIImage? {
        // 책 데이터가 로드 됐을때만 이미지 로드
        if selectedBook.value != nil {
            return BookImage.allCases[selectedBookIndex].image
        }
        
        return nil
    }
}

extension BookViewModel {
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                self.books = books
                selectedBook.send(books[selectedBookIndex])
                
            case .failure(let error):
                books = nil
                selectedBook.send(nil)
                
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
    func changeSelectedBook(to selectedBookIndex: Int) {
        self.selectedBookIndex = selectedBookIndex
        selectedBook.send(books?[selectedBookIndex])
    }
}
