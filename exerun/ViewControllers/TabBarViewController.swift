//
//  TabBarViewController.swift
//  exerun
//
//  Created by Nazar Odemchuk on 5/1/2024.
//
import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize the tab bar appearance
        customizeTabBarAppearance()

        // Call the method to customize the tab bar font
        customizeTabBarFont()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Check if the interface style has changed
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // Update the tab bar appearance for the new style
            updateTabBarColorsForCurrentInterfaceStyle()
        }
    }

    private func customizeTabBarAppearance() {
        // Make the tab bar background transparent
        tabBar.backgroundImage = UIImage() // Removes the background image
        tabBar.shadowImage = UIImage() // Removes the shadow line
        tabBar.isTranslucent = true // Enables translucency
        tabBar.barTintColor = UIColor.black.withAlphaComponent(0.5) // Set the color with transparency

        // Set initial colors based on the current interface style
        updateTabBarColorsForCurrentInterfaceStyle()
    }

    private func customizeTabBarFont() {
        // Set the font for the tab bar items
        if let tabBarItems = tabBar.items {
            for tabBarItem in tabBarItems {
                tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir", size: 13.0)!], for: .normal)
            }
        }
    }

    private func updateTabBarColorsForCurrentInterfaceStyle() {
        // Determine the current interface style
        let isDarkMode = traitCollection.userInterfaceStyle == .dark

        // Set the tint color for selected and unselected items
        tabBar.tintColor = UIColor.systemOrange // Color for selected items
        tabBar.unselectedItemTintColor = isDarkMode ? UIColor.white : UIColor.black // Color for unselected items
    }
}
