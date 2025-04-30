# algoriddim-challenge
![https://img.shields.io/badge/Xcode-16.3-lightgrey.svg](https://img.shields.io/badge/Xcode-16.3-lightgrey.svg)
![https://img.shields.io/badge/iOS-15.0+-green.svg](https://img.shields.io/badge/iOS-15.0+-green.svg)
![https://img.shields.io/badge/Swift-6.0-orange.svg](https://img.shields.io/badge/Swift-6.0-orange.svg)
![https://img.shields.io/badge/UIKit-green.svg](https://img.shields.io/badge/UIKit-green.svg)

Algoriddim Challenge. Solves the task described in [Algoriddim - iOS Task.pages](Algoriddim%20-%20iOS%20Task.pages)


### Dependencies
The project uses the [SwiftLint](https://swiftpackageindex.com/realm/SwiftLint) package to enforce common conventions. This package is not necessary and can be removed.

### Notes for the reviewer
* The views inside `Onboarding.Views` folder are only specific for the `OnboardingViewController` and they're not thought to be reusable. I would prefer to make those views `private` in `OnboardingViewController` but I've just left them as `internal` in the project for simplicity. 
* The landscape mode for the first and second page could be improved. It might look better if the "djay" logo is on the left. Also if the onboarding button is on the right side of the screen.
* There's some duplicated code with the constraint settings. I could refactor this code and creating functions like `pin(view: UIView, in: UIView, to: CustomAnchor) ` There're also libraries that do so.
* The project is currently not supporting localizations or accesibility.
