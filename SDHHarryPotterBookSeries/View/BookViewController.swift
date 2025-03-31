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
    private var viewModel = BookViewModel(selectedBookIndex: 0)
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    // 책 제목 라벨
    private let bookTitlelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    // 책 시리즈 버튼
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
    
    // 책 정보 영역
    private let bookInfoView = BookInfoView()
    
    // Dedication & Summary 영역
    private let bookDedAndSumView = BookDedAndSumView()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        bind()
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
        self.view.addSubviews(bookTitlelabel, seriesButton, bookInfoView)
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
    }
    
    func bind() {
        viewModel.selectedBook
            .receive(on: RunLoop.main)
            .sink { [weak self] book in
                self?.updateUI(with: book)
            }.store(in: &subscriptions)
        
        viewModel.loadBookError
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMsg in
                self?.showErrorAlert(message: errorMsg)
            }.store(in: &subscriptions)
    }
    
    func updateUI(with book: Book?) {
//        let bookSeries = index + 1
        
        // Level 1
        bookTitlelabel.text = viewModel.title
        seriesButton.titleLabel?.text = String(1)
        
        // Level 2
        bookInfoView.bookImageView.image = viewModel.image
        bookInfoView.infoTitleLabel.text = viewModel.title
        bookInfoView.authorLabel.text = viewModel.author
        let releaseDate = viewModel.releaseDate.toDate()?.toString()
        bookInfoView.releasedLabel.text = releaseDate
        bookInfoView.pagesLabel.text = String(viewModel.pages)
        
        // Level 3
        
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
