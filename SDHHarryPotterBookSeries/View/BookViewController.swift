//
//  BookViewController.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/24/25.
//

import UIKit
import Combine
import SnapKit

class BookViewController: UIViewController {
    
    // MVC 코드
//    private let dataService = DataService()
//    private var books: [Book]?
    
    private var currBookIndex = 0
    private var viewModel: BookViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let bookTitlelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let seriesButton: UIButton = {
        var config = UIButton.Configuration.filled()
        var titleAttr = AttributedString.init("1")
        titleAttr.font = .system(size: 16)
        config.attributedTitle = titleAttr
        config.titleAlignment = .center
        let button = UIButton(configuration: config)
        button.clipsToBounds = true
        
        return button
    }()

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        viewModel = BookViewModel(selectedBookIndex: currBookIndex)
        setupUI()
        bind()
        
        // MVC 코드
//        fetchBooksData()
//        setupBookData(index: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        seriesButton.layer.cornerRadius = seriesButton.frame.height / 2
    }
}

// MARK: - UI Methods

private extension BookViewController {
    func setupUI() {
        setViewHierarchy()
        setConstraints()
    }
    
    func setViewHierarchy() {
        view.addSubviews(bookTitlelabel, seriesButton)
    }
    
    func setConstraints() {
        bookTitlelabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        seriesButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
            make.top.equalTo(bookTitlelabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    // MVC 코드
//    func fetchBooksData() {
//        dataService.loadBooks { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(let books):
//                self.books = books
//                
//            case .failure(let error):
//                self.books = nil
//            }
//        }
//    }
    
//    func setupBookData(index: Int) {
//        guard let books = books else { return }
//        let currBook = books[index]
//        bookTitlelabel.text = currBook.attributes.title
//    }
    
    func bind() {
        viewModel.selectedBookIndex
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.bookTitlelabel.text = self?.viewModel.title
                self?.seriesButton.titleLabel?.text = String(((self?.currBookIndex ?? 0) + 1))
            }.store(in: &subscriptions)
    }
}

// MARK: - Private Methods

private extension BookViewController {
    
}
