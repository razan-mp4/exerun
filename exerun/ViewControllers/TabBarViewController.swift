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

        // Call the method to customize the tab bar font
        customizeTabBarFont()
    }

    private func customizeTabBarFont() {
        // Set the font for the tab bar items
        if let tabBarItems = tabBar.items {
            for tabBarItem in tabBarItems {
                tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir", size: 13.0)!], for: .normal)
            }
        }
    }

}
