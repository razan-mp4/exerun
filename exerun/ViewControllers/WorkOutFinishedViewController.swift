//
//  WorkOutFinishedViewController.swift
//  exerun
//
//  Created by Nazar Odemchuk on 13/1/2024.
//

import UIKit

class WorkOutFinishedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a label to the center of the screen
        let label = UILabel()
        label.text = "Workout Finished!"
        label.textColor = .systemOrange
        label.font = UIFont(name: "Avenir", size: 25)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        // Add constraints to center the label
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    
        // Perform segue after a delay (for example, 3 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.performSegue(withIdentifier: "MainScreenFromFinishedSeque", sender: self)
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
