//
//  ViewController.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 03.06.2023.
//

import UIKit
import AVFoundation

class SoundsController: UIViewController {
    
    private var timerValue = 0 {
        didSet {
            if timerValue == 0 {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private var isTimerOn = false
    private var timer: Timer?
    
    private let dateComponentsFormatter: DateComponentsFormatter = {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = .positional
        dateComponentsFormatter.zeroFormattingBehavior = .pad
        dateComponentsFormatter.allowedUnits = [.hour, .minute, .second]
        return dateComponentsFormatter
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = R.Fonts.Italic(with: 20)
        label.textColor = .white
        return label
    }()
    
    private let timerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "moon.zzz"), for: .normal)
        button.backgroundColor = R.Colors.green
        button.tintColor = .white
        button.layer.cornerRadius = 10
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
        view.image = UIImage(named: "blurBg4")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
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
    
    let natureCollection = NatureCollection()
    let animalCollection = AnimalCollection()
    let otherCollection = OtherCollection()
    
    private let natureHeader = MusicHeaders(header: "Nature".localized(), desc: "It will allow you to merge with nature".localized())
    private let animalHeader = MusicHeaders(header: "Animals".localized(), desc: "Animal voices will improve your sleep".localized())
    private let otherHeader = MusicHeaders(header: "Other".localized(), desc: "Other enjoyable sounds".localized())
    
    private let navController: MusicNavBar = {
        let view = MusicNavBar(header: "Sounds".localized())
        view.tintColor = .white
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
        //addNavBarButton(at: .left,and: UIImage(systemName: "arrow.left"))
        
        timerButton.addTarget(self, action: #selector(timerScreen), for: .touchUpInside)
    
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        
    }
    
    @objc
    func timerScreen() {
        let vc = TimerController { minutes in
            self.timer?.invalidate()
            let minutes = minutes
            self.timerLabel.text = self.dateComponentsFormatter.string(from: TimeInterval(Int(minutes)))
            self.timerValue = Int(minutes)
            self.isTimerOn = true
            print(self.isTimerOn)
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @objc func startTimer() {
        if timerValue != 0 {
            timerValue -= 1
            print(timerValue)
            timerLabel.text = self.dateComponentsFormatter.string(from: TimeInterval(Int(timerValue)))
        }
    }
    
    func close() {
        dismiss(animated: true)
    }
    
    func addViews() {
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterial)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//
//        blurEffectView.frame = view.bounds
//        blurEffectView.alpha = 1
        
        navigationController?.navigationBar.tintColor = R.Colors.green
        
        view.addSubview(scrollView)
        middleView.addSubview(backgroundView)
        
        view.addSubview(navController)
        view.addSubview(timerLabel)
        view.addSubview(timerButton)
       // middleView.addSubview(blurEffectView)
        middleView.addSubview(natureCollection)
        middleView.addSubview(natureHeader)
        middleView.addSubview(animalCollection)
        middleView.addSubview(animalHeader)
        middleView.addSubview(otherCollection)
        middleView.addSubview(otherHeader)
        
        contentView.addSubview(middleView)
        
        scrollView.addSubview(contentView)
    }
    
    func constraints() {
        natureCollection.translatesAutoresizingMaskIntoConstraints = false
        animalCollection.translatesAutoresizingMaskIntoConstraints = false
        otherCollection.translatesAutoresizingMaskIntoConstraints = false
        navController.translatesAutoresizingMaskIntoConstraints = false
        natureHeader.translatesAutoresizingMaskIntoConstraints = false
        animalHeader.translatesAutoresizingMaskIntoConstraints = false
        otherHeader.translatesAutoresizingMaskIntoConstraints = false

        
        
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
            
            natureHeader.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 0),
            natureHeader.heightAnchor.constraint(equalToConstant: 60),
            natureHeader.widthAnchor.constraint(equalToConstant: middleView.frame.width),
            
            natureCollection.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 20),
            natureCollection.heightAnchor.constraint(equalToConstant: 200),
            natureCollection.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            animalHeader.topAnchor.constraint(equalTo: natureCollection.bottomAnchor, constant: 10),
            animalHeader.heightAnchor.constraint(equalToConstant: 60),
            animalHeader.widthAnchor.constraint(equalToConstant: middleView.frame.width),
            
            animalCollection.topAnchor.constraint(equalTo: natureCollection.bottomAnchor, constant: 30),
            animalCollection.heightAnchor.constraint(equalToConstant: 200),
            animalCollection.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            otherHeader.topAnchor.constraint(equalTo: animalCollection.bottomAnchor, constant: 10),
            otherHeader.heightAnchor.constraint(equalToConstant: 60),
            otherHeader.widthAnchor.constraint(equalToConstant: middleView.frame.width),
            
            otherCollection.topAnchor.constraint(equalTo: animalCollection.bottomAnchor, constant: 30),
            otherCollection.heightAnchor.constraint(equalToConstant: 200),
            otherCollection.widthAnchor.constraint(equalToConstant: view.frame.width),
            
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
            
            timerLabel.centerYAnchor.constraint(equalTo:  navController.centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: timerButton.leadingAnchor, constant: -5),
            timerLabel.widthAnchor.constraint(equalToConstant: 80),
            timerLabel.heightAnchor.constraint(equalToConstant: 21),
            
            
        ])
    }
    
}
