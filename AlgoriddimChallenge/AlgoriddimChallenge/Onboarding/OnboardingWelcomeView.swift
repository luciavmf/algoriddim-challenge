//
//  OnboardingWelcomeView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 25.04.25.
//

import UIKit

final class OnboardingWelcomeView: UIView {
    private var dinamycConstraints = AnimatedConstraints()
    public var isAnimating: Bool = false

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
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutWelcomePage()
        activateConstraints()
    }

    // MARK: Layout

    private func layoutWelcomePage() {
        clipsToBounds = true
        logoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoView)

        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(welcomeLabel)

        dinamycConstraints.animationIn = [
            logoView.heightAnchor.constraint(equalToConstant: LogoSize.height),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: bounds.height * -0.1),
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Paddings.third)
        ]

        dinamycConstraints.animationOut = [
            logoView.heightAnchor.constraint(equalToConstant: LogoSize.height),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: bounds.height * -0.1),
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Paddings.third + 44)
        ]
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate(dinamycConstraints.animationIn)
    }

}

// MARK: Animations

extension OnboardingWelcomeView: TransitionAnimatable {
    func animateTransitionIn(backwards: Bool, completion: @escaping () -> Void) {

    }

    func animateTransitionOut(backwards: Bool = false, completion: @escaping () -> Void = { }) {
        logoView.isHidden = true
        if backwards {
            NSLayoutConstraint.deactivate(dinamycConstraints.animationOut)
            NSLayoutConstraint.activate(dinamycConstraints.animationIn)
        } else {
            NSLayoutConstraint.deactivate(dinamycConstraints.animationIn)
            NSLayoutConstraint.activate(dinamycConstraints.animationOut)
        }

        UIView.animate(
            withDuration: AnimationDuration.normal,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                self?.logoView.isHidden = false
                completion()
            }
        )
    }
}
