import UIKit

protocol VolumeControlViewDelegate: AnyObject {
    func volumeChanged(_ volume: Float)
}

class VolumeControlView: UIView {
    
    weak var delegate: VolumeControlViewDelegate?
    
    // MARK: - UI Components
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let volumeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let volumeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.wave.2.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Properties
    private var currentVolume: Float = 0.7
    private var isDragging = false
    private var initialTouchY: CGFloat = 0
    private var initialVolume: Float = 0.7
    
    private let minHeight: CGFloat = 20
    private let maxHeight: CGFloat = 80
    private let volumeRange: Float = 1.0
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundView)
        addSubview(volumeIndicator)
        addSubview(volumeIcon)
        
        // Initial state
        updateVolumeIndicator()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background view
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: maxHeight),
            
            // Volume indicator
            volumeIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            volumeIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            volumeIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            volumeIndicator.heightAnchor.constraint(equalToConstant: minHeight),
            
            // Volume icon
            volumeIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            volumeIcon.bottomAnchor.constraint(equalTo: volumeIndicator.topAnchor, constant: -8),
            volumeIcon.widthAnchor.constraint(equalToConstant: 16),
            volumeIcon.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        addGestureRecognizer(panGesture)
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Gesture Handlers
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        
        switch gesture.state {
        case .began:
            isDragging = true
            initialTouchY = location.y
            initialVolume = currentVolume
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
        case .changed:
            guard isDragging else { return }
            
            let deltaY = initialTouchY - location.y
            let maxDelta = maxHeight - minHeight
            let volumeDelta = Float(deltaY / maxDelta) * volumeRange
            
            let newVolume = max(0, min(1, initialVolume + volumeDelta))
            setVolume(newVolume, animated: false)
            
        case .ended, .cancelled:
            isDragging = false
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
        default:
            break
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let relativeY = 1 - (location.y / maxHeight)
        let newVolume = Float(relativeY)
        
        setVolume(newVolume, animated: true)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    // MARK: - Public Interface
    func setVolume(_ volume: Float, animated: Bool = true) {
        let clampedVolume = max(0, min(1, volume))
        
        guard clampedVolume != currentVolume else { return }
        
        currentVolume = clampedVolume
        
        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
                self.updateVolumeIndicator()
            }
        } else {
            updateVolumeIndicator()
        }
        
        delegate?.volumeChanged(currentVolume)
    }
    
    func getVolume() -> Float {
        return currentVolume
    }
    
    // MARK: - Private Methods
    private func updateVolumeIndicator() {
        let height = minHeight + (maxHeight - minHeight) * CGFloat(currentVolume)
        
        // Update height constraint
        if let heightConstraint = volumeIndicator.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = height
        }
        
        // Update icon position
        let iconOffset = (maxHeight - height) / 2
        volumeIcon.transform = CGAffineTransform(translationX: 0, y: -iconOffset)
        
        // Update icon based on volume level
        let iconName: String
        if currentVolume == 0 {
            iconName = "speaker.slash.fill"
        } else if currentVolume < 0.3 {
            iconName = "speaker.wave.1.fill"
        } else if currentVolume < 0.7 {
            iconName = "speaker.wave.2.fill"
        } else {
            iconName = "speaker.wave.3.fill"
        }
        
        volumeIcon.image = UIImage(systemName: iconName)
    }
    
    // MARK: - Accessibility
    func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityLabel = "Volume control"
        accessibilityHint = "Drag up or down to adjust volume"
        accessibilityTraits = .adjustable
        accessibilityValue = "\(Int(currentVolume * 100))%"
    }
} 