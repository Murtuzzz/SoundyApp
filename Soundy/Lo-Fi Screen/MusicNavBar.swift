import UIKit

final class MusicNavBar: UINavigationBar {
    private let label: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.avenirBook(with: 34)
        label.textColor = .white
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init(header: String) {
        super.init(frame: .zero)
        label.text = header
        settings()
        addSubview(label)
        constraints()
//        self.label.textAlignment = .center
       
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
