//
//  MusicController.swift
//  Test
//
//  Created by Мурат Кудухов on 16.06.2023.
//

import UIKit
import AVFoundation


final class MusicController: UIViewController {
    
    private let musicNavBar = MusicNavBar(header: "Lo-Fi")
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    private var timerValue = 0 {
        didSet {
            if timerValue == 0 {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private var timer: Timer?
    private var sleepTimer: Timer?
    var rotationAngle: CGFloat = 0.0
    var isRotating = false
    var descriptionIsShown = false
    private var mainDisk = Disk()
    var index = 0
    var isRepeating = false
    private var isTimerOn = false
    
    let musicList: [String] = ["PurpleDream", "Heart-Of-The-Ocean","StormClouds","Rain","SilentWood","PurrpleCat","Moon", "Snack", "Journey"]
    
    private let albumView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0.0
        slider.maximumValue = 100.0
        let sliderHeightMultiplier: CGFloat = 1.5 // Устанавливаем множитель высоты (толщины) слайдера
        slider.transform = CGAffineTransform(scaleX: 1, y: sliderHeightMultiplier)
        slider.tintColor = R.Colors.bar
        return slider
    }()
    
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
        label.text = "00:00:00"
        label.font = R.Fonts.Italic(with: 20)
        label.textColor = .white
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = R.Colors.blueBG
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = R.Fonts.Italic(with: 15)
        label.numberOfLines = 5
        label.textAlignment = .center
        label.textColor = .systemBackground
        return label
    }()
    
    private let repeatButton: ButtonView = {
        let button = ButtonView(buttonImage: UIImage(systemName: "repeat")!, type: .system)
        button.backgroundColor = .black.withAlphaComponent(0.3)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        
        return button
    }()
    
    private let timerButton: ButtonView = {
        let button = ButtonView(buttonImage: UIImage(systemName: "moon.stars")!, type: .system)
        button.backgroundColor = .black.withAlphaComponent(0.3)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        
        return button
    }()
    
    private let infoButton: ButtonView = {
        let button = ButtonView(buttonImage: UIImage(systemName: "info.circle")!, type: .system)
        button.backgroundColor = .black.withAlphaComponent(0.3)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        
        return button
    }()
    
    private let nextButton = ButtonView(buttonImage: UIImage(systemName: "forward.fill")!,type: .system)
    private let prevButton = ButtonView(buttonImage: UIImage(systemName: "backward.fill")!,type: .system)
    
    private var player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = R.Colors.bar
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        
        let thumbImageSize = CGSize(width: 0.1, height: 0.1) // Установите нужный размер для кастомного thumb
        if let thumbImage = createThumbImage(withSize: thumbImageSize) {
            slider.setThumbImage(thumbImage, for: .normal)
        }
        
        view.addSubview(albumView)
        view.addSubview(blurEffectView)
        view.addSubview(descriptionLabel)
        view.addSubview(slider)
        view.addSubview(mainDisk)
        view.addSubview(musicNavBar)
        view.addSubview(repeatButton)
        view.addSubview(nextButton)
        view.addSubview(prevButton)
        view.addSubview(startButton)
        view.addSubview(slider)
        view.addSubview(infoButton)
        view.addSubview(timerButton)
        view.addSubview(timerLabel)
                //view.backgroundColor = R.Colors.greenBg
        constraints()
        
        albumView.image = UIImage(named: musicList[index])
        timerButton.addTarget(self, action: #selector(timerScreen), for: .touchUpInside)
    
        createPlayer(index)
        settings()
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
            if (self.isMovingFromParent) {
                isRotating = false
                player.stop()
                sleepTimer?.invalidate()

                }
        }

    func createPlayer(_ num: Int) {
        
        
        do {
            let audioPath = Bundle.main.path(forResource: "\(musicList[num])", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            slider.maximumValue = Float(player.duration)
        } catch {
            print("Error")
        }
        
    }
    
    
    
    func settings() {
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextSong), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(prevSong), for: .touchUpInside)
        slider.addTarget(self, action: #selector(change), for: .valueChanged)
        infoButton.addTarget(self, action: #selector(showDescription), for: .touchUpInside)
        
        repeatButton.addTarget(self, action: #selector(repeatSong), for: .touchUpInside)
        
        if player.currentTime == player.duration {
            player.stop()
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        prevButton.tintColor = .gray
    }
    
    @objc func showDescription() {
        if descriptionIsShown == false {
            descriptionIsShown = true
            infoButton.backgroundColor = R.Colors.active
            descriptionLabel.text = descriptions[index]
        } else {
            descriptionIsShown = false
            infoButton.backgroundColor = .black.withAlphaComponent(0.3)
            descriptionLabel.text = ""
        }
    }
    
    @objc func updateSlider() {
        slider.value = Float(player.currentTime)
        
        if Int(player.currentTime) == Int(player.duration) - 5 {
            if isRepeating == true {
                player.currentTime = 0
                player.play()
            } else {
                if index != (musicList.count - 1) {
                    player.stop()
                    isRotating = false
                    index += 1
                    createPlayer(index)
                    startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                    mainDisk.imageView.image = UIImage(named: musicList[index])
                    albumView.image = UIImage(named: musicList[index])
                    player.play()
                    prevButton.tintColor = .white
                    if index == (musicList.count - 1) {
                        nextButton.tintColor = .gray
                        
                    }
                } else {
                    player.stop()
                    isRotating = false
                    index = 0
                    createPlayer(index)
                    prevButton.tintColor = .gray
                    nextButton.tintColor = .white
                    startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                    mainDisk.imageView.image = UIImage(named: musicList[index])
                    albumView.image = UIImage(named: musicList[index])
                    player.play()
                    
                    
                }
            }
        }
    }
    
    @objc
    func repeatSong() {
        if isRepeating == true {
            repeatButton.backgroundColor = .black.withAlphaComponent(0.3)
            isRepeating = false
        } else {
            repeatButton.backgroundColor = R.Colors.active
            isRepeating = true
        }
    }
    
    @objc
    func nextSong() {
        if index >= 0 {
            prevButton.tintColor = .white
        }
        if index == (musicList.count - 1) {
        } else {
            player.stop()
            index += 1
            descriptionIsShown = false
            descriptionLabel.text = ""
            infoButton.backgroundColor = .black.withAlphaComponent(0.3)
            createPlayer(index)
            player.play()
            startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            mainDisk.imageView.image = UIImage(named: musicList[index])
            albumView.image = UIImage(named: musicList[index])
            if index == (musicList.count - 1) {
                nextButton.tintColor = .gray
            }
            print(index)
            
        }
        
    }
    
    @objc
    func prevSong() {
        if index >= musicList.count - 1 {
            nextButton.tintColor = .white
        }
        if index == 1 {
            prevButton.tintColor = .gray
        }
        if index > 0 {
            if player.currentTime < 3 {
                player.stop()
                isRotating = false
                descriptionIsShown = false
                descriptionLabel.text = ""
                infoButton.backgroundColor = .black.withAlphaComponent(0.3)
                index -= 1
                createPlayer(index)
                startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                mainDisk.imageView.image = UIImage(named: musicList[index])
                albumView.image = UIImage(named: musicList[index])
                print(index)
            } else {
                player.currentTime = 0
            }
        } else {
            player.currentTime = 0
        }
        
    }
    
    @objc
    func change(_ sender: UISlider) {
        if sender == slider {
            player.currentTime = TimeInterval(sender.value)
            if player.currentTime == player.duration {
                self.rotationAngle = 0.0
                mainDisk.layer.removeAllAnimations()
                mainDisk.transform = CGAffineTransform(rotationAngle: 0)
                print("End")
            }
        }
    }
    
    
        
        
    @objc
    func start() {
        hapticFeedback.impactOccurred()
        if player.isPlaying {
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            //stopRotation(mainDisk)
            //mainDisk.layer.removeAllAnimations()
            
            isRotating = false
            player.pause()
        } else {
            player.play()
            //isRotating = true
            //rotateView(mainDisk)
            startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        
        
        //timer?.invalidate() // Остановите существующий таймер, если он уже запущен
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    func constraints() {
        albumView.translatesAutoresizingMaskIntoConstraints = false
        mainDisk.translatesAutoresizingMaskIntoConstraints = false
        musicNavBar.translatesAutoresizingMaskIntoConstraints = false
        repeatButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            
//            repeatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            repeatButton.bottomAnchor.constraint(equalTo: mainDisk.bottomAnchor, constant: -10),
            repeatButton.trailingAnchor.constraint(equalTo: mainDisk.trailingAnchor, constant: -10),
            repeatButton.heightAnchor.constraint(equalToConstant: 40),
            repeatButton.widthAnchor.constraint(equalToConstant: 40),
            
            infoButton.bottomAnchor.constraint(equalTo: mainDisk.bottomAnchor, constant: -10),
            infoButton.leadingAnchor.constraint(equalTo: mainDisk.leadingAnchor, constant: 10),
            infoButton.heightAnchor.constraint(equalToConstant: 40),
            infoButton.widthAnchor.constraint(equalToConstant: 40),
            
            timerButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10),
            timerButton.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
            timerButton.heightAnchor.constraint(equalToConstant: 40),
            timerButton.widthAnchor.constraint(equalToConstant: 40),
            
            musicNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            musicNavBar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            descriptionLabel.heightAnchor.constraint(equalToConstant: 100),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 300),
            descriptionLabel.topAnchor.constraint(equalTo: mainDisk.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainDisk.heightAnchor.constraint(equalToConstant: 300),
            mainDisk.widthAnchor.constraint(equalToConstant: 300),
            mainDisk.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainDisk.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            albumView.topAnchor.constraint(equalTo: view.topAnchor),
            albumView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 200),
            albumView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.topAnchor.constraint(equalTo: musicNavBar.bottomAnchor, constant: 5),
            slider.widthAnchor.constraint(equalToConstant: 150),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 60),
            startButton.widthAnchor.constraint(equalToConstant: 60),
            startButton.centerYAnchor.constraint(equalTo: mainDisk.centerYAnchor),
            
            nextButton.leadingAnchor.constraint(equalTo: startButton.trailingAnchor, constant: 41),
            nextButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor, constant: 7),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            nextButton.widthAnchor.constraint(equalToConstant: 40),
            
            prevButton.trailingAnchor.constraint(equalTo: startButton.leadingAnchor, constant: -40),
            prevButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor, constant: 7),
            prevButton.heightAnchor.constraint(equalToConstant: 40),
            prevButton.widthAnchor.constraint(equalToConstant: 40),
            
            timerLabel.centerYAnchor.constraint(equalTo:  timerButton.centerYAnchor),
            timerLabel.leadingAnchor.constraint(equalTo: timerButton.trailingAnchor, constant: 10),
            timerLabel.widthAnchor.constraint(equalToConstant: 80),
            timerLabel.heightAnchor.constraint(equalToConstant: 21),
            
        ])
    }
    
    
    
    
}


extension MusicController {
    func dateFormatter(_ seconds: Int) -> String {
        let timeInSeconds = seconds // время в секундах

        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = .positional
        dateComponentsFormatter.zeroFormattingBehavior = .pad
        dateComponentsFormatter.allowedUnits = [.minute, .second]

        return dateComponentsFormatter.string(from: TimeInterval(timeInSeconds)) ?? "0:00"
    }
    
    func createThumbImage(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        // Нарисуйте круглое изображение
        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
        // Задайте цвет для заливки thumb (можно изменить на желаемый цвет)
        R.Colors.bar.setFill()
        // Задайте цвет для обводки thumb (можно изменить на желаемый цвет)
        UIColor.clear.setStroke()
        
        // Заполнение и обводка изображения
        context?.addPath(path.cgPath)
        context?.fillPath()
        context?.addPath(path.cgPath)
        //context?.setLineWidth(0) // толщина обводки (можно изменить на желаемое значение)
        context?.strokePath()
        
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return thumbImage
    }
    
    @objc
    func timerScreen() {
        let vc = TimerController { minutes in
            self.sleepTimer?.invalidate()
            let minutes = minutes
            self.timerLabel.text = self.dateComponentsFormatter.string(from: TimeInterval(Int(minutes)))
            self.timerValue = Int(minutes)
            self.isTimerOn = true
            print(self.isTimerOn)
            self.sleepTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
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
}
