//
//  OnboardingViewController.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 24.04.25.
//

import UIKit

final class OnboardingViewController: UIViewController {
    /// The onboarding pages.
    private enum OnboardingPage: Int, CaseIterable {
        case welcome
        case hero
        case selectLevel
        case custom
    }

    /// The sizes that are used only for the shared components.
    private struct SharedComponentSizes {
        static let buttonHeight: CGFloat = 44
        static let pageControlHeight: CGFloat = 16
    }

    private var backgroundView = LinearGradientView(colors: [UIColor.gradientTop.cgColor, UIColor.gradientBottom.cgColor])

    private lazy var onboardingButton: OnboardingButton = {
        OnboardingButton(
            title: "Continue",
            target: self,
            action: #selector(continueToNextScreen)
        )
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = OnboardingPage.allCases.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .pageIndicatorTint
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        return pageControl
    }()

    // MARK: UIViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutBackground()
        layoutSharedComponents()
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

    private func layoutSharedComponents() {
        onboardingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboardingButton)

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            onboardingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Paddings.normal),
            onboardingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Paddings.normal),
            onboardingButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -Paddings.third),
            onboardingButton.heightAnchor.constraint(equalToConstant: SharedComponentSizes.buttonHeight),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: SharedComponentSizes.pageControlHeight),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Paddings.half)
        ])
    }

    // MARK: UI Actions

    @objc private func continueToNextScreen() {

    }

    @objc private func pageChanged(_ sender: UIPageControl) {

    }
}
