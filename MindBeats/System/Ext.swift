//
//  Ext.swift
//  MindBeats
//
//  Created by Мурат Кудухов on 20.06.2023.
//

import UIKit

enum NavBarPosition {
    case left
    case right
}

extension UIViewController {
    
    func addNavBarButton(at position: NavBarPosition, with title: String? = nil, and image: UIImage? = nil) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = R.Colors.background
        
        button.titleLabel?.font = R.Fonts.Italic(with: 20)
        
        switch position {
        case .left:
            button.addTarget(self, action: #selector(navBarLeftButtonHandler), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        case .right:
            button.addTarget(self, action: #selector(navBarRightButtonHandler), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
    func setTitleForNavBarButton(_ title: String, at position: NavBarPosition) {
        switch position {
        case .left:
            (navigationItem.leftBarButtonItem?.customView as? UIButton)?.setTitle(title, for: .normal)
        case .right:
            (navigationItem.rightBarButtonItem?.customView as? UIButton)?.setTitle(title, for: .normal)
        }
    }
    
    @objc func navBarLeftButtonHandler() {
        print("NavBar left button tapped")
    }
    @objc func navBarRightButtonHandler() {
        print("NavBar right button tapped")
    }
}

