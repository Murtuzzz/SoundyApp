//
//  MusicHeaders.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 12.06.2023.
//

import UIKit

final class MusicHeaders: UIView {
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.avenirBook(with: 22)
        label.textColor = R.Colors.pink
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.avenir(with: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.5;
        label.layer.shadowRadius = 2.0;
        label.layer.shadowOffset = CGSizeMake(4, 4);
        return label
    }()
    
    init(header: String, desc: String) {
        super.init(frame: .zero)
        
        title.text = header
        subTitle.text = desc
     
        addSubview(title)
        addSubview(subTitle)
        addSubview(container)
        
      
        constraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        
        NSLayoutConstraint.activate([
            
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor),
            subTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            
        ])
        
    }
}
