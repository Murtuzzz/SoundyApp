//
//  SectionHeaderView.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 08.06.2023.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    static let id = "SectionHeader"
    
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.Italic(with: 22)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.Italic(with: 18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        constraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        addViews()
        constraints()
    }
    
    func addViews() {
        addSubview(title)
        addSubview(subTitle)
    }
    
    func configure(header: String, desc: String) {
        title.text = header
        subTitle.text = desc
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
                    title.centerXAnchor.constraint(equalTo: centerXAnchor),
                    title.centerYAnchor.constraint(equalTo: centerYAnchor),
                    
                    subTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
                    subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: -10),
                    
                ])
    }
    
}
