//
//  SpiningCircle.swift
//  Gamepedia
//
//  Created by Agah Berkin Güler on 23.05.2024.
//

import UIKit

class SpiningCircleView: UIView {
    
    //MARK: - Variables
    let containerView = UIView()
    let spiningCircle = CAShapeLayer()
    let ratingLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureContainerView()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func configure() {
        let circleSize: CGFloat = 40
        let xPosition = (self.bounds.width ) / 2
        let yPosition = (self.bounds.height) / 2
        let circleRect = CGRect(x: xPosition, y: yPosition, width: circleSize, height: circleSize)
        let circularPath = UIBezierPath(ovalIn: circleRect)
        
        
        spiningCircle.path = circularPath.cgPath
        spiningCircle.fillColor = UIColor.clear.cgColor
        spiningCircle.strokeColor = UIColor.white.cgColor
        spiningCircle.lineWidth = 1.5
        spiningCircle.strokeEnd = 1
        spiningCircle.lineCap = .round
        
        self.layer.addSublayer(spiningCircle)
    }
    
    private func configureContainerView() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 40),
            containerView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureLabel() {
        ratingLabel.textAlignment = .center
        ratingLabel.font = UIFont.systemFont(ofSize: 10)
        ratingLabel.textColor = .white
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

    }
}

