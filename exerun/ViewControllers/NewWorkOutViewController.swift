import UIKit

class NewWorkOutViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {


    
    @IBOutlet weak var workMinutesPicker: UIPickerView!
    @IBOutlet weak var workSecondsPicker: UIPickerView!
    
    @IBOutlet weak var restMinutesPicker: UIPickerView!
    @IBOutlet weak var restSecondsPicker: UIPickerView!
    
    @IBOutlet weak var setsPicker: UIPickerView!
    
    // Number options
    let numbers = Array(0...59) // For minutes and seconds
    let sets = Array(1...99)    // For sets

    override func viewDidLoad() {
        super.viewDidLoad()
        
        workMinutesPicker.dataSource = self
        workMinutesPicker.delegate = self

        workSecondsPicker.dataSource = self
        workSecondsPicker.delegate = self

        restMinutesPicker.dataSource = self
        restMinutesPicker.delegate = self

        restSecondsPicker.dataSource = self
        restSecondsPicker.delegate = self

        setsPicker.dataSource = self
        setsPicker.delegate = self
    }

    // Adjust the frames on trait collection change (e.g., device rotation)
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Call the code to adjust frames based on the new trait collection
        viewDidLoad()
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // One column
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == setsPicker {
            return sets.count
        }
        return numbers.count
    }

    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == setsPicker {
            return String(sets[row])
        }
        return String(numbers[row])
    }

    // Handle selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedNumber: Int
        if pickerView == setsPicker {
            selectedNumber = sets[row]
        } else {
            selectedNumber = numbers[row]
        }
        // Do something with the selected number
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let timerViewController = segue.destination as? TimerViewController {
            timerViewController.timeTracker = TimeTrackerModel(
                restMinutes: restMinutesPicker.selectedRow(inComponent: 0),
                restSeconds: restSecondsPicker.selectedRow(inComponent: 0),
                workMinutes: workMinutesPicker.selectedRow(inComponent: 0),
                workSeconds: workSecondsPicker.selectedRow(inComponent: 0),
                totalSets: sets[setsPicker.selectedRow(inComponent: 0)] // Use the sets array
            )
        }
    }
    
    @IBAction func startWorkoutButtonTapped(_ sender: UIButton) {
        print("Start Workout Button Tapped")
        
        // Calculate the total workout time in seconds
        let workMinutes = workMinutesPicker.selectedRow(inComponent: 0)
        let workSeconds = workSecondsPicker.selectedRow(inComponent: 0)
        let restMinutes = restMinutesPicker.selectedRow(inComponent: 0)
        let restSeconds = restSecondsPicker.selectedRow(inComponent: 0)
        let totalSets = sets[setsPicker.selectedRow(inComponent: 0)]

        // Calculate total time
        let totalWorkSeconds = (workMinutes * 60) + workSeconds
        let totalRestSeconds = (restMinutes * 60) + restSeconds
        
        // Check if the total time is less than a minute
        if (totalWorkSeconds + totalRestSeconds) * totalSets < 60 {
            // Show alert
            let alert = UIAlertController(title: "Invalid Workout", message: "Workout should be at least a minute", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            // Perform the segue if the time is valid
            performSegue(withIdentifier: "StartWorkoutSegue", sender: self)
        }
    }
}
