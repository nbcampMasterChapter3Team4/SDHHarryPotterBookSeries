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
    
    var selectedBookIndex: Int
    private var books: [Book]?
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(selectedBookIndex: Int) {
        self.selectedBookIndex = selectedBookIndex
    }
    
    // MARK: - Data ➡️ Output
    
    /// Book 데이터 개수
    var bookCount = CurrentValueSubject<Int, Never>(0)
    /// 현재 표시하고 있는 Book
    var selectedBook = CurrentValueSubject<Book?, Never>(nil)
    /// Book 데이터 로드 중 에러 메세지
    var loadBookError = PassthroughSubject<String, Never>()
    
    /// Book 사진
    var image: UIImage? {
        return BookImageName.allCases[selectedBookIndex].image
    }
}

extension BookViewModel {
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                self.books = books
                bookCount.send(self.books?.count ?? 0)
                selectedBook.send(self.books?[selectedBookIndex])
                
            case .failure(let error):
                self.books = nil
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
