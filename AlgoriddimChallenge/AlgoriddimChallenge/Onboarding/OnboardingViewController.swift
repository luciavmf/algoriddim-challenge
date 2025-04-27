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

enum SkillLevel: Sendable {
    case new
    case ammateur
    case professional
}

/// The onboarding pages.
enum OnboardingPage: Int, CaseIterable {
    case welcome
    case hero
    case selectLevel
    case custom
}

/// The properties of the OnboardingViewController.
final class OnboardingViewModel {
    var currentPage: OnboardingPage = .welcome
    var selectedSkillLevel: SkillLevel?
}

/// The Onboarding component.
final class OnboardingViewController: UIViewController {

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

        // Disable the long press gestures
        pageControl.gestureRecognizers?
            .compactMap { $0 as? UILongPressGestureRecognizer }
            .forEach { $0.isEnabled = false }

        return pageControl
    }()

    // MARK: Constraints

    private var sharedComponentsConstraints = Constraints()
    private var welcomeView = OnboardingWelcomeView()
    private var heroView = OnboardingHeroView()

    private lazy var selectLevelView: OnboardingSelectLevelView = {
        let view = OnboardingSelectLevelView()
        view.delegate = self
        return view
    }()

    private var customView = OnboardingCustomView()

    // Whether the app is animating or not. Used to prevent ot other views to animate at the same time.
    private var isAnimating: Bool = false

    private var viewModel = OnboardingViewModel()

    // MARK: UIViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutBackground()
        layoutSharedComponents()

        layoutView(welcomeView)
        layoutView(heroView)
        layoutView(selectLevelView)
        layoutView(customView)

        activateCurrentConstraints()

        animatePage(to: viewModel.currentPage.rawValue)
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

    private func layoutView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])

        view.isHidden = true
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

        let animateBackwards = page < viewModel.currentPage.rawValue
        viewModel.currentPage = OnboardingPage(rawValue: page) ?? .welcome

        switch viewModel.currentPage {
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
        let viewIn: TransitionAnimatableView? = !animateBackwards ? welcomeView : heroView
        let viewOut: TransitionAnimatableView? = !animateBackwards ? nil : welcomeView

        animate(viewIn: viewIn, viewOut: viewOut, backwards: animateBackwards)
        onboardingButton.isEnabled = true
        onboardingButton.setTitle("Continue", for: .normal)
    }

    private func animateHeroView(animateBackwards: Bool) {
        let viewIn: TransitionAnimatableView = !animateBackwards ? heroView : selectLevelView
        let viewOut: TransitionAnimatableView = !animateBackwards ? welcomeView : heroView
        animate(viewIn: viewIn, viewOut: viewOut, backwards: animateBackwards)
        onboardingButton.isEnabled = true
        onboardingButton.setTitle("Continue", for: .normal)
    }

    private func animateSelectLevelView(animateBackwards: Bool) {
        let viewIn: TransitionAnimatableView = !animateBackwards ? selectLevelView : customView
        let viewOut: TransitionAnimatableView = !animateBackwards ? heroView : selectLevelView

        animate(viewIn: viewIn, viewOut: viewOut, backwards: animateBackwards)
        onboardingButton.isEnabled = viewModel.selectedSkillLevel != nil
        onboardingButton.setTitle("Let's go", for: .normal)
    }

    private func animateCustomView(animateBackwards: Bool) {
        let viewIn: TransitionAnimatableView? = !animateBackwards ? customView : nil
        let viewOut: TransitionAnimatableView? = !animateBackwards ? selectLevelView : nil
        animate(viewIn: viewIn, viewOut: viewOut, backwards: animateBackwards)
        onboardingButton.isEnabled = true
        onboardingButton.setTitle("Done", for: .normal)
    }

    private func animate(viewIn: TransitionAnimatableView?, viewOut: TransitionAnimatableView?, backwards: Bool) {
        viewIn?.isHidden = false
        viewIn?.animateTransitionIn(backwards: backwards) { [weak self] in
            self?.finalizeTransition()
        }

        viewOut?.isHidden = false
        viewOut?.animateTransitionOut(backwards: backwards) { [weak self] in
            self?.finalizeTransition(hiding: backwards ? nil : viewOut)
        }
    }

    private func finalizeTransition(hiding view: UIView? = nil) {
        view?.isHidden = true
        isAnimating = false
        setInteraction(enabled: true)
    }

    private func setInteraction(enabled: Bool) {
        pageControl.isUserInteractionEnabled = enabled
        onboardingButton.isUserInteractionEnabled = enabled
    }
}

extension OnboardingViewController: @preconcurrency OnboardingSelectLevelViewDelegate {
    @MainActor
    func onboardingSelectLevelView(_ view: OnboardingSelectLevelView, didSelectLevel level: SkillLevel) {

        if viewModel.selectedSkillLevel == level {
            viewModel.selectedSkillLevel = nil
            onboardingButton.isEnabled = false
            return
        }

        viewModel.selectedSkillLevel = level
        onboardingButton.isEnabled = true
    }
}
