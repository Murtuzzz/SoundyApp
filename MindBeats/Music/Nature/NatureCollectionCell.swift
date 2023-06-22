//
//  ChildComposerCollection.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 09.06.2023.
//

import UIKit

class NatureCollectionCell: UICollectionViewCell {
    
    static var id = "ChildComposerCollection"
    
    private let container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let textBackground: UIView = {
        let view = UIImageView()
        view.backgroundColor = R.Colors.sep
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Album"
        label.textColor = .white
        label.textAlignment = .left
        label.font = R.Fonts.Italic(with: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(container)
        contentView.addSubview(textBackground)
        contentView.addSubview(myImageView)
        contentView.addSubview(mainLabel)
       
        
        
       // contentView.backgroundColor = R.Colors.background
        contentView.clipsToBounds = true
        constraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    public func configure(label: String, image: UIImage, condition: UIColor) {
        mainLabel.text = label
        myImageView.image = image
        container.backgroundColor = condition
        
        
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
                    container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                    container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                    container.centerYAnchor.constraint(equalTo: centerYAnchor),
                    container.heightAnchor.constraint(equalToConstant: 125),
//                    container.widthAnchor.constraint(equalToConstant: 100),
                    
                    textBackground.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    textBackground.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    textBackground.topAnchor.constraint(equalTo: container.topAnchor, constant: 100),
//                    textBackground.heightAnchor.constraint(equalToConstant: 10),
                    textBackground.heightAnchor.constraint(equalToConstant: 35),
                    
                    
                    mainLabel.centerYAnchor.constraint(equalTo: textBackground.centerYAnchor),
                    mainLabel.centerXAnchor.constraint(equalTo: textBackground.centerXAnchor),
////
                    
                    myImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
                    myImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    
                ])
    }
    
}
