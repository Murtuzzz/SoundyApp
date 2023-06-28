import UIKit

final class MusicNavBar: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.Italic(with: 34)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    init(header: String) {
        super.init(frame: .zero)
        label.text = header
        settings()
        addSubview(label)
        constraints()
      
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
        
        ])
    }
    
    func settings() {
    }

}
