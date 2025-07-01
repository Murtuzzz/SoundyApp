//
//  ActiveSoundsController.swift
//  Soundy
//
//  Created by Assistant on 2024.
//

import UIKit
import AVFoundation

class ActiveSoundsController: UIViewController {
    
    // MARK: - Properties
    private var activeTracks: [(category: String, index: Int, name: String)] = []
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.system(.title3, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - UI Components
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.darkBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Active Sounds".localized()
        label.font = R.Fonts.system(.title2, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
        setupEmptyState()
        setupNotifications()
        updateActiveTracks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateActiveTracks()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = R.Colors.darkBackground
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header View
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title Label
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty State View
            emptyStateView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.register(ActiveSoundCell.self, forCellReuseIdentifier: "ActiveSoundCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = true
        tableView.delaysContentTouches = false
        tableView.canCancelContentTouches = true
        
        // Дополнительные настройки для лучшей работы с слайдерами
        if let scrollView = tableView as? UIScrollView {
            scrollView.delaysContentTouches = false
            scrollView.canCancelContentTouches = true
        }
    }
    
    private func setupEmptyState() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.backgroundColor = .clear
        emptyStateView.isHidden = true
        
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.image = UIImage(systemName: "speaker.slash")
        emptyStateImageView.tintColor = .gray
        emptyStateImageView.contentMode = .scaleAspectFit
        
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.text = "No active sounds".localized()
        emptyStateLabel.font = R.Fonts.system(.title3, weight: .medium)
        emptyStateLabel.textColor = .gray
        emptyStateLabel.textAlignment = .center
        
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -50),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 16),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -32)
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
    
    // MARK: - Actions
    
    @objc private func audioStateChanged(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.updateActiveTracks()
        }
    }
    
    @objc private func allAudioStopped(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.updateActiveTracks()
        }
    }
    
    // MARK: - Helper Methods
    private func updateActiveTracks() {
        let activeTracksData = AudioManager.shared.getActiveTracks()
        activeTracks = activeTracksData.compactMap { track in
            let name = getTrackName(for: track.index, category: track.category)
            return (category: track.category, index: track.index, name: name)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.updateUI()
        }
    }
    
    private func getTrackName(for index: Int, category: String) -> String {
        return AudioManager.shared.getTrackName(for: index, category: category)
    }
    
    private func updateUI() {
        if activeTracks.isEmpty {
            tableView.isHidden = true
            emptyStateView.isHidden = false
        } else {
            tableView.isHidden = false
            emptyStateView.isHidden = true
            tableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - UITableViewDataSource
extension ActiveSoundsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveSoundCell", for: indexPath) as! ActiveSoundCell
        let track = activeTracks[indexPath.row]
        cell.configure(with: track)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ActiveSoundsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

// MARK: - Custom Container View
class InteractiveContainerView: UIView {
    var volumeSlider: UISlider?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Проверяем, есть ли касание в области слайдера
        if let slider = volumeSlider {
            let sliderPoint = convert(point, to: slider)
            if slider.bounds.insetBy(dx: -10, dy: -10).contains(sliderPoint) {
                print("🎯 Container redirecting touch to slider")
                return slider
            }
        }
        
        return super.hitTest(point, with: event)
    }
}

// MARK: - ActiveSoundCell
class ActiveSoundCell: UITableViewCell {
    
    // MARK: - UI Components
    private let containerView: InteractiveContainerView = {
        let view = InteractiveContainerView()
        view.backgroundColor = R.Colors.backgroundCard
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.system(.subheadline, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.system(.caption, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let volumeSlider: InteractiveSlider = {
        let slider = InteractiveSlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.7
        slider.tintColor = R.Colors.accent
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isUserInteractionEnabled = true
        slider.thumbTintColor = .white
        slider.minimumTrackTintColor = R.Colors.accent
        slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        return slider
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        button.tintColor = R.Colors.error
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private var currentTrack: (category: String, index: Int, name: String)?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        isUserInteractionEnabled = true
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(volumeSlider)
        containerView.addSubview(stopButton)
        
        // Связываем слайдер с контейнером
        containerView.volumeSlider = volumeSlider
        
        // Ensure slider is interactive
        volumeSlider.isUserInteractionEnabled = true
        volumeSlider.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
        volumeSlider.addTarget(self, action: #selector(volumeChanged), for: .touchDragInside)
        volumeSlider.addTarget(self, action: #selector(volumeChanged), for: .touchDragOutside)
        
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        
        // Make sure container doesn't interfere with touch events
        containerView.isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Icon Image View
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: stopButton.leadingAnchor, constant: -12),
            
            // Category Label
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            categoryLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Volume Slider
            volumeSlider.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            volumeSlider.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            volumeSlider.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            volumeSlider.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            volumeSlider.heightAnchor.constraint(equalToConstant: 30),
            
            // Stop Button
            stopButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stopButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: 32),
            stopButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    // MARK: - Configuration
    func configure(with track: (category: String, index: Int, name: String)) {
        currentTrack = track
        
        nameLabel.text = track.name
        categoryLabel.text = track.category.capitalized
        
        // Set icon based on category
        switch track.category {
        case "nature":
            iconImageView.image = UIImage(systemName: "leaf.fill")
        case "animals":
            iconImageView.image = UIImage(systemName: "pawprint.fill")
        case "other":
            iconImageView.image = UIImage(systemName: "speaker.wave.2.fill")
        default:
            iconImageView.image = UIImage(systemName: "music.note")
        }
        
        // Set current volume
        let currentVolume = AudioManager.shared.getVolume(for: track.index, category: track.category)
        volumeSlider.value = currentVolume
    }
    
    // MARK: - Actions
    @objc private func volumeChanged(_ sender: UISlider) {
        print("📱 Volume changed to: \(sender.value)")
        guard let track = currentTrack else { 
            print("❌ No current track")
            return 
        }
        print("🎵 Setting volume for \(track.name) to \(sender.value)")
        AudioManager.shared.setVolume(sender.value, for: track.index, category: track.category)
    }
    
    @objc private func stopButtonTapped() {
        guard let track = currentTrack else { return }
        
        // Use the same toggle mechanism to stop the track
        let musicList = getMusicList(for: track.category)
        AudioManager.shared.toggleTrack(track.index, trackName: track.name, musicList: musicList, category: track.category)
    }
    
    private func getMusicList(for category: String) -> [String] {
        switch category {
        case "nature":
            return ["RainSound", "Waves", "Forest", "Fire", "River", "Thunder"]
        case "animals":
            return ["birds", "Cat", "Frogs", "Owl"]
        case "other":
            return ["Keyboard", "Train", "Bar"]
        default:
            return []
        }
    }
}

// MARK: - Custom Slider
class InteractiveSlider: UISlider {
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        print("🎯 Slider beginTracking")
        return super.beginTracking(touch, with: event)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        print("🎯 Slider continueTracking")
        return super.continueTracking(touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        print("🎯 Slider endTracking")
        super.endTracking(touch, with: event)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let result = super.point(inside: point, with: event)
        print("🎯 Slider point inside: \(result) at \(point)")
        return result
    }
} 
