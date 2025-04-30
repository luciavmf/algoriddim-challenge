# Algoriddim Challenge
![https://img.shields.io/badge/Xcode-16.3-lightgrey.svg](https://img.shields.io/badge/Xcode-16.3-lightgrey.svg)
![https://img.shields.io/badge/iOS-15.0+-green.svg](https://img.shields.io/badge/iOS-15.0+-green.svg)
![https://img.shields.io/badge/Swift-6.0-orange.svg](https://img.shields.io/badge/Swift-6.0-orange.svg)
![https://img.shields.io/badge/Platforms-iPhone,%20iPad-green.svg](https://img.shields.io/badge/Platforms-iPhone,%20iPad-green.svg)
![https://img.shields.io/badge/UIKit-orange.svg](https://img.shields.io/badge/UIKit-orange.svg)

Algoriddim Challenge. Solves the task described in [Algoriddim - iOS Task.pages](Algoriddim%20-%20iOS%20Task.pages)


## Dependencies
The project uses the [SwiftLint](https://swiftpackageindex.com/realm/SwiftLint) package to enforce common conventions. This package is not necessary and can be removed.

## Notes for the reviewer
* **Animations.** There is support in each view to have animations backwards when chosing the previous onboarding step.
* **IPad support.** Even though is not required for the challenge, I've decided to also support iPad and do some small changes in the UI so it looks better.
* **Reusability.**The views inside `Onboarding.Views` could be added to a new package and be used in other projects, after changing the protection level fro `internal` to `public`. Folder are only specific for the `OnboardingViewController` and they're not thought to be reusable. I would prefer to make those views `private` in `OnboardingViewController` but I've just left them as `internal` in the project for simplicity. 
* **UI improvements.** The landscape mode for the first and second page could be improved. It might look better if the "djay" logo is on the left. Also if the onboarding button is on the right side of the screen.
* **Testabiltity.** I've focused on implementing the requirements. In a production project I would add **snapshot** tests for the files under `Components`, and check that they adapt correctly in views in different sizes and
* **Code cleanups**. There's some duplicated code with the constraint settings. I could refactor this code and creating functions like `pin(view: UIView, in: UIView, to: CustomAnchor) ` There're also libraries that do so.
* **Needs support.** The project is currently not supporting localizations or accesibility.
* **Main branch.** There are plenty of commits that I would squash but I've decided to leave them as I've implemented.
