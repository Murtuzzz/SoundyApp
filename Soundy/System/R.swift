//
//  R.swift
//  MindBeats
//
//  Created by Мурат Кудухов on 17.06.2023.
//

import UIKit

enum R {
    enum Colors {
        // MARK: - Primary Colors
        static let primary = UIColor(hexString: "#5A32C9")
        static let primaryLight = UIColor(hexString: "#7C4CFF")
        static let primaryDark = UIColor.clear//UIColor(hexString: "#4A2AA8")
        
        // MARK: - Semantic Colors
        static let success = UIColor(hexString: "#34D399")
        static let warning = UIColor(hexString: "#FBBF24")
        static let error = UIColor(hexString: "#F87171")
        static let info = UIColor(hexString: "#60A5FA")
        
        // MARK: - Background Hierarchy
        static let backgroundPrimary = UIColor(hexString: "#1A1A1A")
        static let backgroundSecondary = UIColor(hexString: "#2D2D2D")
        static let backgroundTertiary = UIColor(hexString: "#404040")
        static let backgroundCard = UIColor(hexString: "#2A2A2A")
        
        // MARK: - Text Hierarchy
        static let textPrimary = UIColor.white
        static let textSecondary = UIColor(hexString: "#B3B3B3")
        static let textTertiary = UIColor(hexString: "#808080")
        static let textDisabled = UIColor(hexString: "#555555")
        
        // MARK: - Legacy Colors (для совместимости)
        static let greenBg = UIColor(hexString: "#63846a")
        static let green = UIColor(hexString: "#3c6138")
        static let sep = UIColor(hexString: "#2D344B")
        static let gray = UIColor(hexString: "#c9c9c9")
        static let active = UIColor(hexString: "#4870FF")
        static let bar = UIColor(hexString: "#8b5b3c")
        static let background = UIColor(hexString: "#f0f0f0")
        static let inactive = UIColor(hexString: "#E4C8A2")
        static let orange = UIColor(hexString: "#FF9C41")
        static let darkBackground = UIColor(hexString: "#020825")
        static let blueBG = UIColor(hexString: "#201E46")
        static let pink = UIColor(hexString: "#7C4CFF")
        static let purple = UIColor(hexString: "#5A32C9")
        static let barBg = UIColor(hexString: "#252627")
        
        // MARK: - Accent Colors
        static let accent = UIColor(hexString: "#FF6B6B")
        static let accentLight = UIColor(hexString: "#FF8E8E")
        static let accentDark = UIColor.clear//UIColor(hexString: "#E55555")
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
        enum Weight {
            case light, regular, medium, semibold, bold
        }
        
        enum Size {
            case caption, body, subheadline, headline, title, largeTitle
            
            var value: CGFloat {
                switch self {
                case .caption: return 12
                case .body: return 16
                case .subheadline: return 15
                case .headline: return 18
                case .title: return 24
                case .largeTitle: return 34
                }
            }
        }
        
        // MARK: - Modern Typography System
        static func system(_ size: Size, weight: Weight = .regular) -> UIFont {
            let systemWeight: UIFont.Weight
            switch weight {
            case .light: systemWeight = .light
            case .regular: systemWeight = .regular
            case .medium: systemWeight = .medium
            case .semibold: systemWeight = .semibold
            case .bold: systemWeight = .bold
            }
            return UIFont.systemFont(ofSize: size.value, weight: systemWeight)
        }
        
        // MARK: - Legacy Fonts (для совместимости)
        static func Italic(with size: CGFloat) -> UIFont {
            UIFont(name: "GillSans-SemiBoldItalic", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        
        static func nonItalic(with size: CGFloat) -> UIFont {
            UIFont(name: "GillSans-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        
        static func avenir(with size: CGFloat) -> UIFont {
            UIFont(name: "AvenirNext-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        }
        
        static func avenirItalic(with size: CGFloat) -> UIFont {
            UIFont(name: "AvenirNext-MediumItalic", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        }
        
        static func avenirBook(with size: CGFloat) -> UIFont {
            UIFont(name: "Avenir-Book", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
    
    // MARK: - Layout Constants
    enum Layout {
        enum Spacing {
            static let xs: CGFloat = 4
            static let sm: CGFloat = 8
            static let md: CGFloat = 16
            static let lg: CGFloat = 24
            static let xl: CGFloat = 32
            static let xxl: CGFloat = 48
        }
        
        enum CornerRadius {
            static let sm: CGFloat = 8
            static let md: CGFloat = 12
            static let lg: CGFloat = 20
            static let xl: CGFloat = 24
            static let xxl: CGFloat = 32
            static let round: CGFloat = 50
        }
        
        enum BorderWidth {
            static let thin: CGFloat = 1
            static let medium: CGFloat = 2
            static let thick: CGFloat = 4
        }
    }
}
