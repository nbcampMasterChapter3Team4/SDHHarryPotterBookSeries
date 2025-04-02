//
//  BookViewController.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/24/25.
//

import UIKit
import Combine
import SnapKit

protocol SendIndexDelegate: AnyObject {
    func sendIndex(index: Int)
}

class BookViewController: UIViewController {
    
    // MARK: - Properties
    
    /*
     UX 고민 2
     - 마지막으로 본 Book의 Index 저장
     */
    private let currBookIndexKey = "currBookIndex"
    private var currBookIndex = 0 {
        didSet {
            viewModel.changeSelectedBook(to: currBookIndex)
            saveCurrBookIndex()
        }
    }
    
    private let viewModel = BookViewModel(selectedBookIndex: 0)
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    /// Book 제목 라벨
    private let bookTitlelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    /*
     UX 고민 1
     - Book 데이터 개수가 늘어났을 때 스크롤하여 볼 수 있도록 스크롤 뷰 생성
     */
    /// Book 시리즈 스크롤 뷰
    private let seriesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    /// Book 시리즈 스크롤 뷰의 컨텐츠 뷰
    private let seriesScrollContentView = UIView()
    
    /// Book 시리즈 영역
    private let seriesStackView = SeriesStackView()
    
    /// Book 데이터 스크롤 뷰
    private let bookScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    /// Book 데이터 스크롤 뷰의 컨텐츠 뷰
    private let bookScrollContentView = UIView()
    
    /// Book 정보 영역
    private let bookInfoStackView = BookInfoStackView()
    
    /// Dedication 영역
    private let bookDedicationStackView = BookDedicationStackView()
    
    /// Summary 영역
    private let bookSummaryStackView = BookSummaryStackView()
    
    /// Chapter 영역
    private let bookChapterStackView = BookChapterStackView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        seriesStackView.sendIndexDelegate = self
        
        setupUI()
        bind()
        // 뷰 모델의 데이터를 바인딩한 후 Book 데이터를 로드해야 오류 발생시 Alert가 정상적으로 표시됨
        viewModel.loadBooks()
        // 마지막으로 본 Book의 Index 불러옴
        loadCurrBookIndex()
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
            seriesScrollView,
            bookScrollView
        )
        
        // TODO: - 시리즈 가운데 정렬
        seriesScrollView.addSubview(seriesScrollContentView)
        seriesScrollContentView.addSubview(seriesStackView)
        
        bookScrollView.addSubview(bookScrollContentView)
        bookScrollContentView.addSubviews(
            bookInfoStackView,
            bookDedicationStackView,
            bookSummaryStackView,
            bookChapterStackView
        )
    }
    
    func setConstraints() {
        bookTitlelabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        seriesScrollView.snp.makeConstraints {
            $0.top.equalTo(bookTitlelabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        seriesScrollContentView.snp.makeConstraints {
            $0.edges.equalTo(seriesScrollView.contentLayoutGuide)
            $0.height.equalTo(seriesScrollView.frameLayoutGuide)
        }
        
        seriesStackView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        bookScrollView.snp.makeConstraints {
            $0.top.equalTo(seriesScrollView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        bookScrollContentView.snp.makeConstraints {
            $0.edges.equalTo(bookScrollView.contentLayoutGuide)
            $0.width.equalTo(bookScrollView.frameLayoutGuide)
        }
        
        bookInfoStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(5)
            $0.top.equalToSuperview().inset(32)
            $0.height.equalTo(150)
        }
        
        bookDedicationStackView.snp.makeConstraints {
            $0.top.equalTo(bookInfoStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        bookSummaryStackView.snp.makeConstraints {
            $0.top.equalTo(bookDedicationStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        bookChapterStackView.snp.makeConstraints {
            $0.top.equalTo(bookSummaryStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        // Level 6
        viewModel.bookCount
            .receive(on: RunLoop.main)
            .sink { [weak self] bookCount in
                guard let self else { return }
                updateSeriesUI(bookCount: bookCount)
                
                // Book 개수 변경 테스트 코드
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    self.updateSeriesUI(bookCount: 3)
//                }
            }.store(in: &subscriptions)
        
        viewModel.selectedBook
            .receive(on: RunLoop.main)
            .sink { [weak self] book in
                guard let self else { return }
                updateDataUI(with: book)
            }.store(in: &subscriptions)
        
        viewModel.loadBookError
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMsg in
                guard let self else { return }
                showErrorAlert(message: errorMsg)
            }.store(in: &subscriptions)
    }
    
    func updateSeriesUI(bookCount: Int) {
        seriesStackView.configure(bookCount: bookCount)
    }
    
    func updateDataUI(with book: Book?) {
        if let book = book?.attributes {
            // Level 1
            bookTitlelabel.text = book.title
            
            // Level 2
            let convertedDate = book.releaseDate.toDate()?.toString()
            bookInfoStackView.configure(
                image: viewModel.image,
                title: book.title,
                author: book.author,
                releaseDate: convertedDate ?? book.releaseDate,
                pages: String(book.pages)
            )
            
            // Level 3
            bookDedicationStackView.configure(dedication: book.dedication)
            bookSummaryStackView.configure(summary: book.summary)
            
            // Level 4
            bookChapterStackView.configure(chapters: book.chapters)
            
        } else {
            /*
             예외 처리 1
             - 데이터 없을 때 기본값 표시
             */
            let defaultValue = "N/A"
            let defaultChapter = Chapter(title: defaultValue)
            
            // Level 1
            bookTitlelabel.text = defaultValue
            
            // Level 2
            bookInfoStackView.configure(
                image: nil,
                title: defaultValue,
                author: defaultValue,
                releaseDate: defaultValue,
                pages: defaultValue
            )
            
            // Level 3
            bookDedicationStackView.configure(dedication: defaultValue)
            bookSummaryStackView.configure(summary: defaultValue)
            
            // Level 4
            bookChapterStackView.configure(chapters: [defaultChapter])
        }
    }
}

// MARK: - Private Methods

private extension BookViewController {
    /// Book 데이터 로드 중 발생한 에러 메세지를 Alert로 표시하는 메서드
    func showErrorAlert(message: String) {
        let sheet = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        present(sheet, animated: true)
    }
    
    /// UserDefaults ➡️ currBookIndex 값 로드
    func loadCurrBookIndex() {
        currBookIndex = UserDefaults.standard.integer(forKey: currBookIndexKey)
    }
    
    /// UserDefaults ⬅️ currBookIndex 값 저장
    func saveCurrBookIndex() {
        UserDefaults.standard.set(currBookIndex, forKey: currBookIndexKey)
    }
}

// MARK: - SendIndexDelegate

extension BookViewController: SendIndexDelegate {
    func sendIndex(index: Int) {
        currBookIndex = index
    }
}
