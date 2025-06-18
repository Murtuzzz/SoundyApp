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
        button.tintColor = R.Colors.green
        
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


extension String {
    func localized() -> String {
        NSLocalizedString(self,tableName: "Localizable",bundle: .main, value: self, comment: self)
    }
}

extension UIButton {
    func makeSystem(_ button: UIButton) {
        button.addTarget(self, action: #selector(handleIn), for: [
            .touchDown,
            .touchDragInside
        ])
        
        button.addTarget(self, action: #selector(handleOut), for: [
            .touchDragOutside,
            .touchUpInside,
            .touchDragExit,
            .touchCancel,
            .touchUpOutside
        ])
    }
    
    @objc func handleIn() {
        UIView.animate(withDuration: 0.15) {self.alpha = 0.55}
        
    }
    
    @objc func handleOut() {
        UIView.animate(withDuration: 0.15) {self.alpha = 1}
        
    }
    
    // MARK: - Modern Button Animations
    @objc func handleButtonPress() {
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction]) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }
    }
    
    @objc func handleButtonRelease() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.allowUserInteraction]
        ) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}

// MARK: - Accessibility Extensions
extension UIView {
    func setupAccessibility(
        label: String,
        hint: String? = nil,
        traits: UIAccessibilityTraits = .none,
        value: String? = nil
    ) {
        isAccessibilityElement = true
        accessibilityLabel = label
        accessibilityHint = hint
        accessibilityTraits = traits
        accessibilityValue = value
    }
    
    func setupAccessibilityContainer() {
        isAccessibilityElement = false
        accessibilityElements = subviews.filter { $0.isAccessibilityElement }
    }
    
    func setupPlaybackAccessibility(isPlaying: Bool, trackName: String) {
        let action = isPlaying ? "Pause" : "Play"
        setupAccessibility(
            label: "\(action) \(trackName)",
            hint: "Double tap to \(action.lowercased()) this track",
            traits: .button
        )
    }
}



// MARK: - Animation Extensions
extension UIView {
    func pulseAnimation() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = Float.infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: "pulse")
    }
    
    func stopPulseAnimation() {
        layer.removeAnimation(forKey: "pulse")
    }
    
    func fadeInWithScale(duration: TimeInterval = 0.3, delay: TimeInterval = 0) {
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5
        ) {
            self.alpha = 1
            self.transform = .identity
        }
    }
    
    func shimmerEffect() {
        let light = UIColor.white.withAlphaComponent(0.3).cgColor
        let dark = UIColor.clear.cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.frame = CGRect(x: -bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.6)
        gradient.locations = [0.4, 0.5, 0.6]
        layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.5
        animation.repeatCount = Float.infinity
        gradient.add(animation, forKey: "shimmer")
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

// MARK: - UIColor Extensions
extension UIColor {
    var luminance: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return 0.299 * red + 0.587 * green + 0.114 * blue
    }
    
    var contrastingTextColor: UIColor {
        return luminance > 0.5 ? .black : .white
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    private func adjust(by percentage: CGFloat = 30.0) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                          green: min(green + percentage/100, 1.0),
                          blue: min(blue + percentage/100, 1.0),
                          alpha: alpha)
        } else {
            return self
        }
    }
}

// MARK: - Safe Area Extensions
extension UIViewController {
    var safeAreaTop: CGFloat {
        return view.safeAreaInsets.top
    }
    
    var safeAreaBottom: CGFloat {
        return view.safeAreaInsets.bottom
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
