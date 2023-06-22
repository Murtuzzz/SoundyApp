//
//  ChildContainer.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 12.06.2023.
//

import UIKit

//struct ChildItems {
//    struct ChildObjects {
//        let title: String
//        let image: UIImage
//        let color: UIColor
//    }
//
//    let title: String
//    let subtitle: String
//    let items: [ChildObjects]
//}

struct ChildItems {
        let title: String
        let image: UIImage
        let color: UIColor
}



final class ChildCollection: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var dataSource:[ChildItems] = []
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
                    .init(title: "Female voice", image: UIImage(named: "girl")!, color: R.Colors.bar),
                    .init(title: "White noize", image: UIImage(named: "micro")!, color: R.Colors.active),
                    .init(title: "Lullaby", image: UIImage(named: "moon2")!, color: R.Colors.bar),
                    .init(title: "Lullaby", image: UIImage(named: "moon2")!, color: R.Colors.bar),
                  ]
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {return}
        
        collectionView.register(ChildCollectionCell.self, forCellWithReuseIdentifier: ChildCollectionCell.id)
        
        collectionView.backgroundColor = R.Colors.background
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                   collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                   collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                   collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                   collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
               ])
    }
    
    func constraints() {
        
    }
}



extension ChildCollection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChildCollectionCell.id, for: indexPath) as! ChildCollectionCell
        
        let item = dataSource[indexPath.row]
        
        cell.configure(label: item.title, image: item.image, condition: item.color)
                  return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 126, height: 180)
    }
}
