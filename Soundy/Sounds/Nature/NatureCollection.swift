//
//  ChildContainer.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 12.06.2023.
//

import UIKit

struct ChildItems {
        let title: String
        let image: UIImage
}



final class NatureCollection: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var dataSource:[ChildItems] = []
    var collectionView: UICollectionView? // Сделано публичным для доступа извне
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
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
                    .init(title: "Rain".localized(), image: UIImage(systemName: "cloud.heavyrain.fill")!),
                    .init(title: "Waves".localized(), image: UIImage(named: "ocean")!),
                    .init(title: "Forest".localized(), image: UIImage(systemName: "tree")!),
                    .init(title: "Fire".localized(), image: UIImage(systemName: "flame")!),
                    .init(title: "River".localized(), image: UIImage(systemName: "water.waves")!),
                    .init(title: "Thunder".localized(), image: UIImage(systemName: "cloud.bolt.rain.fill")!),
                  ]
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {return}
        
        collectionView.register(NatureCollectionCell.self, forCellWithReuseIdentifier: NatureCollectionCell.id)
        
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
    
    func constraints() {
        
    }
    
    // MARK: - Audio Control
    func stopAllPlayers() {
        // Используем централизованный AudioManager для остановки
        AudioManager.shared.stopCurrentTrack()
    }
    
    // MARK: - Cell Animation
    func animateCells() {
        guard let collectionView = collectionView else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            for (index, cell) in collectionView.visibleCells.enumerated() {
                if let natureCell = cell as? NatureCollectionCell {
                    let delay = TimeInterval(index) * 0.1
                    natureCell.animateEntry(delay: delay)
                }
            }
        }
    }
}



extension NatureCollection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NatureCollectionCell.id, for: indexPath) as! NatureCollectionCell
        
        let item = dataSource[indexPath.row]
        
        cell.configure(label: item.title, image: item.image, index: indexPath.item)
                  return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 126, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! NatureCollectionCell
        cell.changeCondition(indexPath.row)
        hapticFeedback.impactOccurred()
        
        
    }
} 