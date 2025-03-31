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
    
    // MARK: - Properties
    
    private var currBookIndex = 0
    private let viewModel = BookViewModel(selectedBookIndex: 0)
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    /// 책 제목 라벨
    private let bookTitlelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 책 시리즈 버튼
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
    
    /// 책 정보 영역
    private let bookInfoView = BookInfoView()
    
    /// Dedication 영역
    private let bookDedicationView = BookDedicationView()
    
    /// Summary 영역
    private let bookSummaryView = BookSummaryView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        bind()
        viewModel.loadBooks()
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
        self.view.addSubviews(
            bookTitlelabel,
            seriesButton,
            bookInfoView,
            bookDedicationView,
            bookSummaryView
        )
    }
    
    func setConstraints() {
        bookTitlelabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        seriesButton.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.top.equalTo(bookTitlelabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        bookInfoView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(5)
            $0.top.equalTo(seriesButton.snp.bottom).offset(32)
            $0.height.equalTo(150)
        }
        
        bookDedicationView.snp.makeConstraints {
            $0.top.equalTo(bookInfoView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        bookSummaryView.snp.makeConstraints {
            $0.top.equalTo(bookDedicationView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func bind() {
        viewModel.selectedBook
            .receive(on: RunLoop.main)
            .sink { [weak self] book in
                guard let self = self else { return }
                updateUI(with: book)
            }.store(in: &subscriptions)
        
        viewModel.loadBookError
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMsg in
                guard let self = self else { return }
                showErrorAlert(message: errorMsg)
            }.store(in: &subscriptions)
    }
    
    func updateUI(with book: Book?) {
        if let book = book {
            // Level 1
            bookTitlelabel.text = book.attributes.title
            seriesButton.titleLabel?.text = String(1)
            
            // Level 2
            let convertedDate = book.attributes.releaseDate.toDate()?.toString()
            bookInfoView.configure(
                image: viewModel.image,
                title: book.attributes.title,
                author: book.attributes.author,
                releaseDate: convertedDate ?? book.attributes.releaseDate,
                pages: String(book.attributes.pages)
            )
            
            // Level 3
            bookDedicationView.configure(dedication: book.attributes.dedication)
            bookSummaryView.configure(summary: book.attributes.summary)
        } else {
            // 예외 처리 1
            // - 데이터 없을 때 기본값 표시
            let defaultValue = "N/A"
            
            // Level 1
            bookTitlelabel.text = defaultValue
            seriesButton.titleLabel?.text = String(1)
            
            // Level 2
            bookInfoView.configure(
                image: nil,
                title: defaultValue,
                author: defaultValue,
                releaseDate: defaultValue,
                pages: defaultValue
            )
            
            // Level 3
            bookDedicationView.configure(dedication: defaultValue)
            bookSummaryView.configure(summary: defaultValue)
        }
    }
}

// MARK: - Private Methods

private extension BookViewController {
    func showErrorAlert(message: String) {
        let sheet = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        present(sheet, animated: true)
    }
}
