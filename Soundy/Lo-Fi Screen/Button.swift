//
//  Button.swift
//  MindBeats
//
//  Created by Мурат Кудухов on 19.06.2023.
//

import UIKit

// MARK: - Modern Button System
enum SoundyButtonStyle {
    case primary
    case secondary
    case ghost
    case destructive
    case fab(icon: UIImage)
    
    var configuration: SoundyButtonConfiguration {
        switch self {
        case .primary:
            return SoundyButtonConfiguration(
                backgroundColor: R.Colors.primary,
                foregroundColor: .white,
                cornerRadius: R.Layout.CornerRadius.lg,
                height: 48,
                font: R.Fonts.system(.body, weight: .semibold)
            )
        case .secondary:
            return SoundyButtonConfiguration(
                backgroundColor: .clear,
                foregroundColor: R.Colors.primary,
                borderColor: R.Colors.primary,
                borderWidth: R.Layout.BorderWidth.medium,
                cornerRadius: R.Layout.CornerRadius.lg,
                height: 48,
                font: R.Fonts.system(.body, weight: .medium)
            )
        case .ghost:
            return SoundyButtonConfiguration(
                backgroundColor: .black.withAlphaComponent(0.3),
                foregroundColor: .white,
                cornerRadius: R.Layout.CornerRadius.lg,
                height: 44,
                font: R.Fonts.system(.subheadline, weight: .medium)
            )
        case .destructive:
            return SoundyButtonConfiguration(
                backgroundColor: R.Colors.error,
                foregroundColor: .white,
                cornerRadius: R.Layout.CornerRadius.lg,
                height: 48,
                font: R.Fonts.system(.body, weight: .semibold)
            )
        case .fab(let icon):
            return SoundyButtonConfiguration(
                backgroundColor: R.Colors.accent,
                foregroundColor: .white,
                cornerRadius: 28,
                height: 56,
                width: 56,
                icon: icon,
                shadowRadius: 12,
                shadowOpacity: 0.3
            )
        }
    }
}

struct SoundyButtonConfiguration {
    let backgroundColor: UIColor
    let foregroundColor: UIColor
    let borderColor: UIColor?
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let height: CGFloat
    let width: CGFloat?
    let font: UIFont
    let icon: UIImage?
    let shadowRadius: CGFloat
    let shadowOpacity: Float
    
    init(
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0,
        cornerRadius: CGFloat = 0,
        height: CGFloat = 44,
        width: CGFloat? = nil,
        font: UIFont = R.Fonts.system(.body),
        icon: UIImage? = nil,
        shadowRadius: CGFloat = 0,
        shadowOpacity: Float = 0
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.height = height
        self.width = width
        self.font = font
        self.icon = icon
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
    }
}

class SoundyButton: UIButton {
    
    private let style: SoundyButtonStyle
    private var hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    init(_ style: SoundyButtonStyle) {
        self.style = style
        super.init(frame: .zero)
        setupButton()
        setupInteractions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        let config = style.configuration
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = config.backgroundColor
        setTitleColor(config.foregroundColor, for: .normal)
        titleLabel?.font = config.font
        layer.cornerRadius = config.cornerRadius
        
        // Border
        if let borderColor = config.borderColor {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = config.borderWidth
        }
        
        // Icon
        if let icon = config.icon {
            setImage(icon.withRenderingMode(.alwaysTemplate), for: .normal)
            tintColor = config.foregroundColor
        }
        
        // Shadow
        if config.shadowRadius > 0 {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = config.shadowRadius
            layer.shadowOpacity = config.shadowOpacity
        }
        
        // Constraints
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: config.height)
        ])
        
        if let width = config.width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    private func setupInteractions() {
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonPressed() {
        hapticFeedback.impactOccurred()
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction]) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }
    }
    
    @objc private func buttonReleased() {
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
    
    // MARK: - State Management
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.6
        }
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            let spinner = UIActivityIndicatorView(style: .white)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            addSubview(spinner)
            
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            
            spinner.startAnimating()
            titleLabel?.alpha = 0
            imageView?.alpha = 0
        } else {
            subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
            titleLabel?.alpha = 1
            imageView?.alpha = 1
        }
    }
}

// MARK: - Legacy Button Support
final class ButtonView: UIButton {
    
    init(buttonImage: UIImage? = nil, type: UIButton.ButtonType) {
        super.init(frame: .zero)
        setupLegacyButton(image: buttonImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLegacyButton(image: UIImage?) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let image = image {
            setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        backgroundColor = .black.withAlphaComponent(0.3)
        tintColor = .white
        layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 40),
            heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Добавляем современные анимации
        addTarget(self, action: #selector(animatePress), for: .touchDown)
        addTarget(self, action: #selector(animateRelease), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func animatePress() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.alpha = 0.7
        }
    }
    
    @objc private func animateRelease() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}
