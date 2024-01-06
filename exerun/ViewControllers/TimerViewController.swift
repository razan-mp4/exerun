//
//  TimerViewController.swift
//  exerun
//
//  Created by Nazar Odemchuk on 5/1/2024.
//

import UIKit

class TimerViewController: UIViewController {


    var circularProgressView: CircularProgressView!
    var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create and add the circular progress view to your view hierarchy
        circularProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        circularProgressView.center = view.center
        view.addSubview(circularProgressView)
        
        // Update progress (0.0 to 1.0)
        circularProgressView.progress = 0.2
        
        // Add a label at the top
        statusLabel = UILabel(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: 30))
        statusLabel.textAlignment = .center
        statusLabel.textColor = .orange
        
        // Set the font to Avenir
        if let avenirFont = UIFont(name: "Avenir", size: 25) {
            statusLabel.font = avenirFont
        } else {
            // Fallback to system font if Avenir is not available
            statusLabel.font = UIFont.systemFont(ofSize: 25)
        }
        
        view.addSubview(statusLabel)
        
        // Update progress (0.0 to 1.0)
        circularProgressView.progress = 0.3
        
        // Set initial status
        updateStatus(isWorkTime: true)
        // Register for trait changes

            
    }
    

    
    // Function to update the status label based on whether it is work time or rest time
    private func updateStatus(isWorkTime: Bool) {
        statusLabel.text = isWorkTime ? "Work Time" : "Rest Time"
    }
    
    // Function to update the label color based on the current user interface style
    private func updateLabelColor() {
        statusLabel.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    }

}
