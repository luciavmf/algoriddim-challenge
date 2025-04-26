//
//  OnboardingViewController.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 24.04.25.
//

import UIKit

/// A struct containing the constraints in landscape and portrait mode.
struct Constraints {
    var landscape: [NSLayoutConstraint] = []
    var portrait: [NSLayoutConstraint] = []
}

struct AnimatedConstraints {
    var animationIn: [NSLayoutConstraint] = []
    var animationOut: [NSLayoutConstraint] = []
}

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

    // MARK: Constraints

    private var sharedComponentsConstraints = Constraints()
    private var welcomeView = OnboardingWelcomeView()
    private var heroView = OnboardingHeroView()
    private var selectLevelView = OnboardingSelectLevelView()

    // MARK: Other properties

    private var currentPageIndex: Int = 0

    // Whether the app is animating or not. Used to prevent ot other views to animate at the same time.
    private var isAnimating: Bool = false

    // MARK: UIViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutBackground()

        layoutSharedComponents()

        layoutSelectLevelView()
        layoutWelcomeView()
        layoutHeroView()

        activateCurrentConstraints()
        animatePage(to: currentPageIndex)
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

        sharedComponentsConstraints.portrait = [
            onboardingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Paddings.normal),
            onboardingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Paddings.normal),
            onboardingButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -Paddings.third),
            onboardingButton.heightAnchor.constraint(equalToConstant: SharedComponentSizes.buttonHeight),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: SharedComponentSizes.pageControlHeight),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Paddings.half)
        ]

        sharedComponentsConstraints.landscape = [
            onboardingButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            onboardingButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: Paddings.half * -2),
            onboardingButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -Paddings.half),
            onboardingButton.heightAnchor.constraint(equalToConstant: SharedComponentSizes.buttonHeight),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: SharedComponentSizes.pageControlHeight),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Paddings.half)
        ]
    }

    private func layoutWelcomeView() {
        welcomeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeView)

        NSLayoutConstraint.activate([
            welcomeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            welcomeView.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -Paddings.half),
            welcomeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            welcomeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func layoutHeroView() {
        heroView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(heroView)

        NSLayoutConstraint.activate([
            heroView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            heroView.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -Paddings.half),
            heroView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            heroView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func layoutSelectLevelView() {
        selectLevelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectLevelView)

        NSLayoutConstraint.activate([
            selectLevelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectLevelView.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -Paddings.half),
            selectLevelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Paddings.normal),
            selectLevelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Paddings.normal)
        ])
    }

    // MARK: Landscape - Portrait

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        activateCurrentConstraints()
    }

    private func activateCurrentConstraints() {
        NSLayoutConstraint.deactivate(sharedComponentsConstraints.portrait + sharedComponentsConstraints.landscape)

        if traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(sharedComponentsConstraints.portrait)
        } else {
            NSLayoutConstraint.activate(sharedComponentsConstraints.landscape)
        }
    }

    // MARK: UI Actions

    @objc private func continueToNextScreen() {
        guard pageControl.currentPage < OnboardingPage.allCases.count - 1, !isAnimating else {
            return
        }

        pageControl.currentPage += 1
        animatePage(to: pageControl.currentPage)
    }

    @objc private func pageChanged(_ sender: UIPageControl) {
        animatePage(to: sender.currentPage)
    }

    private func animatePage(to page: Int) {
        // Prevent having overlapping animations.
        guard !isAnimating else { return }

        isAnimating = true
        setInteraction(enabled: false)

        let animateBackwards = page < currentPageIndex
        currentPageIndex = page

        let currentPage = OnboardingPage(rawValue: page) ?? .welcome

        switch currentPage {
        case .welcome:
            animateWelcomeView(animateBackwards: animateBackwards)

        case .hero:
            animateHeroView(animateBackwards: animateBackwards)

        case .selectLevel:
            animateSelectLevelView(animateBackwards: animateBackwards)

        case .custom:
            animateCustomView(animateBackwards: animateBackwards)
        }
    }

    private func animateWelcomeView(animateBackwards: Bool) {
        welcomeView.isHidden = false

        if animateBackwards {
            // Animate the view backwards when the previous page is the hero page.
            welcomeView.animateTransitionOut(backwards: true)
            heroView.animateTransitionIn(backwards: true) { [weak self] in
                guard let self else { return }
                self.heroView.isHidden = true
                self.isAnimating = false
                self.setInteraction(enabled: true)
            }
            return
        }

        heroView.isHidden = true
        selectLevelView.isHidden = true
        isAnimating = false
        setInteraction(enabled: true)
    }

    private func animateHeroView(animateBackwards: Bool) {
        if animateBackwards {
            heroView.isHidden = false
            heroView.animateTransitionOut(backwards: true)
            setInteraction(enabled: true)

            selectLevelView.animateTransitionIn(backwards: true) { [weak self] in
                self?.selectLevelView.isHidden = true
                self?.isAnimating = false
            }
            return
        }

        welcomeView.animateTransitionOut(completion: { [weak self] in
            guard let self else { return }
            self.welcomeView.isHidden = true
            self.setInteraction(enabled: true)
            self.isAnimating = false
        })

        heroView.isHidden = false
        heroView.animateTransitionIn()
    }

    private func animateSelectLevelView(animateBackwards: Bool) {
        if animateBackwards {
            selectLevelView.isHidden = false
            selectLevelView.animateTransitionOut(backwards: animateBackwards) { [weak self] in
                guard let self else { return }
                self.isAnimating = false
                self.setInteraction(enabled: true)
            }
            return
        }

        heroView.animateTransitionOut { [weak self] in
            guard let self else { return }
            self.heroView.isHidden = true
        }

        selectLevelView.isHidden = false

        selectLevelView.animateTransitionIn { [weak self] in
            guard let self else { return }
            self.isAnimating = false
            self.setInteraction(enabled: true)
        }
    }

    private func animateCustomView(animateBackwards: Bool) {
        selectLevelView.animateTransitionOut { [weak self] in
            guard let self else { return }
            self.isAnimating = false
            self.setInteraction(enabled: true)
            self.selectLevelView.isHidden = true
        }
    }

    private func setInteraction(enabled: Bool) {
        pageControl.isUserInteractionEnabled = enabled
        onboardingButton.isUserInteractionEnabled = enabled
    }
}
