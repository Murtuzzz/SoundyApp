import UIKit
import AVFAudio


struct NatureItems {
        let title: String
        let image: UIImage
}



final class AnimalCollection: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    private var dataSource:[NatureItems] = []
    private var collectionView: UICollectionView?
    
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
            .init(title: "Birds".localized(), image: UIImage(systemName: "bird.fill")!),
            .init(title: "Cats".localized(), image: UIImage(named: "cats")!),
            .init(title: "Frogs".localized(), image: UIImage(named: "frogs")!),
                  ]
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {return}
        
        collectionView.register(AnimalCollectionCell.self, forCellWithReuseIdentifier: AnimalCollectionCell.id)
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = true
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                   collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                   collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
                   collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                   collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
               ])
    }
    
    
    
    
    func constraints() {
        
    }
    
}



extension AnimalCollection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnimalCollectionCell.id, for: indexPath) as! AnimalCollectionCell
        
        let item = dataSource[indexPath.row]
        
        cell.configure(label: item.title, image: item.image)
                  return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 126, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AnimalCollectionCell
        cell.changeCondition(indexPath.row)
        cell.startPlayer()
        
        
    }
}
