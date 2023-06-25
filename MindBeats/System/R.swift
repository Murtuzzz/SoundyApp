//
//  R.swift
//  MindBeats
//
//  Created by Мурат Кудухов on 17.06.2023.
//

import UIKit

enum R {
    enum Colors {
        static let greenBg = UIColor(hexString: "#63846a")
        static let green = UIColor(hexString: "#3c6138")
        static let sep = UIColor(hexString: "#2D344B")
        static let gray = UIColor(hexString: "#c9c9c9")
        static let active = UIColor(hexString: "#4870FF")
        static let bar = UIColor(hexString: "#8b5b3c")
        static let background = UIColor(hexString: "#f0f0f0")
        static let inactive = UIColor(hexString: "#E4C8A2")
        static let orange = UIColor(hexString: "#FF9C41")
        static let blueBG = UIColor(hexString: "#293447")
        
    }
    enum Images {
        static let moon = UIImage(named: "moon")
        static let music = UIImage(named: "music")
        static let profile = UIImage(named: "profile")
        static let allButton = UIImage(named: "dots")
        static let ambient = UIImage(named: "ambient")
        static let kids = UIImage(named: "kids")
        static let lock = UIImage(named: "lock")
        static let star = UIImage(named: "star")
        
    }
    
    enum Fonts {
        //        static func AbbZee(with size: CGFloat) -> UIFont {
        //            UIFont(name: "ABeeZee", size: size) ?? UIFont()
        static func Italic(with size: CGFloat) -> UIFont {
            UIFont(name: "GillSans-SemiBoldItalic", size: size) ?? UIFont()
            
            
        }
        static func nonItalic(with size: CGFloat) -> UIFont {
            UIFont(name: "GillSans-SemiBold", size: size) ?? UIFont()
        }
    }
}
