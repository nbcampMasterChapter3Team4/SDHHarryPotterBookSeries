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
    
    /// 책 데이터 스크롤 뷰
    private let bookScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    /// 책 데이터 스크롤 뷰의 컨텐츠 뷰
    private let bookScrollContentView = UIView()
    
    /// 책 정보 영역
    private let bookInfoView = BookInfoView()
    
    /// Dedication 영역
    private let bookDedicationView = BookDedicationView()
    
    /// Summary 영역
    private let bookSummaryView = BookSummaryView()
    
    /// Chapter 영역
    private let bookChapterView = BookChapterView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        bind()
        // 뷰 모델의 데이터를 바인딩한 후 책 데이터를 로드해야 오류 발생시 Alert가 정상적으로 표시됨
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
            bookScrollView
        )
        
        bookScrollView.addSubviews(
            bookScrollContentView
        )
        
        bookScrollContentView.addSubviews(
            bookInfoView,
            bookDedicationView,
            bookSummaryView,
            bookChapterView
        )
    }
    
    func setConstraints() {
        let horizontalInset = 20
        let verticalOffset = 24
        
        bookTitlelabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(10)
            $0.leading.trailing.equalToSuperview().inset(horizontalInset)
        }
        
        seriesButton.snp.makeConstraints {
            $0.top.equalTo(bookTitlelabel.snp.bottom).offset(16)
            $0.leading.greaterThanOrEqualToSuperview().inset(horizontalInset)
            $0.trailing.lessThanOrEqualToSuperview().inset(horizontalInset)
            $0.width.height.equalTo(44)
            $0.centerX.equalToSuperview()
        }
        
        bookScrollView.snp.makeConstraints {
            $0.top.equalTo(seriesButton.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        bookScrollContentView.snp.makeConstraints {
            $0.edges.equalTo(bookScrollView.contentLayoutGuide)
            $0.width.equalTo(bookScrollView.frameLayoutGuide)
        }
        
        bookInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(150)
        }
        
        bookDedicationView.snp.makeConstraints {
            $0.top.equalTo(bookInfoView.snp.bottom).offset(verticalOffset)
            $0.leading.trailing.equalToSuperview().inset(horizontalInset)
        }
        
        bookSummaryView.snp.makeConstraints {
            $0.top.equalTo(bookDedicationView.snp.bottom).offset(verticalOffset)
            $0.leading.trailing.equalToSuperview().inset(horizontalInset)
        }
        
        bookChapterView.snp.makeConstraints {
            $0.top.equalTo(bookSummaryView.snp.bottom).offset(verticalOffset)
            $0.leading.trailing.equalToSuperview().inset(horizontalInset)
            $0.bottom.equalToSuperview()
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
        if let book = book?.attributes {
            // Level 1
            bookTitlelabel.text = book.title
            seriesButton.configuration?.title = String(1)
            
            // Level 2
            let convertedDate = book.releaseDate.toDate()?.toString()
            bookInfoView.configure(
                image: viewModel.image,
                title: book.title,
                author: book.author,
                releaseDate: convertedDate ?? book.releaseDate,
                pages: String(book.pages)
            )
            
            // Level 3
            bookDedicationView.configure(dedication: book.dedication)
            bookSummaryView.configure(summary: book.summary)
            
            // Level 4
            bookChapterView.configure(chapters: book.chapters)
            
        } else {
            // 예외 처리 1
            // - 데이터 없을 때 기본값 표시
            let defaultValue = "N/A"
            let defaultChapter = Chapter(title: defaultValue)
            
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
            
            // Level 4
            bookChapterView.configure(chapters: [defaultChapter])
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
