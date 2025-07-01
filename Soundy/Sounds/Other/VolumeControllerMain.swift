//
//  VolumeControllerMain.swift
//  Soundy
//
//  Created by Assistant on 18.01.2025.
//

import UIKit
import AVFoundation

class VolumeControllerMain: UIViewController {
    
    // MARK: - Properties
    private var activeTracks: [(category: String, index: Int, name: String, volume: Float)] = []
    private var volumeSliders: [UISlider] = []
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.darkBackground
        view.layer.cornerRadius = R.Layout.CornerRadius.xl
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.backgroundCard.withAlphaComponent(0.5)
        view.layer.cornerRadius = R.Layout.CornerRadius.lg
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Volume Control".localized()
        label.font = R.Fonts.avenirBook(with: 24)
        label.textColor = R.Colors.pink
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Adjust volume for active sounds".localized()
        label.font = R.Fonts.avenir(with: 16)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = R.Colors.pink
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.slash.circle")
        imageView.tintColor = .white.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No active sounds".localized()
        label.font = R.Fonts.avenir(with: 18)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadActiveTracks()
        setupNotifications()
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshActiveTracks()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        view.addSubview(containerView)
        containerView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        headerView.addSubview(closeButton)
        
        containerView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        containerView.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.8),
            
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -16),
            
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            emptyStateView.heightAnchor.constraint(equalToConstant: 150),
            
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor, constant: 20),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 60),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 60),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 16),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 16),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(audioStateChanged),
            name: .audioStateChanged,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(allAudioStopped),
            name: .allAudioStopped,
            object: nil
        )
    }
    
    // MARK: - Data Loading
    private func loadActiveTracks() {
        let activeTracks = AudioManager.shared.getActiveTracks()
        
        if activeTracks.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
            createVolumeControls(for: activeTracks)
        }
    }
    
    private func createVolumeControls(for tracks: [(category: String, index: Int)]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        volumeSliders.removeAll()
        activeTracks.removeAll()
        
        for track in tracks {
            let trackName = AudioManager.shared.getTrackName(for: track.index, category: track.category)
            let currentVolume = AudioManager.shared.getVolume(for: track.index, category: track.category)
            
            activeTracks.append((
                category: track.category,
                index: track.index,
                name: trackName,
                volume: currentVolume
            ))
            
            let volumeControlView = createVolumeControlView(
                trackName: trackName,
                category: track.category,
                index: track.index,
                currentVolume: currentVolume
            )
            
            stackView.addArrangedSubview(volumeControlView)
        }
    }
    
    private func createVolumeControlView(trackName: String, category: String, index: Int, currentVolume: Float) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = R.Colors.backgroundCard.withAlphaComponent(0.6)
        containerView.layer.cornerRadius = R.Layout.CornerRadius.lg
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = getTrackIcon(category: category)
        iconImageView.tintColor = getCategoryColor(category: category)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = trackName
        nameLabel.font = R.Fonts.avenirBook(with: 16)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let categoryLabel = UILabel()
        categoryLabel.text = category.capitalized
        categoryLabel.font = R.Fonts.avenir(with: 12)
        categoryLabel.textColor = getCategoryColor(category: category)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let volumeSlider = UISlider()
        volumeSlider.minimumValue = 0.0
        volumeSlider.maximumValue = 1.0
        volumeSlider.value = currentVolume
        volumeSlider.tintColor = getCategoryColor(category: category)
        volumeSlider.thumbTintColor = .white
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        let volumeValueLabel = UILabel()
        volumeValueLabel.text = "\(Int(currentVolume * 100))%"
        volumeValueLabel.font = R.Fonts.system(.caption, weight: .medium)
        volumeValueLabel.textColor = .white.withAlphaComponent(0.8)
        volumeValueLabel.textAlignment = .right
        volumeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        volumeSlider.addTarget(self, action: #selector(volumeSliderChanged(_:)), for: .valueChanged)
        volumeSlider.tag = volumeSliders.count
        volumeSliders.append(volumeSlider)
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(volumeSlider)
        containerView.addSubview(volumeValueLabel)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 80),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: volumeValueLabel.leadingAnchor, constant: -8),
            
            categoryLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            categoryLabel.trailingAnchor.constraint(equalTo: volumeValueLabel.leadingAnchor, constant: -8),
            
            volumeSlider.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            volumeSlider.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            volumeSlider.trailingAnchor.constraint(equalTo: volumeValueLabel.leadingAnchor, constant: -8),
            
            volumeValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            volumeValueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            volumeValueLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        return containerView
    }
    
    // MARK: - Actions
    @objc private func volumeSliderChanged(_ slider: UISlider) {
        let trackIndex = slider.tag
        guard trackIndex < activeTracks.count else { return }
        
        let track = activeTracks[trackIndex]
        let newVolume = slider.value
        
        AudioManager.shared.setVolume(newVolume, for: track.index, category: track.category)
        
        if let containerView = slider.superview,
           let volumeLabel = containerView.subviews.compactMap({ $0 as? UILabel }).last {
            volumeLabel.text = "\(Int(newVolume * 100))%"
        }
        
        activeTracks[trackIndex].volume = newVolume
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    @objc private func audioStateChanged(_ notification: Notification) {
        DispatchQueue.main.async {
            self.refreshActiveTracks()
        }
    }
    
    @objc private func allAudioStopped(_ notification: Notification) {
        DispatchQueue.main.async {
            self.refreshActiveTracks()
        }
    }
    
    // MARK: - Helper Methods
    private func refreshActiveTracks() {
        loadActiveTracks()
    }
    
    private func showEmptyState() {
        stackView.isHidden = true
        emptyStateView.isHidden = false
    }
    
    private func hideEmptyState() {
        stackView.isHidden = false
        emptyStateView.isHidden = true
    }
    
    private func getTrackIcon(category: String) -> UIImage? {
        switch category {
        case "nature":
            return UIImage(systemName: "leaf.fill")
        case "animals":
            return UIImage(systemName: "pawprint.fill")
        case "other":
            return UIImage(systemName: "waveform")
        default:
            return UIImage(systemName: "speaker.wave.2.fill")
        }
    }
    
    private func getCategoryColor(category: String) -> UIColor {
        switch category {
        case "nature":
            return R.Colors.primary
        case "animals":
            return R.Colors.accent
        case "other":
            return R.Colors.pink
        default:
            return .white
        }
    }
} 