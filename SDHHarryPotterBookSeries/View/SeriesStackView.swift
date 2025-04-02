//
//  SeriesStackView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 4/2/25.
//

import UIKit
import SnapKit

final class SeriesStackView: UIStackView {
    
    // MARK: - Properties
    
    weak var sendIndexDelegate: SendIndexDelegate?
    var selectedBookIndex = 0
    
    let selectedButtonColor = (
        titleColor: UIColor.white,
        backgroundColor: UIColor.tintColor
    )
    let normalButtonColor = (
        titleColor: UIColor.tintColor,
        backgroundColor: UIColor.systemGray5.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
    )
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.spacing = 10
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let subviews = self.arrangedSubviews
        subviews.forEach { subview in
            subview.snp.makeConstraints { $0.width.height.equalTo(40) }
            subview.layer.cornerRadius = subview.frame.height / 2
        }
    }
    
    // MARK: - Update UI
    
    func configure(bookCount: Int) {
        if bookCount > 0 {
            removeSeriesButtons()
            
            // arrangedSubView로 시리즈 버튼 추가
            for index in 0..<bookCount {
                let seriesButton = makeSeriesButton(title: String(index + 1))
                if seriesButton.tag - 1 == selectedBookIndex {
                    seriesButton.setTitleColor(selectedButtonColor.titleColor, for: .normal)
                    seriesButton.backgroundColor = selectedButtonColor.backgroundColor
                }
                self.addArrangedSubview(seriesButton)
            }
        } else {
            /*
             예외 처리 2
             - 데이터 로드 실패 시 dummy 시리즈 버튼 추가
             */
            removeSeriesButtons()
            
            // 기본 버튼 추가
            let defaultButton = makeSeriesButton(title: "0")
            self.addArrangedSubview(defaultButton)
        }
    }
}

// MARK: - UI Methods

private extension SeriesStackView {
    func makeSeriesButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(normalButtonColor.titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.clipsToBounds = true
        button.backgroundColor = normalButtonColor.backgroundColor
        
        if title != "0" {  // 기본 버튼이 아닐 때
            button.tag = Int(title) ?? 0
            button.addTarget(self, action: #selector(seriesButtonTarget), for: .touchUpInside)
        }
        
        return button
    }
    
    /// stackView에서 기존 arrangedSubView들 삭제
    func removeSeriesButtons() {
        let oldSubviews = self.subviews
        self.arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
        }
        // 뷰 보임 방지 및 메모리 해제
        oldSubviews.forEach { $0.removeFromSuperview() }
    }
    
    /// UIButton의 tag(=title) - 1을 보냄
    @objc func seriesButtonTarget(sender: UIButton) {
        sendIndexDelegate?.sendIndex(index: sender.tag - 1)
        
        for subview in self.arrangedSubviews {
            if let button = subview as? UIButton {
                button.setTitleColor(normalButtonColor.titleColor, for: .normal)
                button.backgroundColor = normalButtonColor.backgroundColor
            }
        }
        sender.setTitleColor(selectedButtonColor.titleColor, for: .normal)
        sender.backgroundColor = selectedButtonColor.backgroundColor
    }
}
