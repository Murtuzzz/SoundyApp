//
//  ChildComposerCollection.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 09.06.2023.
//

import UIKit
import AVFAudio

class NatureCollectionCell: UICollectionViewCell {
    
    static var id = "ChildComposerCollection"
    
    private var minTextBackgroundHeight: CGFloat = 35
    private var textBackgroundHeight: NSLayoutConstraint? = nil
    
    let musicList: [String] = ["RainSound","Waves","Forest","Fire","River","Thunder"]
    private var condition = true
    private var timer: Timer?
    private var activeTimer: Timer?
    private var inactiveTimer: Timer?
    private var cellIndex: Int = 0
    
    // MARK: - UI Components
    private let container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = R.Layout.CornerRadius.xl
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.backgroundCard
        
        // Modern shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.15
        
        return view
    }()

    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            R.Colors.primary.withAlphaComponent(0.8).cgColor,
            R.Colors.primaryDark.withAlphaComponent(0.6).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = R.Layout.CornerRadius.xl
        return gradient
    }()
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "waveform.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let textBackground: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = R.Layout.CornerRadius.md
        return view
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Nature Sound"
        label.textColor = .white
        label.textAlignment = .center
        label.font = R.Fonts.system(.subheadline, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.success
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.alpha = 0
        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupTimers()
        setupAccessibility()
        setupNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = false
        
        contentView.addSubview(container)
        //container.layer.insertSublayer(gradientLayer, at: 0)
        container.addSubview(myImageView)
        container.addSubview(textBackground)
        container.addSubview(mainLabel)
        container.addSubview(statusIndicator)
        
        // Add interaction
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        container.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: R.Layout.Spacing.sm),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: R.Layout.Spacing.sm),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -R.Layout.Spacing.sm),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -R.Layout.Spacing.sm),
            
            // Image
            myImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            myImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -10),
            myImageView.widthAnchor.constraint(equalToConstant: 30),
            myImageView.heightAnchor.constraint(equalToConstant: 30),
            
            // Text background
            textBackground.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: R.Layout.Spacing.md),
            textBackground.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -R.Layout.Spacing.md),
            textBackground.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -R.Layout.Spacing.md),
            
            // Label
            mainLabel.centerXAnchor.constraint(equalTo: textBackground.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: textBackground.centerYAnchor),
            mainLabel.leadingAnchor.constraint(greaterThanOrEqualTo: textBackground.leadingAnchor, constant: R.Layout.Spacing.sm),
            mainLabel.trailingAnchor.constraint(lessThanOrEqualTo: textBackground.trailingAnchor, constant: -R.Layout.Spacing.sm),
            
            // Status indicator
            statusIndicator.topAnchor.constraint(equalTo: container.topAnchor, constant: R.Layout.Spacing.sm),
            statusIndicator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -R.Layout.Spacing.sm),
            statusIndicator.widthAnchor.constraint(equalToConstant: 12),
            statusIndicator.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        // Initial text background height
        textBackgroundHeight = textBackground.heightAnchor.constraint(equalToConstant: minTextBackgroundHeight)
        textBackgroundHeight?.isActive = true
    }
    
    private func setupTimers() {
        // Таймеры больше не нужны для аудио - AudioManager управляет воспроизведением
        // Оставляем метод для совместимости, таймеры создаются в анимационных методах при необходимости
    }
    
    private func setupAccessibility() {
        container.setupAccessibility(
            label: "Nature sound",
            hint: "Double tap to play or pause",
            traits: .button
        )
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(audioStateChanged(_:)),
            name: .audioStateChanged,
            object: nil
        )
    }
    
    @objc private func audioStateChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let isPlaying = userInfo["isPlaying"] as? Bool,
              let trackIndex = userInfo["trackIndex"] as? Int,
              let category = userInfo["category"] as? String else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Проверяем только природные звуки и именно нашу ячейку
            if category == "nature" && trackIndex == self.cellIndex {
                if isPlaying {
                    self.animateToActiveState()
                    self.condition = false // Следующий тап будет stop
                } else {
                    self.animateToInactiveState()
                    self.condition = true // Следующий тап будет play
                }
            }
        }
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = container.bounds
    }
    
    // MARK: - Memory Management
    deinit {
        NotificationCenter.default.removeObserver(self)
        cleanupResources()
        print("NatureCollectionCell deinit")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanupAndReset()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview == nil {
            cleanupResources()
        }
    }
    
    private func cleanupResources() {
        timer?.invalidate()
        activeTimer?.invalidate()
        inactiveTimer?.invalidate()
        
        statusIndicator.stopPulseAnimation()
    }
    
    private func cleanupAndReset() {
        // Очищаем таймеры но НЕ останавливаем аудио
        timer?.invalidate()
        activeTimer?.invalidate()
        inactiveTimer?.invalidate()
        
        // Reset state - определяем текущее состояние из AudioManager
        let isCurrentlyPlaying = AudioManager.shared.isPlaying(trackIndex: cellIndex, category: "nature")
        condition = !isCurrentlyPlaying
        minTextBackgroundHeight = isCurrentlyPlaying ? 100 : 35
        
        // Reset UI based on current state
        myImageView.tintColor = .white
        statusIndicator.alpha = isCurrentlyPlaying ? 1 : 0
        
        if isCurrentlyPlaying {
            statusIndicator.pulseAnimation()
            transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } else {
            statusIndicator.stopPulseAnimation()
            transform = .identity
        }
        
        // Reset constraint
        if let heightConstraint = textBackgroundHeight {
            textBackground.removeConstraint(heightConstraint)
            textBackgroundHeight = nil
        }
        
        textBackgroundHeight = textBackground.heightAnchor.constraint(equalToConstant: minTextBackgroundHeight)
        textBackgroundHeight?.isActive = true
        
        // Adjust corner radius
        textBackground.layer.cornerRadius = isCurrentlyPlaying ? R.Layout.CornerRadius.lg : R.Layout.CornerRadius.md
    }
    

    
    // MARK: - Public Interface
    public func configure(label: String, image: UIImage, index: Int) {
        mainLabel.text = label
        myImageView.image = image.withRenderingMode(.alwaysTemplate)
        cellIndex = index
        
        // Check current state from AudioManager
        let isCurrentlyPlaying = AudioManager.shared.isPlaying(trackIndex: index, category: "nature")
        condition = !isCurrentlyPlaying
        
        // Update UI to match current state
        if isCurrentlyPlaying {
            animateToActiveState()
        } else {
            animateToInactiveState()
        }
        
        // Update accessibility
        container.setupAccessibility(
            label: "\(label) nature sound",
            hint: "Double tap to play or pause this sound",
            traits: .button
        )
    }
    
    @objc private func cellTapped() {
        let haptic = UIImpactFeedbackGenerator(style: .medium)
        haptic.impactOccurred()
        
        // Find index for this cell
        if let collectionView = superview as? UICollectionView,
           let indexPath = collectionView.indexPath(for: self) {
            changeCondition(indexPath.item)
        }
    }
    
    public func changeCondition(_ num: Int) {
        // Используем новый toggle API для поддержки множественного воспроизведения
        AudioManager.shared.toggleTrack(num, trackName: mainLabel.text ?? "", musicList: musicList, category: "nature")
    }
    

    
    // MARK: - Animations
    private func animateToActiveState() {
        activeTimer?.invalidate()
        activeTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            self?.cellActivateStep()
        }
        
        // Show status indicator
        UIView.animate(withDuration: 0.3) {
            self.statusIndicator.alpha = 1
        }
        
        statusIndicator.pulseAnimation()
        
        // Scale animation
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    private func animateToInactiveState() {
        inactiveTimer?.invalidate()
        inactiveTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            self?.cellDeactivateStep()
        }
        
        // Hide status indicator
        UIView.animate(withDuration: 0.3) {
            self.statusIndicator.alpha = 0
        }
        
        statusIndicator.stopPulseAnimation()
        
        // Scale animation
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.transform = .identity
        }
    }
    
    @objc private func cellActivateStep() {
        if minTextBackgroundHeight < 100 {
            textBackground.removeConstraint(textBackgroundHeight!)
            minTextBackgroundHeight += 3
            updateTextBackgroundHeight()
        } else {
            activeTimer?.invalidate()
            textBackground.layer.cornerRadius = R.Layout.CornerRadius.lg
        }
    }
    
    @objc private func cellDeactivateStep() {
        if minTextBackgroundHeight > 35 {
            textBackground.removeConstraint(textBackgroundHeight!)
            minTextBackgroundHeight -= 3
            updateTextBackgroundHeight()
        } else {
            inactiveTimer?.invalidate()
            textBackground.layer.cornerRadius = R.Layout.CornerRadius.md
        }
    }
    
    private func updateTextBackgroundHeight() {
        textBackgroundHeight = textBackground.heightAnchor.constraint(equalToConstant: minTextBackgroundHeight)
        textBackgroundHeight?.isActive = true
        
        UIView.animate(withDuration: 0.01) {
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Cell Animation
    func animateEntry(delay: TimeInterval = 0) {
        // Начальное состояние для анимации
        //alpha = 0
        //transform = CGAffineTransform(translationX: 0, y: 50).scaledBy(x: 0.8, y: 0.8)
        
        // Анимация появления
        UIView.animate(
            withDuration: 0.6,
            delay: delay,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut]
        ) {
            //self.alpha = 1
            //self.transform = .identity
        } completion: { _ in
            // Добавляем subtle bounce эффект
            //self.addSubtleBounce()
        }
    }
    
    private func addSubtleBounce() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: [.curveEaseInOut]
        ) {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } completion: { _ in
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.3,
                options: [.curveEaseOut]
            ) {
                self.transform = .identity
            }
        }
    }
}
