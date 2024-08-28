import UIKit
import MapKit
import AudioToolbox
import AVFoundation

class FreeRunViewController: UIViewController {
    
    private var timerStatsView: UIView!
    private var mapViewContainer: UIView!
    private var mapView: MKMapView!
    
    private var mapStatsView: UIView!
    private var circularProgressView: UIView!
    private var stopButton: UIButton!
    private var continueButton: UIButton!
    private var finishButton: UIButton!
    private var audioPlayer: AVAudioPlayer?
    
    private var leftCircleIndicator: UIView!
    private var rightCircleIndicator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color based on current interface style
        view.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : .white
        
        // Initialize views
        setupViews()
        
        // Setup gesture recognizers
        setupGestureRecognizers()
        
        // Ensure both circles are visible initially
        updatePageIndicators(isTimerViewActive: true)
    }
    
    private func setupViews() {
        // Initialize the timer/stats view
        timerStatsView = UIView()
        timerStatsView.translatesAutoresizingMaskIntoConstraints = false
        timerStatsView.backgroundColor = .clear
        view.addSubview(timerStatsView)
        
        // Add circular timer and statistics elements to timerStatsView
        setupTimerAndStatsView()
        
        // Initialize the map view container
        mapViewContainer = UIView()
        mapViewContainer.translatesAutoresizingMaskIntoConstraints = false
        mapViewContainer.alpha = 0 // Initially hidden
        view.addSubview(mapViewContainer)
        
        // Initialize the map view and add it to mapViewContainer
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapViewContainer.addSubview(mapView)
        
        // Add map statistics
        setupMapStatsView()
        
        // Add a single stop button for both views
        setupStopButton()
        
        // Add page indicators
        setupPageIndicators()
        
        // Add constraints
        setupConstraints()
    }
    
    private func setupTimerAndStatsView() {
        // Circular Timer View (similar to one in TimerViewController)
        circularProgressView = UIView()
        circularProgressView.translatesAutoresizingMaskIntoConstraints = false
        circularProgressView.backgroundColor = .clear
        circularProgressView.layer.cornerRadius = 112.5 // Half of the width and height
        circularProgressView.layer.borderWidth = 20 // Increase the border width to match TimerViewController
        circularProgressView.layer.borderColor = UIColor.systemOrange.cgColor
        timerStatsView.addSubview(circularProgressView)
        
        // Timer Label (inside the circular view)
        let timerLabel = UILabel()
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.text = "00:00:00\n0.0 km"
        timerLabel.font = UIFont(name: "Avenir", size: 30)
        timerLabel.textAlignment = .center
        timerLabel.numberOfLines = 2
        circularProgressView.addSubview(timerLabel)
        
        // Create the first horizontal stack view for Pace, Elevation, and Avg Pace
        let firstHorizontalStackView = UIStackView()
        firstHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        firstHorizontalStackView.axis = .horizontal
        firstHorizontalStackView.distribution = .fillProportionally
        firstHorizontalStackView.alignment = .center
        firstHorizontalStackView.spacing = 20
        timerStatsView.addSubview(firstHorizontalStackView)
        
        // Create number and text labels for Pace
        let paceNumberLabel = createStatsNumberLabel(withText: "0'00''/km")
        let paceTextLabel = createStatsTextLabel(withText: "Pace")
        let paceStackView = createVerticalStackView(with: [paceNumberLabel, paceTextLabel])

        // Create number and text labels for Elevation
        let elevationNumberLabel = createStatsNumberLabel(withText: "0 m")
        let elevationTextLabel = createStatsTextLabel(withText: "Elevation")
        let elevationStackView = createVerticalStackView(with: [elevationNumberLabel, elevationTextLabel])

        // Create number and text labels for Avg Pace
        let averagePaceNumberLabel = createStatsNumberLabel(withText: "0'00''/km")
        let averagePaceTextLabel = createStatsTextLabel(withText: "Avg Pace")
        let averagePaceStackView = createVerticalStackView(with: [averagePaceNumberLabel, averagePaceTextLabel])

        // Create separator views using the same method from mapStatsView
        let separator1 = createSeparatorView()
        let separator2 = createSeparatorView()

        // Add stack views and separators to the first horizontal stack view
        firstHorizontalStackView.addArrangedSubview(paceStackView)
        firstHorizontalStackView.addArrangedSubview(separator1)
        firstHorizontalStackView.addArrangedSubview(elevationStackView)
        firstHorizontalStackView.addArrangedSubview(separator2)
        firstHorizontalStackView.addArrangedSubview(averagePaceStackView)

        // Create the second horizontal stack view for Speed, Heart Rate, and Avg Speed
        let secondHorizontalStackView = UIStackView()
        secondHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        secondHorizontalStackView.axis = .horizontal
        secondHorizontalStackView.distribution = .fillProportionally
        secondHorizontalStackView.alignment = .center
        secondHorizontalStackView.spacing = 20
        timerStatsView.addSubview(secondHorizontalStackView)
        
        // Create number and text labels for Speed
        let speedNumberLabel = createStatsNumberLabel(withText: "0.0 km/h")
        let speedTextLabel = createStatsTextLabel(withText: "Speed")
        let speedStackView = createVerticalStackView(with: [speedNumberLabel, speedTextLabel])

        // Create number and text labels for Heart Rate
        let heartRateNumberLabel = createStatsNumberLabel(withText: "0 bpm")
        let heartRateTextLabel = createStatsTextLabel(withText: "Heart Rate")
        let heartRateStackView = createVerticalStackView(with: [heartRateNumberLabel, heartRateTextLabel])

        // Create number and text labels for Avg Speed
        let avgSpeedNumberLabel = createStatsNumberLabel(withText: "0.0 km/h")
        let avgSpeedTextLabel = createStatsTextLabel(withText: "Avg Speed")
        let avgSpeedStackView = createVerticalStackView(with: [avgSpeedNumberLabel, avgSpeedTextLabel])

        // Create separator views for the second stack
        let separator3 = createSeparatorView()
        let separator4 = createSeparatorView()

        // Add stack views and separators to the second horizontal stack view
        secondHorizontalStackView.addArrangedSubview(speedStackView)
        secondHorizontalStackView.addArrangedSubview(separator3)
        secondHorizontalStackView.addArrangedSubview(heartRateStackView)
        secondHorizontalStackView.addArrangedSubview(separator4)
        secondHorizontalStackView.addArrangedSubview(avgSpeedStackView)

        // Constraints for the circularProgressView and timerLabel
        NSLayoutConstraint.activate([
            circularProgressView.centerXAnchor.constraint(equalTo: timerStatsView.centerXAnchor),
            circularProgressView.centerYAnchor.constraint(equalTo: timerStatsView.centerYAnchor, constant: -100),
            circularProgressView.widthAnchor.constraint(equalToConstant: 225), // Width for circular view
            circularProgressView.heightAnchor.constraint(equalToConstant: 225), // Height for circular view
            
            timerLabel.centerXAnchor.constraint(equalTo: circularProgressView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: circularProgressView.centerYAnchor),

            // First horizontal stack view constraints
            firstHorizontalStackView.leadingAnchor.constraint(equalTo: timerStatsView.leadingAnchor, constant: 20),
            firstHorizontalStackView.trailingAnchor.constraint(equalTo: timerStatsView.trailingAnchor, constant: -20),
            firstHorizontalStackView.topAnchor.constraint(equalTo: circularProgressView.bottomAnchor, constant: 20),

            // Second horizontal stack view constraints
            secondHorizontalStackView.leadingAnchor.constraint(equalTo: timerStatsView.leadingAnchor, constant: 20),
            secondHorizontalStackView.trailingAnchor.constraint(equalTo: timerStatsView.trailingAnchor, constant: -20),
            secondHorizontalStackView.topAnchor.constraint(equalTo: firstHorizontalStackView.bottomAnchor, constant: 20)
        ])
    }


    private func setupMapStatsView() {
        // Statistics View Above Map
        mapStatsView = UIView()
        mapStatsView.translatesAutoresizingMaskIntoConstraints = false
        mapStatsView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        mapViewContainer.addSubview(mapStatsView)
        
        // Create horizontal stack view for arranging stats in a row
        let horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillProportionally // Distribute space proportionally
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 20
        mapStatsView.addSubview(horizontalStackView)

        // Create number and text labels for time
        let timeNumberLabel = createStatsNumberLabel(withText: "00:00:00")
        let timeTextLabel = createStatsTextLabel(withText: "Time")
        let timeStackView = createVerticalStackView(with: [timeNumberLabel, timeTextLabel])

        // Create number and text labels for speed
        let speedNumberLabel = createStatsNumberLabel(withText: "0.0 km/h")
        let speedTextLabel = createStatsTextLabel(withText: "Speed")
        let speedStackView = createVerticalStackView(with: [speedNumberLabel, speedTextLabel])

        // Create number and text labels for distance
        let distanceNumberLabel = createStatsNumberLabel(withText: "0.0 km")
        let distanceTextLabel = createStatsTextLabel(withText: "Distance")
        let distanceStackView = createVerticalStackView(with: [distanceNumberLabel, distanceTextLabel])

        // Create separator views with fixed width
        let separator1 = createSeparatorView()
        let separator2 = createSeparatorView()

        // Add stack views and separators to the horizontal stack view
        horizontalStackView.addArrangedSubview(timeStackView)
        horizontalStackView.addArrangedSubview(separator1)
        horizontalStackView.addArrangedSubview(speedStackView)
        horizontalStackView.addArrangedSubview(separator2)
        horizontalStackView.addArrangedSubview(distanceStackView)

        // Map Stats View Constraints
        NSLayoutConstraint.activate([
            mapStatsView.leadingAnchor.constraint(equalTo: mapViewContainer.leadingAnchor),
            mapStatsView.trailingAnchor.constraint(equalTo: mapViewContainer.trailingAnchor),
            mapStatsView.bottomAnchor.constraint(equalTo: mapViewContainer.bottomAnchor),
            mapStatsView.heightAnchor.constraint(equalToConstant: 220), // Adjusted height to allow space for padding

            // Horizontal stack view constraints
            horizontalStackView.centerXAnchor.constraint(equalTo: mapStatsView.centerXAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: mapStatsView.topAnchor, constant: 15), // Padding above the labels
            horizontalStackView.leadingAnchor.constraint(equalTo: mapStatsView.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: mapStatsView.trailingAnchor, constant: -20)
        ])
    }

    private func createSeparatorView() -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        
        // Set fixed width for the separator
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1), // Fixed width for the separator
            separator.heightAnchor.constraint(equalToConstant: 50) // Height of the separator
        ])
        
        return separator
    }




    private func createVerticalStackView(with views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = -7
        return stackView
    }


    private func createStatsNumberLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: "Avenir", size: 32) // Default larger font for the numbers
        label.textAlignment = .center
        label.textColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        
        // Adjust font size to fit the width
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5 // Minimum scale factor
        label.numberOfLines = 1
        
        // Set fixed size constraints for uniformity
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return label
    }



    private func createStatsTextLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: "Avenir", size: 16) // Smaller font for the text
        label.textAlignment = .center
        label.textColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        
        // Adjust font size to fit the width
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5 // Minimum scale factor to ensure text fits
        label.numberOfLines = 1
        
        return label
    }

    private func setupStopButton() {
        // Single Stop Button styled similarly to one in TimerViewController
        stopButton = UIButton(type: .system)
        stopButton.setTitle("Stop", for: .normal)
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.backgroundColor = .systemOrange
        stopButton.titleLabel?.font = UIFont(name: "Avenir", size: 21)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.layer.cornerRadius = 20 // Set corner radius
        stopButton.widthAnchor.constraint(equalToConstant: 100).isActive = true // Set width
        stopButton.heightAnchor.constraint(equalToConstant: 40).isActive = true // Set height
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        view.addSubview(stopButton)
        
        // Stop Button Constraints
        NSLayoutConstraint.activate([
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupPageIndicators() {
        // Create the left circle indicator (Timer View)
        leftCircleIndicator = UIView()
        leftCircleIndicator.translatesAutoresizingMaskIntoConstraints = false
        leftCircleIndicator.layer.cornerRadius = 5 // Small circle
        view.addSubview(leftCircleIndicator)
        
        // Create the right circle indicator (Map View)
        rightCircleIndicator = UIView()
        rightCircleIndicator.translatesAutoresizingMaskIntoConstraints = false
        rightCircleIndicator.layer.cornerRadius = 5 // Small circle
        view.addSubview(rightCircleIndicator)
        
        // Set constraints for the circles closer to each other and below the Stop button
        NSLayoutConstraint.activate([
            leftCircleIndicator.widthAnchor.constraint(equalToConstant: 10),
            leftCircleIndicator.heightAnchor.constraint(equalToConstant: 10),
            leftCircleIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            leftCircleIndicator.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 15),
            
            rightCircleIndicator.widthAnchor.constraint(equalToConstant: 10),
            rightCircleIndicator.heightAnchor.constraint(equalToConstant: 10),
            rightCircleIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            rightCircleIndicator.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 15)
        ])
    }
    
    private func updatePageIndicators(isTimerViewActive: Bool) {
        let activeColor = UIColor.systemOrange
        let inactiveColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        
        leftCircleIndicator.backgroundColor = isTimerViewActive ? activeColor : inactiveColor
        rightCircleIndicator.backgroundColor = isTimerViewActive ? inactiveColor : activeColor
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Timer/stats view constraints
            timerStatsView.topAnchor.constraint(equalTo: view.topAnchor),
            timerStatsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timerStatsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timerStatsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Map view container constraints
            mapViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            mapViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Map view constraints
            mapView.topAnchor.constraint(equalTo: mapViewContainer.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: mapViewContainer.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: mapViewContainer.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: mapViewContainer.bottomAnchor)
        ])
    }
    
    private func setupGestureRecognizers() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            // Show map view, hide timer/stats view
            UIView.animate(withDuration: 0.3) {
                self.timerStatsView.alpha = 0
                self.mapViewContainer.alpha = 1
            }
            updateStatisticsForMapView()
            updatePageIndicators(isTimerViewActive: false)
        } else if gesture.direction == .right {
            // Show timer/stats view, hide map view
            UIView.animate(withDuration: 0.3) {
                self.timerStatsView.alpha = 1
                self.mapViewContainer.alpha = 0
            }
            updateStatisticsForTimerView()
            updatePageIndicators(isTimerViewActive: true)
        }
    }
    
    private func createStatsLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: "Avenir", size: 16)
        label.textAlignment = .center
        label.textColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black // Dynamic color based on mode
        return label
    }
    
    private func updateStatisticsForMapView() {
        print("Updating statistics for map view")
    }
    
    private func updateStatisticsForTimerView() {
        print("Updating statistics for timer view")
    }
    
    @objc private func stopButtonTapped() {
        stopButton.isHidden = true
        configureStopUI()
    }
    
    private func configureStopUI() {
        // Create "Finish" button
        finishButton = UIButton(type: .system)
        finishButton.setTitle("Finish", for: .normal)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.backgroundColor = .systemGray4
        finishButton.titleLabel?.font = UIFont(name: "Avenir", size: 21)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.layer.cornerRadius = 20
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        view.addSubview(finishButton)
        
        // Create "Continue" button
        continueButton = UIButton(type: .system)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = .systemOrange
        continueButton.titleLabel?.font = UIFont(name: "Avenir", size: 21)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.layer.cornerRadius = 20
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        view.addSubview(continueButton)
        
        // Add constraints for "Finish" and "Continue" buttons
        NSLayoutConstraint.activate([
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -70),
            finishButton.widthAnchor.constraint(equalToConstant: 100),
            finishButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70),
            continueButton.widthAnchor.constraint(equalToConstant: 100),
            continueButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func finishButtonTapped() {
        if let tabBarController = self.tabBarController {
            // Assuming `HistoryViewController` is in the second tab (index 1)
            tabBarController.selectedIndex = 1
        }
    }
    
    @objc private func continueButtonTapped() {
        stopButton.isHidden = false
        finishButton.isHidden = true
        continueButton.isHidden = true
        print("Continue button tapped")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Update the background and text colors when the interface style changes
        view.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        updateLabelColors()
        updateMapStatsViewBackground()
        updatePageIndicators(isTimerViewActive: timerStatsView.alpha == 1)
    }
    
    private func updateLabelColors() {
        // Set text color to white in dark mode and black in light mode
        let color = traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        
        // Update labels in timerStatsView
        updateColorsRecursively(in: timerStatsView, color: color)
        
        // Update labels in mapStatsView (including those inside horizontalStackView)
        updateColorsRecursively(in: mapStatsView, color: color)
    }

    private func updateColorsRecursively(in view: UIView, color: UIColor) {
        // Recursively update the color of all UILabels in the view and its subviews
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.textColor = color
            } else {
                // Continue traversing the subviews
                updateColorsRecursively(in: subview, color: color)
            }
        }
    }

    
    private func updateMapStatsViewBackground() {
        // Update map stats view background based on current interface style
        mapStatsView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
    }
}
