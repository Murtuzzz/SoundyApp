//
//  ViewController.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 03.06.2023.
//

import UIKit

class SoundsController: UIViewController {
    
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
        view.backgroundColor = R.Colors.background
        return view
    }()
    
    let childCollection = ChildCollection()
    let natureCollection = NatureCollection()
    let animalCollection = AnimalsCollection()
    
    private let childHeader = MusicHeaders(header: "Child", desc: "Quickly stabilize your baby’s emotions")
    private let natureHeader = MusicHeaders(header: "Nature", desc: "It will allow you to merge with nature")
    private let animalHeader = MusicHeaders(header: "Animals", desc: "Animal voices will improve your sleep")
    
    private let navController = NavController(header: "Composer")
    
    private var collectionView: UICollectionView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        view.backgroundColor = R.Colors.background
        constraints()
        
    }
    
    func addViews() {
        view.addSubview(scrollView)
        
        view.addSubview(navController)
        middleView.addSubview(childCollection)
        middleView.addSubview(childHeader)
        middleView.addSubview(natureCollection)
        middleView.addSubview(natureHeader)
        middleView.addSubview(animalCollection)
        middleView.addSubview(animalHeader)
        
       // contentView.addSubview(topView)
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
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            middleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
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
            
            
            navController.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 10),
            navController.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            navController.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
        ])
    }
    
}
