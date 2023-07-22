//
//  MusicController.swift
//  Test
//
//  Created by Мурат Кудухов on 16.06.2023.
//

import UIKit
import AVFoundation


final class TimerController: UIViewController {
    
    init(onTimeSelected: @escaping (Double) -> ()) {
        self.onTimeSelected = onTimeSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var min = 60.0
    private var sum = 0.0
    private var timerValue: Timer?
    private let onTimeSelected: (Double) -> ()
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let timer: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .countDownTimer
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = R.Colors.green
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.titleLabel?.font = R.Fonts.nonItalic(with: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done".localized(), for: .normal)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = R.Colors.blueBG
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.titleLabel?.font = R.Fonts.nonItalic(with: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close".localized(), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerValue?.invalidate()
        
        view.addSubview(container)
        view.addSubview(timer)
        view.addSubview(doneButton)
        view.addSubview(closeButton)
        view.backgroundColor = .black.withAlphaComponent(0.5)
        print(timer.countDownDuration)
        timer.addTarget(self, action: #selector(change), for: .valueChanged)
        
        doneButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        constraints()
        
    }
    
    @objc
    func change() {
        print(timer.countDownDuration/60)
        min = timer.countDownDuration
        print(min)
    }
    
    @objc
    func buttonTapped() {
        
        hapticFeedback.impactOccurred()
        onTimeSelected(min)
        
        dismiss(animated: true)
    }
    
    @objc
    func close() {
        dismiss(animated: true)
    }
    
    @objc func startTimer() {
        let res = timer.countDownDuration
        if min != timer.countDownDuration {
            
            min += 1
            sum = res - min
        } else {
            timerValue?.invalidate()
            min = 0.0
        }
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            container.heightAnchor.constraint(equalToConstant: 400),
            
            timer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            timer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            timer.topAnchor.constraint(equalTo: container.topAnchor,constant: 20),
            timer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -120),

            
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.widthAnchor.constraint(equalToConstant: 110),
            doneButton.topAnchor.constraint(equalTo: timer.bottomAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -40),
            
            closeButton.heightAnchor.constraint(equalToConstant: 60),
            closeButton.widthAnchor.constraint(equalToConstant: 110),
            closeButton.topAnchor.constraint(equalTo: timer.bottomAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 40)
            
            
        ])
    }
    
}

