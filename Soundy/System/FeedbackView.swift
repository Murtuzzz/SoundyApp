import UIKit

// MARK: - Feedback System
class FeedbackView: UIView {
    
    enum FeedbackType {
        case success
        case error
        case warning
        case info
        case loading
        
        var config: FeedbackConfiguration {
            switch self {
            case .success:
                return FeedbackConfiguration(
                    backgroundColor: R.Colors.success,
                    icon: UIImage(systemName: "checkmark.circle.fill"),
                    duration: 2.0
                )
            case .error:
                return FeedbackConfiguration(
                    backgroundColor: R.Colors.error,
                    icon: UIImage(systemName: "xmark.circle.fill"),
                    duration: 3.0
                )
            case .warning:
                return FeedbackConfiguration(
                    backgroundColor: R.Colors.warning,
                    icon: UIImage(systemName: "exclamationmark.triangle.fill"),
                    duration: 2.5
                )
            case .info:
                return FeedbackConfiguration(
                    backgroundColor: R.Colors.info,
                    icon: UIImage(systemName: "info.circle.fill"),
                    duration: 2.0
                )
            case .loading:
                return FeedbackConfiguration(
                    backgroundColor: R.Colors.backgroundSecondary,
                    icon: nil,
                    duration: 0
                )
            }
        }
    }
    
    struct FeedbackConfiguration {
        let backgroundColor: UIColor
        let icon: UIImage?
        let duration: TimeInterval
    }
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = R.Layout.CornerRadius.lg
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.2
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.system(.body, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Properties
    private let type: FeedbackType
    private let message: String
    private var dismissTimer: Timer?
    
    // MARK: - Initialization
    init(type: FeedbackType, message: String) {
        self.type = type
        self.message = message
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        let config = type.config
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(loadingSpinner)
        
        containerView.backgroundColor = config.backgroundColor
        iconImageView.image = config.icon
        messageLabel.text = message
        
        if type == .loading {
            loadingSpinner.startAnimating()
            iconImageView.isHidden = true
        } else {
            loadingSpinner.stopAnimating()
            iconImageView.isHidden = false
        }
        
        setupConstraints()
        setupAccessibility()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Icon or Spinner
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: R.Layout.Spacing.md),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            loadingSpinner.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: R.Layout.Spacing.md),
            loadingSpinner.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            // Message
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: R.Layout.Spacing.md),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -R.Layout.Spacing.md),
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: R.Layout.Spacing.md),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -R.Layout.Spacing.md),
            
            // Container height
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
        ])
    }
    
    private func setupAccessibility() {
        let typeDescription: String
        switch type {
        case .success: typeDescription = "Success"
        case .error: typeDescription = "Error"
        case .warning: typeDescription = "Warning"
        case .info: typeDescription = "Information"
        case .loading: typeDescription = "Loading"
        }
        
        setupAccessibility(
            label: "\(typeDescription): \(message)",
            traits: .staticText
        )
    }
    
    // MARK: - Animation Methods
    func show(in parentView: UIView, completion: (() -> Void)? = nil) {
        parentView.addSubview(self)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor, constant: R.Layout.Spacing.md),
            trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor, constant: -R.Layout.Spacing.md),
            topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: R.Layout.Spacing.md)
        ])
        
        // Initial state
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: -50)
        
        // Animate in
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.3
        ) {
            self.alpha = 1
            self.transform = .identity
        } completion: { _ in
            completion?()
            
            // Auto-dismiss if not loading
            if self.type != .loading {
                self.scheduleAutoDismiss()
            }
        }
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        dismissTimer?.invalidate()
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: -30)
        } completion: { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    private func scheduleAutoDismiss() {
        let config = type.config
        guard config.duration > 0 else { return }
        
        dismissTimer = Timer.scheduledTimer(withTimeInterval: config.duration, repeats: false) { [weak self] _ in
            self?.dismiss()
        }
    }
    
    // MARK: - Static Methods
    static func showSuccess(_ message: String, in view: UIView) {
        let feedback = FeedbackView(type: .success, message: message)
        feedback.show(in: view)
        
        let haptic = UINotificationFeedbackGenerator()
        haptic.notificationOccurred(.success)
    }
    
    static func showError(_ message: String, in view: UIView) {
        let feedback = FeedbackView(type: .error, message: message)
        feedback.show(in: view)
        
        let haptic = UINotificationFeedbackGenerator()
        haptic.notificationOccurred(.error)
    }
    
    static func showWarning(_ message: String, in view: UIView) {
        let feedback = FeedbackView(type: .warning, message: message)
        feedback.show(in: view)
        
        // Haptic feedback
        let haptic = UINotificationFeedbackGenerator()
        haptic.notificationOccurred(.warning)
    }
    
    static func showInfo(_ message: String, in view: UIView) {
        let feedback = FeedbackView(type: .info, message: message)
        feedback.show(in: view)
    }
    
    static func showLoading(_ message: String, in view: UIView) -> FeedbackView {
        let feedback = FeedbackView(type: .loading, message: message)
        feedback.show(in: view)
        return feedback
    }
}

// MARK: - Toast Notifications
extension UIViewController {
    func showSuccessToast(_ message: String) {
        FeedbackView.showSuccess(message, in: view)
    }
    
    func showErrorToast(_ message: String) {
        FeedbackView.showError(message, in: view)
    }
    
    func showWarningToast(_ message: String) {
        FeedbackView.showWarning(message, in: view)
    }
    
    func showInfoToast(_ message: String) {
        FeedbackView.showInfo(message, in: view)
    }
    
    func showLoadingToast(_ message: String) -> FeedbackView {
        return FeedbackView.showLoading(message, in: view)
    }
} 