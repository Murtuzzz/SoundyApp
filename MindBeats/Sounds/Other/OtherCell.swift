//
//  ChildComposerCollection.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 09.06.2023.
//

import UIKit
import AVFAudio

class OtherCollectionCell: UICollectionViewCell {
    
    static var id = "ChildComposerCollection"
    
    private var player = AVAudioPlayer()
    let musicList: [String] = ["RainSound","Waves","Forest","Fire"]
    private var condition = true
    
    private let container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = R.Colors.blueBG.cgColor
        view.backgroundColor = R.Colors.background
        return view
    }()
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = R.Colors.blueBG
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let textBackground: UIView = {
        let view = UIImageView()
        view.backgroundColor = R.Colors.bar
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = R.Colors.blueBG.cgColor
        return view
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Album"
        label.textColor = R.Colors.background
        label.textAlignment = .left
        label.font = R.Fonts.Italic(with: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(container)
        contentView.addSubview(textBackground)
        contentView.addSubview(myImageView)
        contentView.addSubview(mainLabel)
       
        
        
       // contentView.backgroundColor = R.Colors.background
        contentView.clipsToBounds = true
        constraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    public func configure(label: String, image: UIImage) {
        mainLabel.text = label
        myImageView.image = image
        
        
    }
    
    public func changeCondition(_ num: Int) {
        if (condition == true) {
            container.backgroundColor = .systemMint
            myImageView.tintColor = .white
            createPlayer(num)
            player.play()
            condition = false
        } else {
            condition = true
            container.backgroundColor = R.Colors.background
            myImageView.tintColor = R.Colors.blueBG
            player.stop()
        }
    }
    
    func createPlayer(_ num: Int) {
        do {
            let audioPath = Bundle.main.path(forResource: "\(musicList[num])", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        } catch {
            print("Error")
        }
        
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
                    container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                    container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                    container.centerYAnchor.constraint(equalTo: centerYAnchor),
                    container.heightAnchor.constraint(equalToConstant: 120),
//                    container.widthAnchor.constraint(equalToConstant: 100),
                    
                    textBackground.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    textBackground.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    textBackground.bottomAnchor .constraint(equalTo: container.bottomAnchor),
                    textBackground.heightAnchor.constraint(equalToConstant: 35),
                    
                    
                    mainLabel.centerYAnchor.constraint(equalTo: textBackground.centerYAnchor),
                    mainLabel.centerXAnchor.constraint(equalTo: textBackground.centerXAnchor),
////
                    
                    myImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
                    myImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    
                ])
    }
    
}
