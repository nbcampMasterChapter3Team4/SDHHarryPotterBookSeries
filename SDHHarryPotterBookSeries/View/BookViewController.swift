//
//  BookViewController.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/24/25.
//

import UIKit
import SnapKit

class BookViewController: UIViewController {
    
    private let dataService = DataService()
    private var books: [Book]?
    
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
        
        setupUI()
        fetchBooksData()
        setupBookData(index: 0)
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
        view.addSubview(bookTitlelabel)
        view.addSubview(seriesButton)
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
    
    func fetchBooksData() {
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
    
    func setupBookData(index: Int) {
        guard let books = books else { return }
        let currBook = books[index]
        bookTitlelabel.text = currBook.attributes.title
    }
}

// MARK: - Private Methods

private extension BookViewController {
    
}
