//
//  AnimalCell.swift
//  Soundy
//
//  Created by Мурат Кудухов on 09.06.2023.
//

import UIKit
import AVFAudio

class AnimalCollectionCell: UICollectionViewCell {
    
    static var id = "AnimalCollectionCell"
    
    private var minTextBackgroundHeight: CGFloat = 35
    private var textBackgroundHeight: NSLayoutConstraint? = nil
    
    private var player = AVAudioPlayer()
    let musicList: [String] = ["birds", "Cat","Frogs","Owl"]
    private var condition = true
    private var timer: Timer?
    private var activeTimer: Timer?
    private var inactiveTimer: Timer?
    private var isPlaying = false
    private var cellIndex: Int = -1
    
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
            R.Colors.accent.withAlphaComponent(0.8).cgColor,
            R.Colors.accentDark.withAlphaComponent(0.6).cgColor
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
        view.backgroundColor = R.Colors.accent
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = R.Layout.CornerRadius.md
        return view
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Animal Sound"
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
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(soundRepeat), userInfo: nil, repeats: true)
    }
    
    private func setupAccessibility() {
        container.setupAccessibility(
            label: "Animal sound",
            hint: "Double tap to play or pause",
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
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = container.bounds
    }
    
    // MARK: - Memory Management
    deinit {
        cleanupResources()
        print("AnimalCollectionCell deinit")
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
        
        player.stop()
        player.delegate = nil
        
        statusIndicator.stopPulseAnimation()
    }
    
    private func cleanupAndReset() {
        // НЕ вызываем cleanupResources, чтобы не останавливать активный плеер
        
        // Проверяем, играет ли сейчас трек
        let shouldPreserveState = isPlaying && player.isPlaying
        
        if !shouldPreserveState {
            // Только если трек не играет, сбрасываем состояние
            cleanupResources()
            condition = true
            isPlaying = false
            minTextBackgroundHeight = 35
            
            // Reset UI
            myImageView.tintColor = .white
            statusIndicator.alpha = 0
            statusIndicator.stopPulseAnimation()
        }
        
        // Reset constraint в любом случае
        if let heightConstraint = textBackgroundHeight {
            textBackground.removeConstraint(heightConstraint)
            textBackgroundHeight = nil
        }
        
        textBackgroundHeight = textBackground.heightAnchor.constraint(equalToConstant: shouldPreserveState ? 100 : 35)
        textBackgroundHeight?.isActive = true
    }
    
    // MARK: - Audio Management
    @objc func soundRepeat() {
        guard isPlaying else { return }
        
        if Int(player.currentTime) == Int(player.duration) - 1 {
            player.currentTime = 1
            player.play()
        }
    }
    
    // MARK: - Public Interface
    public func configure(label: String, image: UIImage, index: Int) {
        mainLabel.text = label
        myImageView.image = image.withRenderingMode(.alwaysTemplate)
        cellIndex = index
        
        // Проверяем, играет ли сейчас этот трек
        let shouldBeActive = isPlaying && player.isPlaying
        if shouldBeActive {
            condition = false // Означает что следующий тап будет stop
            animateToActiveState()
        } else {
            condition = true // Означает что следующий тап будет play
            animateToInactiveState()
        }
        
        // Update accessibility
        container.setupAccessibility(
            label: "\(label) animal sound",
            hint: "Double tap to play or pause this sound",
            traits: .button
        )
    }
    
    public func changeCondition(_ num: Int) {
        if condition {
            // Start playing
            startPlaying(num)
        } else {
            // Stop playing
            stopPlaying()
        }
        condition.toggle()
    }
    
    private func startPlaying(_ num: Int) {
        isPlaying = true
        createPlayer(num)
        player.play()
        
        // Update UI
        animateToActiveState()
        
        // Update accessibility
        container.setupPlaybackAccessibility(isPlaying: true, trackName: mainLabel.text ?? "")
    }
    
    private func stopPlaying() {
        isPlaying = false
            player.stop()
        
        // Update UI
        animateToInactiveState()
        
        // Update accessibility
        container.setupPlaybackAccessibility(isPlaying: false, trackName: mainLabel.text ?? "")
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
    
    func createPlayer(_ num: Int) {
        // Останавливаем предыдущий плеер если есть
            player.stop()
        
        guard num < musicList.count else {
            print("❌ Error: Invalid music index \(num), musicList count: \(musicList.count)")
            return
        }
        
        guard let audioPath = Bundle.main.path(forResource: musicList[num], ofType: "mp3") else {
            print("❌ Error: Audio file '\(musicList[num]).mp3' not found in bundle")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            player.numberOfLoops = -1 // Бесконечное повторение
            player.prepareToPlay()
            print("✅ Audio player created successfully for: \(musicList[num])")
        } catch {
            print("❌ Error creating audio player: \(error.localizedDescription)")
        }
    }
    
    public func startPlayer() {
        player.play()
    }
    
    public func stopPlayer() {
        condition = true
            myImageView.tintColor = .white
            player.stop()
        
        // Update UI state
        animateToInactiveState()
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
