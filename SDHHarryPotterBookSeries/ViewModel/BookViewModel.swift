//
//  BookViewModel.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/27/25.
//

import UIKit
import Combine

final class BookViewModel {
    
    private let dataService = DataService()
    private var books: [Book]?
    private var subscriptions = Set<AnyCancellable>()
    
    var selectedBookIndex: CurrentValueSubject<Int, Never>
    
    init(selectedBookIndex: Int) {
        self.selectedBookIndex = CurrentValueSubject(selectedBookIndex)
        loadBooks()
    }
    
    // MARK: - Data ➡️ Output
    
    var image: UIImage? {
        return BookImage.allCases[selectedBookIndex.value].image
    }
    
    var title: String {
        return books?[selectedBookIndex.value].attributes.title ?? "n/a"
    }
    
    var author: String {
        return books?[selectedBookIndex.value].attributes.author ?? "n/a"
    }
    
    var pages: Int {
        return books?[selectedBookIndex.value].attributes.pages ?? 0
    }
    
    var releaseDate: String {
        return books?[selectedBookIndex.value].attributes.releaseDate ?? "n/a"
    }
    
    var dedication: String {
        return books?[selectedBookIndex.value].attributes.dedication ?? "n/a"
    }
    
    var summary: String {
        return books?[selectedBookIndex.value].attributes.summary ?? "n/a"
    }
    
    var wiki: String {
        return books?[selectedBookIndex.value].attributes.wiki ?? "n/a"
    }
    
    // MARK: - User Action ➡️ Input
    
    
}

private extension BookViewModel {
    func loadBooks() {
        dataService.loadBooks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let books):
                self.books = books
                
            case .failure(let error):
                // TODO: Alert로 에러 알리는 창 구현
                self.books = nil
            }
        }
    }
}
