//
//  OnboardingViewController.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 24.04.25.
//

import UIKit

final class OnboardingViewController: UIViewController {
    /// The sizes that are used only for the shared components.
    private struct SharedComponentSizes {
        static let buttonHeight: CGFloat = 44
    }

    private var backgroundView = LinearGradientView(colors: [UIColor.gradientTop.cgColor, UIColor.gradientBottom.cgColor])

    private lazy var onboardingButton: OnboardingButton = {
        OnboardingButton(
            title: "Continue",
            target: self,
            action: #selector(continueToNextScreen)
        )
    }()

    // MARK: UIViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutBackground()
        layoutButton()
    }

    // MARK: Layout

    private func layoutBackground() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)

        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func layoutButton() {
        onboardingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboardingButton)

        NSLayoutConstraint.activate([
            onboardingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.normal),
            onboardingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.normal),
            onboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Paddings.normal),
            onboardingButton.heightAnchor.constraint(equalToConstant: SharedComponentSizes.buttonHeight)
        ])
    }

    // MARK: UI Actions

    @objc private func continueToNextScreen() {

    }
}
