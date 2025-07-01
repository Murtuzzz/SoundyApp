//
//  ViewController.swift
//  CobraApp
//
//  Created by Мурат Кудухов on 03.06.2023.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer


class SoundsController: UIViewController {
    
    // Удален mutable singleton - используем обычную инстанцию
    
    var timerValue = 0 {
        didSet {
            if timerValue == 0 {
                handleTimerCompletion()
            }
        }
    }
    
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    private var isTimerOn = false
    private var hasVideoPlayed = false
    private var timer: Timer?
    
    let natureCollection = NatureCollection()
    let animalCollection = AnimalCollection()
    let otherCollection = OtherCollection()
    
    private let natureHeader = MusicHeaders(header: "Nature".localized(), desc: "It will allow you to merge with nature".localized())
    private let animalHeader = MusicHeaders(header: "Animals".localized(), desc: "Animal voices will improve your sleep".localized())
    private let otherHeader = MusicHeaders(header: "Other".localized(), desc: "Other enjoyable sounds".localized())
    
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
        button.setImage(UIImage(systemName: "moon.zzz.fill"), for: .normal)
        //button.backgroundColor = R.Colors.purple
        button.tintColor = .white
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let stopAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        button.backgroundColor = R.Colors.error.withAlphaComponent(0.8)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.alpha = 0 // Скрыт по умолчанию
        return button
    }()
    
    private let activeTracksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = R.Fonts.system(.caption, weight: .medium)
        label.textColor = R.Colors.success
        label.textAlignment = .center
        label.alpha = 1
        return label
    }()
    
    private let activeSoundsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        //button.backgroundColor = R.Colors.accent.withAlphaComponent(0.8)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let gradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "#ACAD9D").cgColor, UIColor(hexString: "#2D322B").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        return gradientLayer
    }()
    
    private let headerImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "blurBg4")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.darkBackground
        view.layer.cornerRadius = 30
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 30
        return view
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let navController: MusicNavBar = {
        let view = MusicNavBar(header: "".localized())
        view.tintColor = .white
        return view
    }()
    
    private var collectionView: UICollectionView?
    
    override func viewWillAppear(_ animated: Bool) {
        print("WWA")
        //videoPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Запускаем анимации появления - ОТКЛЮЧЕНО, анимации теперь в viewDidLoad
        // animateViewsOnLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        natureCollection.layer.cornerRadius = 45
        
        NotificationCenter.default.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        addViews()
        videoPlayer()
        constraints()
        
        // Подготавливаем элементы для анимации
        prepareViewsForAnimation()
        
        //setupRemoteTransportControls()
        
        timerButton.addTarget(self, action: #selector(timerScreen), for: .touchUpInside)
        activeSoundsButton.addTarget(self, action: #selector(activeSoundsButtonTapped), for: .touchUpInside)
        // stopAllButton.addTarget(self, action: #selector(stopAllAudio), for: .touchUpInside)
        
        // Подписываемся на изменения аудио состояния
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(audioStateChanged),
            name: .audioStateChanged,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(allAudioStopped),
            name: .allAudioStopped,
            object: nil
        )
        
        // Запускаем анимации сразу после setup
        animateViewsOnLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        // Остановить аудио при выходе с экрана
        AudioManager.shared.stopCurrentTrack()
    }
    
    @objc func appCameToForeground() {
        print("Приложение вернулось из фона")
        videoPlayer()
        executeFunction()
    }
    
    func executeFunction() {
        // Здесь ваша логика, которая должна выполниться при возвращении в приложение
        print("Функция выполнена")
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
    
    // MARK: - Timer Completion Handler
    private func handleTimerCompletion() {
        print("Timer completed - cleaning up and returning to main screen")
        
        // Остановить аудио
        AudioManager.shared.stopCurrentTrack()
        
        // Остановить все таймеры
        timer?.invalidate()
        timer = nil
        
        // Остановить все аудио плееры в коллекциях
        stopAllAudioPlayers()
        
        // Остановить видеоплеер если есть
        player?.pause()
        
        // Показать уведомление пользователю
        showTimerCompletionAlert()
        
        // Сбросить состояние таймера
        isTimerOn = false
        timerLabel.text = ""
        
        // Возврат на главный экран
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func stopAllAudioPlayers() {
        // Останавливаем плееры во всех коллекциях
        natureCollection.stopAllPlayers()
        animalCollection.stopAllPlayers()
        otherCollection.stopAllPlayers()
        
        print("🔇 All audio players stopped")
    }
    
    private func showTimerCompletionAlert() {
        let alert = UIAlertController(
            title: "Sleep Timer Completed".localized(),
            message: "It's time to sleep! All sounds have been stopped.".localized(),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    func setupRemoteTransportControls() {
        // Получаем командный центр
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Отключаем кнопки воспроизведения и паузы
        commandCenter.playCommand.isEnabled = false
        commandCenter.pauseCommand.isEnabled = false
        
        // Отключаем команды для перехода к следующему и предыдущему треку
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.previousTrackCommand.isEnabled = false
    }
    
    func videoPlayer() {
        // Попытка загрузить видеофайл
        if let videoURL = Bundle.main.url(forResource: "mountVid", withExtension: "mp4") {
            player = AVPlayer(url: videoURL)
            playerViewController.player = player
            playerViewController.showsPlaybackControls = false
            playerViewController.allowsPictureInPicturePlayback = false
            if #available(iOS 16.0, *) {
                playerViewController.allowsVideoFrameAnalysis = false
            } else {
                // Fallback on earlier versions
            }
            playerViewController.requiresLinearPlayback = false
            if #available(iOS 14.2, *) {
                playerViewController.canStartPictureInPictureAutomaticallyFromInline = false
            } else {
                // Fallback on earlier versions
            }
            playerViewController.videoGravity = .resizeAspectFill
            
            
            playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                playerViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
                playerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                playerViewController.view.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30)
            ])
            // Наблюдение за окончанием воспроизведения видео
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(replayVideo),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)
            player.play()
        } else {
            print("Ошибка: файл видео не найден.")
        }
        
        do {
              try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
              try AVAudioSession.sharedInstance().setActive(true)
          } catch {
              print("Не удалось настроить аудиосессию: \(error.localizedDescription)")
          }
    }
    
    // Обработчик окончания воспроизведения видео
    @objc func replayVideo(notification: Notification) {
        // Перемотка видео на начало
        player.seek(to: CMTime.zero)
        // Перезапуск воспроизведения
        player.play()
    }
    
    deinit {
        // Удаление наблюдателя
        NotificationCenter.default.removeObserver(self)
    }
    
    func timerAmount(completion: @escaping (Int) -> Void) {
        completion(timerValue)
    }
    
    func addViews() {
        navigationController?.navigationBar.tintColor = R.Colors.pink
        view.addSubview(headerImageView)
        headerImageView.isHidden = true
        // Добавление вью контроллера видеоплеера как дочерний компонент
        playerViewController = AVPlayerViewController()
        self.addChild(playerViewController)
        self.view.addSubview(playerViewController.view)
        
        view.addSubview(scrollView)
        view.addSubview(navController)
        view.addSubview(timerLabel)
        view.addSubview(timerButton)
        view.addSubview(activeSoundsButton)
        //view.addSubview(stopAllButton)
        view.addSubview(activeTracksLabel)
        
        middleView.addSubview(natureCollection)
        middleView.addSubview(natureHeader)
        middleView.addSubview(animalCollection)
        middleView.addSubview(animalHeader)
        middleView.addSubview(otherCollection)
        middleView.addSubview(otherHeader)
        
        contentView.addSubview(middleView)
        
        scrollView.addSubview(contentView)
        //view.backgroundColor = R.Colors.blueBG
        view.backgroundColor = R.Colors.darkBackground
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
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 740),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 88),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            middleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            //---------- SCROLL VIEW --------
        
            natureHeader.topAnchor.constraint(equalTo: middleView.topAnchor),
            natureHeader.heightAnchor.constraint(equalToConstant: 64),
            //natureHeader.widthAnchor.constraint(equalToConstant: middleView.frame.width),
            natureHeader.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            
            natureCollection.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 16),
            natureCollection.heightAnchor.constraint(equalToConstant: 200),
            natureCollection.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            animalHeader.topAnchor.constraint(equalTo: natureCollection.bottomAnchor),
            animalHeader.heightAnchor.constraint(equalToConstant: 64),
            animalHeader.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            animalHeader.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -32),
            
            animalCollection.topAnchor.constraint(equalTo: natureCollection.bottomAnchor, constant: 16),
            animalCollection.heightAnchor.constraint(equalToConstant: 200),
            animalCollection.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            otherHeader.topAnchor.constraint(equalTo: animalCollection.bottomAnchor),
            otherHeader.heightAnchor.constraint(equalToConstant: 64),
            otherHeader.widthAnchor.constraint(equalToConstant: middleView.frame.width),
            otherHeader.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            
            otherCollection.topAnchor.constraint(equalTo: animalCollection.bottomAnchor, constant: 16),
            otherCollection.heightAnchor.constraint(equalToConstant: 200),
            otherCollection.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            headerImageView.topAnchor.constraint(equalTo: view.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: navController.bottomAnchor, constant: 32),
           
            navController.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 16),
            navController.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            navController.widthAnchor.constraint(equalToConstant: 110),
            
            timerButton.centerYAnchor.constraint(equalTo: navController.centerYAnchor, constant: -32),
            timerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            timerButton.widthAnchor.constraint(equalToConstant: 48),
            timerButton.heightAnchor.constraint(equalToConstant: 48),
            
            timerLabel.centerYAnchor.constraint(equalTo:  timerButton.centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: timerButton.leadingAnchor),
            timerLabel.widthAnchor.constraint(equalToConstant: 80),
            timerLabel.heightAnchor.constraint(equalToConstant: 21),
            
            // Stop All Button
//            stopAllButton.centerYAnchor.constraint(equalTo: timerButton.centerYAnchor),
//            stopAllButton.trailingAnchor.constraint(equalTo: timerLabel.leadingAnchor, constant: -8),
//            stopAllButton.widthAnchor.constraint(equalToConstant: 40),
//            stopAllButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Active Tracks Label
            activeTracksLabel.centerYAnchor.constraint(equalTo: timerButton.centerYAnchor, constant: -30),
            activeTracksLabel.trailingAnchor.constraint(equalTo: timerLabel.leadingAnchor, constant: -8),
            activeTracksLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            activeTracksLabel.heightAnchor.constraint(equalToConstant: 16),
            
            activeSoundsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            activeSoundsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            activeSoundsButton.widthAnchor.constraint(equalToConstant: 48),
            activeSoundsButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Animation Methods
    private func prepareViewsForAnimation() {
        // Скрываем элементы для анимации появления
        scrollView.alpha = 0
        scrollView.transform = CGAffineTransform(translationX: 0, y: 50)
        
        navController.alpha = 0
        navController.transform = CGAffineTransform(translationX: -100, y: 0)
        
        timerButton.alpha = 0
        timerButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        activeSoundsButton.alpha = 0
        activeSoundsButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        timerLabel.alpha = 0
        activeTracksLabel.alpha = 0
        
        // Подготавливаем коллекции
        prepareCollectionsForAnimation()
    }
    
    private func prepareCollectionsForAnimation() {
        // Nature Collection
        natureHeader.alpha = 0
        natureHeader.transform = CGAffineTransform(translationX: -200, y: 0)
        
        natureCollection.alpha = 0
        natureCollection.transform = CGAffineTransform(translationX: -200, y: 0)
        
        // Animal Collection
        animalHeader.alpha = 0
        animalHeader.transform = CGAffineTransform(translationX: 200, y: 0)
        
        animalCollection.alpha = 0
        animalCollection.transform = CGAffineTransform(translationX: 200, y: 0)
        
        // Other Collection
        otherHeader.alpha = 0
        otherHeader.transform = CGAffineTransform(translationX: -200, y: 0)
        
        otherCollection.alpha = 0
        otherCollection.transform = CGAffineTransform(translationX: -200, y: 0)
    }
    
    private func animateViewsOnLoad() {
        // Анимация навигации и контролов
        animateNavigationElements()
        
        // Последовательная анимация коллекций
        animateCollectionsSequentially()
        
        // Анимация основного скролла
        animateMainScrollView()
    }
    
    private func animateNavigationElements() {
        // Navigation Controller - убираем задержку
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.navController.alpha = 1
            self.navController.transform = .identity
        }
        
        // Timer Button с пульсацией - уменьшаем задержку
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.curveEaseOut]) {
            self.timerButton.alpha = 1
            self.timerButton.transform = .identity
        } completion: { _ in
            self.addPulseAnimation(to: self.timerButton)
        }
        
        // Active Sounds Button
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.curveEaseOut]) {
            self.activeSoundsButton.alpha = 1
            self.activeSoundsButton.transform = .identity
        } completion: { _ in
            self.addPulseAnimation(to: self.activeSoundsButton)
        }
        
        // Timer Label - уменьшаем задержку
        UIView.animate(withDuration: 0.3, delay: 0.3) {
            self.timerLabel.alpha = 1
            self.activeTracksLabel.alpha = 0 // Показываем только при необходимости
        }
    }
    
    private func animateMainScrollView() {
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.scrollView.alpha = 1
            self.scrollView.transform = .identity
        }
    }
    
    private func animateCollectionsSequentially() {
        // Nature Collection (слева направо) - убираем большие задержки
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.natureHeader.alpha = 1
            self.natureHeader.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.natureCollection.alpha = 1
            self.natureCollection.transform = .identity
        } completion: { _ in
            // Анимируем ячейки после появления коллекции
            self.natureCollection.animateCells()
        }
        
        // Animal Collection (справа налево) - уменьшаем задержки
        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.animalHeader.alpha = 1
            self.animalHeader.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.animalCollection.alpha = 1
            self.animalCollection.transform = .identity
        } completion: { _ in
            // Анимируем ячейки после появления коллекции
            self.animalCollection.animateCells()
        }
        
        // Other Collection (слева направо) - уменьшаем задержки
        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.otherHeader.alpha = 1
            self.otherHeader.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.7, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
            self.otherCollection.alpha = 1
            self.otherCollection.transform = .identity
        } completion: { _ in
            // Анимируем ячейки после появления коллекции
            self.otherCollection.animateCells()
            // Финальные анимации после загрузки всех элементов
            self.addFinalTouchAnimations()
        }
    }
    
    private func addPulseAnimation(to view: UIView) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.0
        pulse.toValue = 1.1
        pulse.duration = 1.5
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.layer.add(pulse, forKey: "pulseAnimation")
    }
    
    private func addFinalTouchAnimations() {
        // Добавляем subtle glow эффект к коллекциям
//        [natureCollection, animalCollection, otherCollection].forEach { collection in
//            addGlowEffect(to: collection)
//        }
//        
        // Haptic feedback для завершения анимации
        let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
        impactFeedback.impactOccurred()
    }
    
    private func addGlowEffect(to view: UIView) {
        let glowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        glowAnimation.fromValue = 0.0
        glowAnimation.toValue = 0.3
        glowAnimation.duration = 2.0
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = 1
        
        view.layer.shadowColor = R.Colors.accent.cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.add(glowAnimation, forKey: "glowEffect")
    }
    
    // MARK: - Audio Control Methods
    @objc private func stopAllAudio() {
        // Метод временно отключен, так как stopAllButton закомментирован
        // AudioManager.shared.stopAllTracks()
        
        // Haptic feedback
        // let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        // impactFeedback.impactOccurred()
    }
    
    @objc private func audioStateChanged(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.updateActiveTracksUI()
        }
    }
    
    @objc private func allAudioStopped(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.updateActiveTracksUI()
        }
    }
    
    private func updateActiveTracksUI() {
        let activeCount = AudioManager.shared.getActiveTracksCount()
        
        if activeCount > 0 {
            // Показываем счетчик активных треков
            //activeTracksLabel.text = "\(activeCount) играет"
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.activeTracksLabel.alpha = 1
                self.activeTracksLabel.transform = CGAffineTransform.identity
            })
        } else {
            // Скрываем счетчик
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.activeTracksLabel.alpha = 0
                self.activeTracksLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
        }
    }
    
    @objc
    func activeSoundsButtonTapped() {
        let activeSoundsController = ActiveSoundsController()
        //activeSoundsController.modalPresentationStyle = .overFullScreen
        //activeSoundsController.modalTransitionStyle = .crossDissolve
        present(activeSoundsController, animated: true)
    }
}

// MARK: - Audio Manager
class AudioManager {
    static let shared = AudioManager()
    
    private var activePlayers: [String: AVAudioPlayer] = [:]
    private var playingTracks: Set<String> = []
    
    private init() {}
    
    func toggleTrack(_ trackIndex: Int, trackName: String, musicList: [String], category: String = "nature") {
        let trackKey = "\(category)_\(trackIndex)"
        
        if isPlaying(trackIndex: trackIndex, category: category) {
            // Останавливаем трек
            stopTrack(trackIndex: trackIndex, category: category)
        } else {
            // Запускаем трек
            playTrack(trackIndex, trackName: trackName, musicList: musicList, category: category)
        }
    }
    
    private func playTrack(_ trackIndex: Int, trackName: String, musicList: [String], category: String) {
        let trackKey = "\(category)_\(trackIndex)"
        
        guard trackIndex < musicList.count else {
            print("❌ Error: Invalid music index \(trackIndex), musicList count: \(musicList.count)")
            return
        }
        
        guard let audioPath = Bundle.main.path(forResource: musicList[trackIndex], ofType: "mp3") else {
            print("❌ Error: Audio file '\(musicList[trackIndex]).mp3' not found in bundle")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            player.numberOfLoops = -1 // Бесконечное повторение
            player.volume = 0.7 // Начальная громкость
            player.prepareToPlay()
            player.play()
            
            activePlayers[trackKey] = player
            playingTracks.insert(trackKey)
            
            print("✅ Audio started: \(musicList[trackIndex]) (\(category))")
            
            // Отправляем уведомление об изменении состояния
            NotificationCenter.default.post(name: .audioStateChanged, object: nil, userInfo: [
                "isPlaying": true,
                "trackIndex": trackIndex,
                "trackName": trackName,
                "category": category,
                "trackKey": trackKey
            ])
        } catch {
            print("❌ Error creating audio player: \(error.localizedDescription)")
        }
    }
    
    private func stopTrack(trackIndex: Int, category: String) {
        let trackKey = "\(category)_\(trackIndex)"
        
        guard let player = activePlayers[trackKey] else { return }
        
        player.stop()
        activePlayers.removeValue(forKey: trackKey)
        playingTracks.remove(trackKey)
        
        print("🛑 Audio stopped: \(trackKey)")
        
        // Отправляем уведомление об остановке
        NotificationCenter.default.post(name: .audioStateChanged, object: nil, userInfo: [
            "isPlaying": false,
            "trackIndex": trackIndex,
            "category": category,
            "trackKey": trackKey
        ])
    }
    
    func stopAllTracks() {
        for (trackKey, player) in activePlayers {
            player.stop()
        }
        activePlayers.removeAll()
        playingTracks.removeAll()
        
        print("🛑 All audio stopped")
        
        // Отправляем уведомление об остановке всех треков
        NotificationCenter.default.post(name: .allAudioStopped, object: nil)
    }
    
    func isPlaying(trackIndex: Int, category: String = "nature") -> Bool {
        let trackKey = "\(category)_\(trackIndex)"
        return playingTracks.contains(trackKey)
    }
    
    func setVolume(_ volume: Float, for trackIndex: Int, category: String) {
        let trackKey = "\(category)_\(trackIndex)"
        activePlayers[trackKey]?.volume = volume
    }
    
    func getVolume(for trackIndex: Int, category: String) -> Float {
        let trackKey = "\(category)_\(trackIndex)"
        return activePlayers[trackKey]?.volume ?? 0.7
    }
    
    func getActiveTracksCount() -> Int {
        return activePlayers.count
    }
    
    func getActiveTracks() -> [(category: String, index: Int)] {
        return playingTracks.compactMap { trackKey in
            let components = trackKey.split(separator: "_")
            guard components.count == 2,
                  let index = Int(components[1]) else { return nil }
            return (category: String(components[0]), index: index)
        }
    }
    
    func getTrackName(for index: Int, category: String) -> String {
        switch category {
        case "nature":
            let names = ["Rain".localized(), "Waves".localized(), "Forest".localized(), "Fire".localized(), "River".localized(), "Thunder".localized()]
            return index < names.count ? names[index] : "Unknown".localized()
        case "animals":
            let names = ["Birds".localized(), "Cats".localized(), "Frogs".localized(), "Owl".localized()]
            return index < names.count ? names[index] : "Unknown".localized()
        case "other":
            let names = ["Keyboard".localized(), "Train".localized(), "Bar".localized()]
            return index < names.count ? names[index] : "Unknown".localized()
        default:
            return "Unknown".localized()
        }
    }
    
    // Метод для совместимости со старым API
    func stopCurrentTrack() {
        // Для природных звуков, останавливаем все
        let natureTracks = playingTracks.filter { $0.hasPrefix("nature_") }
        for trackKey in natureTracks {
            let components = trackKey.split(separator: "_")
            if let index = Int(components[1]) {
                stopTrack(trackIndex: index, category: "nature")
            }
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let audioStateChanged = Notification.Name("audioStateChanged")
    static let stopAllOtherAudio = Notification.Name("stopAllOtherAudio")
    static let allAudioStopped = Notification.Name("allAudioStopped")
}
