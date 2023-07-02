//
//  MusicHeaders.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 12.06.2023.
//

import UIKit

final class MusicHeaders: UIView {
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.Italic(with: 22)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.layer.shadowColor = UIColor.black.cgColor
//        label.layer.shadowOpacity = 1.0;
//        label.layer.shadowRadius = 1.0;
//        label.layer.shadowOffset = CGSizeMake(4, 4);
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.Italic(with: 18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
      
        constraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        
        NSLayoutConstraint.activate([
            
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor),
            subTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
            
        ])
        
    }
}
