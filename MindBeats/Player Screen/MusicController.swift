//
//  MusicController.swift
//  Test
//
//  Created by Мурат Кудухов on 16.06.2023.
//

import UIKit
import AVFoundation


final class MusicController: UIViewController {
    
    private let musicNavBar = MusicNavBar(header: "Concentration")
    
    private var timer: Timer?
    var rotationAngle: CGFloat = 0.0
    var isRotating = false
    private var mainDisk = Disk()
    var index = 0
    
    let musicList: [String] = ["PurrpleCat", "Heart-Of-The-Ocean","StormClouds","Rain","SilentWood","PurpleDream"]
    
    
    
    private let albumView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.text = "00:00"
        return label
    }()
    
    private let durationLabelFull: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        return label
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
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let repeatButton = ButtonView(buttonImage: UIImage(systemName: "repeat")!)
    private let nextButton = ButtonView(buttonImage: UIImage(systemName: "forward.fill")!)
    private let prevButton = ButtonView(buttonImage: UIImage(systemName: "backward.fill")!)
    
    private var player = AVAudioPlayer()
    
    @objc func updateSlider() {
        slider.value = Float(player.currentTime)
    }
    
    @objc func durationLabelCount() {
        let durationLabelSec = Int(player.currentTime)
        durationLabel.text = dateFormatter(durationLabelSec)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let thumbImageSize = CGSize(width: 18, height: 12) // Установите нужный размер для кастомного thumb
        if let thumbImage = createThumbImage(withSize: thumbImageSize) {
            slider.setThumbImage(thumbImage, for: .normal)
        }
        
        view.addSubview(albumView)
        view.addSubview(slider)
        view.addSubview(mainDisk)
        view.addSubview(musicNavBar)
        view.addSubview(repeatButton)
        view.addSubview(nextButton)
        view.addSubview(prevButton)
        view.addSubview(startButton)
        view.addSubview(slider)
        constraints()
        
        
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextSong), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(prevSong), for: .touchUpInside)
        slider.addTarget(self, action: #selector(change), for: .valueChanged)
    
        createPlayer(index)
        if player.currentTime == player.duration {
            player.stop()
            self.rotationAngle = 0.0
            mainDisk.layer.removeAllAnimations()
            mainDisk.transform = CGAffineTransform(rotationAngle: 0)
            isRotating = false
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    func createPlayer(_ num: Int) {
        
        
        do {
            let audioPath = Bundle.main.path(forResource: "\(musicList[num])", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            slider.maximumValue = Float(player.duration)
            durationLabelFull.text = "\(Int(player.duration))"
        } catch {
            print("Error")
        }
        durationLabelFull.text = dateFormatter(Int(player.duration))
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if (self.isMovingFromParent) {
            isRotating = false
            player.stop()
            
            }
    }
    
    @objc
    func nextSong() {
        player.stop()
        self.rotationAngle = 0.0
        mainDisk.layer.removeAllAnimations()
        mainDisk.transform = CGAffineTransform(rotationAngle: 0)
        isRotating = false
        index += 1
        createPlayer(index)
        startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        mainDisk.imageView.image = UIImage(named: musicList[index])
        print(index)
        
    }
    
    @objc
    func prevSong() {
        player.stop()
        self.rotationAngle = 0.0
        mainDisk.layer.removeAllAnimations()
        mainDisk.transform = CGAffineTransform(rotationAngle: 0)
        isRotating = false
        index -= 1
        createPlayer(index)
        startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        mainDisk.imageView.image = UIImage(named: musicList[index])
        print(index)
        
    }
    
    @objc
    func change(_ sender: UISlider) {
        if sender == slider {
            player.currentTime = TimeInterval(sender.value)
            if (player.duration - player.currentTime) == player.duration {
                self.rotationAngle = 0.0
                mainDisk.layer.removeAllAnimations()
                mainDisk.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
    }
    
    
        
        
    @objc
    func start() {
        if player.isPlaying {
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            stopRotation(mainDisk)
            //mainDisk.layer.removeAllAnimations()
            
            isRotating = false
            player.pause()
        } else {
            player.play()
            isRotating = true
            rotateView(mainDisk)
            startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        
        
        timer?.invalidate() // Остановите существующий таймер, если он уже запущен
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(durationLabelCount), userInfo: nil, repeats: true)
    }
    
    func rotateView(_ viewToRotate: UIView) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
          // Рассчитываение угла поворота
            self.rotationAngle += .pi / 60
          viewToRotate.transform = CGAffineTransform(rotationAngle: self.rotationAngle)
       }) { finished in
           if self.isRotating {
               // Рекурсивный вызов функции для продолжения вращения
               self.rotateView(viewToRotate)
           }
       }
    }
    
    func stopRotation(_ viewToRotate: UIView) {
        UIView.animate(withDuration: 0, delay: 0.0, options: .curveLinear, animations: {
          // Рассчитываение угла поворота
          self.rotationAngle += 0
          viewToRotate.transform = CGAffineTransform(rotationAngle: self.rotationAngle)
       }) { finished in
           if self.isRotating == false {
               // Рекурсивный вызов функции для продолжения вращения
               self.stopRotation(viewToRotate)
           }
       }
    }
    
    func constraints() {
        albumView.translatesAutoresizingMaskIntoConstraints = false
        mainDisk.translatesAutoresizingMaskIntoConstraints = false
        musicNavBar.translatesAutoresizingMaskIntoConstraints = false
        repeatButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            
            repeatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            repeatButton.bottomAnchor.constraint(equalTo: albumView.bottomAnchor, constant: -25),
            repeatButton.heightAnchor.constraint(equalToConstant: 20),
            repeatButton.widthAnchor.constraint(equalToConstant: 20),
            
            musicNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            musicNavBar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            mainDisk.heightAnchor.constraint(equalToConstant: 300),
            mainDisk.widthAnchor.constraint(equalToConstant: 300),
            
            mainDisk.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainDisk.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            mainDisk.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -350),
//            mainDisk.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
//            mainDisk.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
//            mainDisk.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            

            
            albumView.topAnchor.constraint(equalTo: view.topAnchor),
            albumView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            durationLabel.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -20),
            
            durationLabelFull.trailingAnchor.constraint(equalTo: slider.trailingAnchor),
            durationLabelFull.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -20),
            
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.topAnchor.constraint(equalTo: mainDisk.bottomAnchor, constant: 70),
            slider.widthAnchor.constraint(equalToConstant: 100),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            startButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 50),
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
        context?.setLineWidth(2) // толщина обводки (можно изменить на желаемое значение)
        context?.strokePath()
        
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return thumbImage
    }
}
