//
//  OnboardingWelcomeView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 25.04.25.
//

import UIKit

final class OnboardingWelcomeView: UIView {
    private var dinamycConstraints = Constraints()

    private var logoView: UIImageView = {
        let uiimageView = UIImageView()
        uiimageView.contentMode = .scaleAspectFit
        uiimageView.image = UIImage(named: "Logo")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        return uiimageView
    }()

    private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to djay!"
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutWelcomePage()
        activateCurrentConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutWelcomePage()
        activateCurrentConstraints()
    }

    // MARK: Layout

    private func layoutWelcomePage() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoView)

        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(welcomeLabel)

        dinamycConstraints.portrait = [
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: bounds.height * -0.1),
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Paddings.third)
        ]
    }

    // MARK: Landscape - Portrait

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        activateCurrentConstraints()
    }

    private func activateCurrentConstraints() {
        NSLayoutConstraint.activate(dinamycConstraints.portrait)
    }
}
