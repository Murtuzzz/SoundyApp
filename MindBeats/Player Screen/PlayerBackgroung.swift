//
//  PlayerBackgroung.swift
//  MindBeats
//
//  Created by Мурат Кудухов on 22.06.2023.
//

import UIKit

final class PlayerBackground: UIView {
    
    private let albumView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(albumView)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            albumView.leadingAnchor.constraint(equalTo: leadingAnchor),
            albumView.trailingAnchor.constraint(equalTo: trailingAnchor),
            albumView.topAnchor.constraint(equalTo: topAnchor),
            albumView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
