import UIKit


struct AnimalsItems {
        let title: String
        let image: UIImage
}



final class OtherCollection: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var dataSource:[NatureItems] = []
    var collectionView: UICollectionView? // Сделано публичным для доступа извне
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionApperance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionApperance() {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = -1
        layout.minimumInteritemSpacing = 1
        
        dataSource = [
            .init(title: "Keyboard".localized(), image: UIImage(systemName: "keyboard.fill")!),
            .init(title: "Train".localized(), image: UIImage(systemName: "train.side.rear.car")!),
            .init(title: "Bar".localized(), image: UIImage(systemName: "wineglass.fill")!),
                  ]
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {return}
        
        collectionView.register(OtherCollectionCell.self, forCellWithReuseIdentifier: "OtherCollectionCell")
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                   collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                   collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
                   collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                   collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
               ])
    }
    
}



extension OtherCollection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherCollectionCell", for: indexPath) as! OtherCollectionCell
        
        let item = dataSource[indexPath.row]
        
        cell.configure(label: item.title, image: item.image, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 126, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! OtherCollectionCell
        
        cell.changeCondition(indexPath.row)
        hapticFeedback.impactOccurred()
    }
    
    // MARK: - Audio Control
    func stopAllPlayers() {
        // Используем централизованный AudioManager для остановки
        AudioManager.shared.stopAllTracks()
    }
    
    // MARK: - Cell Animation
    func animateCells() {
        guard let collectionView = collectionView else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            for (index, cell) in collectionView.visibleCells.enumerated() {
                if let otherCell = cell as? OtherCollectionCell {
                    let delay = TimeInterval(index) * 0.1
                    otherCell.animateEntry(delay: delay)
                }
            }
        }
    }
}
