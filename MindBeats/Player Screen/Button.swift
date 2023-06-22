//
//  Button.swift
//  MindBeats
//
//  Created by Мурат Кудухов on 19.06.2023.
//

import UIKit

final class ButtonView: UIButton {
    
    
//    let startButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.tintColor = R.Colors.background
//
//        button.layer.cornerRadius = 5
//        return button
//    }()
    
    init(buttonImage: UIImage) {
        super.init(frame: .zero)
//        addSubview(startButton)
        setImage(buttonImage, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = R.Colors.background
        layer.cornerRadius = 5
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func constraints() {
//        NSLayoutConstraint.activate([
//            startButton.topAnchor.constraint(equalTo: topAnchor),
//            startButton.leadingAnchor.constraint(equalTo: leadingAnchor),
//            startButton.trailingAnchor.constraint(equalTo: trailingAnchor),
//            startButton.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//
//
//        ])
//    }
}


////
////  Button.swift
////  MindBeats
////
////  Created by Мурат Кудухов on 19.06.2023.
////
//
//import UIKit
//
//final class ButtonView: UIButton {
//
//
//    let startButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.tintColor = R.Colors.background
//
//        button.layer.cornerRadius = 5
//        return button
//    }()
//
//    init(buttonImage: UIImage) {
//        super.init(frame: .zero)
//        addSubview(startButton)
//        startButton.setImage(buttonImage, for: .normal)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func constraints() {
//        NSLayoutConstraint.activate([
//            startButton.topAnchor.constraint(equalTo: topAnchor),
//            startButton.leadingAnchor.constraint(equalTo: leadingAnchor),
//            startButton.trailingAnchor.constraint(equalTo: trailingAnchor),
//            startButton.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//
//
//        ])
//    }
//}
