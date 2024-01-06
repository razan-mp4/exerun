import UIKit

class NewWorkOutViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var upperRectangleView: RoundedUpperRectangleView!
    var bottomRectangleView: RoundedBottomRectangleView!
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    
    @IBOutlet weak var workMinutesPicker: UIPickerView!
    @IBOutlet weak var restMinutesPicker: UIPickerView!
    @IBOutlet weak var setPickers: UIPickerView!

    // Number options
    let numbers = Array(1...60)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calculate the frame with padding
        let padding: CGFloat = 20.0
        let upperRectangleFrame = CGRect(x: padding,
                                    y: 120,
                                    width: view.bounds.width - 2 * padding,
                                    height: 45)
        let bottomRectangleFrame = CGRect(x: padding,
                                    y: 169,
                                    width: view.bounds.width - 2 * padding,
                                    height: 45)

        // Create and add the rectangle view to your view hierarchy
        upperRectangleView = RoundedUpperRectangleView(frame: upperRectangleFrame)
        bottomRectangleView = RoundedBottomRectangleView(frame: bottomRectangleFrame)
        view.addSubview(upperRectangleView)
        view.addSubview(bottomRectangleView)
        
        // Ensure that the rectangle is behind the labels
        view.sendSubviewToBack(upperRectangleView)
        view.sendSubviewToBack(bottomRectangleView)

        
        workMinutesPicker.dataSource = self
        workMinutesPicker.delegate = self

        restMinutesPicker.dataSource = self
        restMinutesPicker.delegate = self

        setPickers.dataSource = self
        setPickers.delegate = self
    }

    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // One column
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }

    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numbers[row])
    }

    // Handle selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedNumber = numbers[row]
        // Do something with the selected number
    }
}
