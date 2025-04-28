//
//  OnboardingWelcomeView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 25.04.25.
//

import UIKit

final class OnboardingWelcomeView: UIView {
    private var dynamicConstraints = AnimatedConstraints()
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
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutWelcomePage()
    }

    // MARK: Layout

    private func layoutWelcomePage() {
        clipsToBounds = true
        logoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoView)

        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(welcomeLabel)

        dynamicConstraints.animationIn = [
            logoView.heightAnchor.constraint(equalToConstant: CustomImageSize.logoHeight),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: bounds.height * -0.15),
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Paddings.third)
        ]

        dynamicConstraints.animationOut = [
            logoView.heightAnchor.constraint(equalToConstant: CustomImageSize.logoHeight),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: bounds.height * -0.15),
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Paddings.third + 44)
        ]

        NSLayoutConstraint.activate(dynamicConstraints.animationIn)
    }
}

// MARK: Animations

extension OnboardingWelcomeView: TransitionAnimatable {
    func animateTransitionIn(backwards: Bool, completion: @escaping () -> Void) {
        if backwards {
            logoView.isHidden = true
        }
        completion()
    }

    func animateTransitionOut(backwards: Bool = false, completion: @escaping () -> Void = { }) {
        logoView.isHidden = true
        if backwards {
            NSLayoutConstraint.deactivate(dynamicConstraints.animationOut)
            NSLayoutConstraint.activate(dynamicConstraints.animationIn)
        } else {
            NSLayoutConstraint.deactivate(dynamicConstraints.animationIn)
            NSLayoutConstraint.activate(dynamicConstraints.animationOut)
        }

        UIView.animate(
            withDuration: AnimationDuration.normal,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                completion()
                if backwards {
                    self?.logoView.isHidden = false
                }
            }
        )
    }
}
