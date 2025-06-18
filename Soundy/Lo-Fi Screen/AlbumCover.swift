//
//  AlbumView.swift
//  MindBeats
//
//  Created by Мурат Кудухов on 17.06.2023.
//

import UIKit

final class AlbumCover: UIView {
    
    var rotationAngle: CGFloat = 0.0
    
//    private let container: UIView = {
//        let view = UIView()
//        //view.layer.cornerRadius = 40
//        view.backgroundColor = .red
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    private let circle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = R.Colors.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let circleBig: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.backgroundColor = .black
        view.alpha = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "PurpleDream")
        view.layer.borderWidth = 1
        view.layer.borderColor = R.Colors.bar.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addSubview(container)
        addSubview(imageView)
        addSubview(circleBig)
        addSubview(circle)
        constraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func constraints() {
        NSLayoutConstraint.activate([
//            container.topAnchor.constraint(equalTo: topAnchor),
//            container.leadingAnchor.constraint(equalTo: leadingAnchor),
//            container.trailingAnchor.constraint(equalTo: trailingAnchor),
//            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
           // imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
           // imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            imageView.heightAnchor.constraint(equalToConstant: 300),
//            imageView.widthAnchor.constraint(equalToConstant: 300),
            
            circle.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            circle.heightAnchor.constraint(equalToConstant: 30),
            circle.widthAnchor.constraint(equalToConstant: 30),
            
            circleBig.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            circleBig.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            circleBig.heightAnchor.constraint(equalToConstant: 90),
            circleBig.widthAnchor.constraint(equalToConstant: 90),
        
        
        ])
    }
}

