//
//  ViewController.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 03.06.2023.
//

import UIKit
import AVFoundation

class SoundsController: UIViewController {
    
    private let timerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "stopwatch"), for: .normal)
        button.backgroundColor = R.Colors.green
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1.0;
        button.layer.shadowRadius = 1.0;
        button.layer.shadowOffset = CGSizeMake(5, 5);
        return button
    }()
    
    private let gradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "#ACAD9D").cgColor, UIColor(hexString: "#2D322B").cgColor]
        gradientLayer.locations = [0.0, 1.0]

        return gradientLayer
    }()
    
    private let backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bg4")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let childCollection = NatureCollection()
    let natureCollection = AnimalCollection()
    let animalCollection = OtherCollection()
    
    private let childHeader = MusicHeaders(header: "Nature", desc: "It will allow you to merge with nature")
    private let natureHeader = MusicHeaders(header: "Animals", desc: "Animal voices will improve your sleep")
    private let animalHeader = MusicHeaders(header: "Other", desc: "Animal voices will improve your sleep")
    
    private let navController: MusicNavBar = {
        let view = MusicNavBar(header: "Sounds")
        view.backgroundColor = R.Colors.green
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.tintColor = .white
        view.layer.cornerRadius = 10
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 1.0;
//        view.layer.shadowRadius = 1.0;
//        view.layer.shadowOffset = CGSizeMake(5, 5);
        return view
    }()
    
    private var collectionView: UICollectionView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        
        addViews()
        view.backgroundColor = .white
        constraints()
        addNavBarButton(at: .left,and: UIImage(systemName: "arrow.left"))
        
        
        //gradient.frame = view.bounds
        //view.layer.insertSublayer(gradient, at: 0)
        
    }
    
    override func navBarLeftButtonHandler() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func addViews() {
        
        view.addSubview(scrollView)
        middleView.addSubview(backgroundView)
        view.addSubview(navController)
        view.addSubview(timerButton)
        middleView.addSubview(childCollection)
        middleView.addSubview(childHeader)
        middleView.addSubview(natureCollection)
        middleView.addSubview(natureHeader)
        middleView.addSubview(animalCollection)
        middleView.addSubview(animalHeader)
        
        contentView.addSubview(middleView)
        
        scrollView.addSubview(contentView)
    }
    
    func constraints() {
        childCollection.translatesAutoresizingMaskIntoConstraints = false
        natureCollection.translatesAutoresizingMaskIntoConstraints = false
        animalCollection.translatesAutoresizingMaskIntoConstraints = false
        navController.translatesAutoresizingMaskIntoConstraints = false
        childHeader.translatesAutoresizingMaskIntoConstraints = false
        natureHeader.translatesAutoresizingMaskIntoConstraints = false
        animalHeader.translatesAutoresizingMaskIntoConstraints = false

        
        
        NSLayoutConstraint.activate([
            
            //--------- SCROLL VIEW ---------
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor), // Устанавливает ширину
            contentView.heightAnchor.constraint(equalToConstant: 740),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            middleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 70),
            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            //---------- SCROLL VIEW --------
            
            childHeader.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 0),
            childHeader.heightAnchor.constraint(equalToConstant: 60),
            childHeader.widthAnchor.constraint(equalToConstant: middleView.frame.width),
            
            childCollection.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 20),
            childCollection.heightAnchor.constraint(equalToConstant: 200),
            childCollection.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            natureHeader.topAnchor.constraint(equalTo: childCollection.bottomAnchor, constant: 10),
            natureHeader.heightAnchor.constraint(equalToConstant: 60),
            natureHeader.widthAnchor.constraint(equalToConstant: middleView.frame.width),
            
            natureCollection.topAnchor.constraint(equalTo: childCollection.bottomAnchor, constant: 30),
            natureCollection.heightAnchor.constraint(equalToConstant: 200),
            natureCollection.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            animalHeader.topAnchor.constraint(equalTo: natureCollection.bottomAnchor, constant: 10),
            animalHeader.heightAnchor.constraint(equalToConstant: 60),
            animalHeader.widthAnchor.constraint(equalToConstant: middleView.frame.width),
            
            animalCollection.topAnchor.constraint(equalTo: natureCollection.bottomAnchor, constant: 30),
            animalCollection.heightAnchor.constraint(equalToConstant: 200),
            animalCollection.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -300),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 300),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            navController.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 10),
            navController.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            navController.widthAnchor.constraint(equalToConstant: 110),
            
            timerButton.centerYAnchor.constraint(equalTo:  navController.centerYAnchor),
            timerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            timerButton.widthAnchor.constraint(equalToConstant: 40),
            timerButton.heightAnchor.constraint(equalToConstant: 40),
            
            
        ])
    }
    
}
