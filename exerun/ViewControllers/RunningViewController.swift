import UIKit
import MapKit
import CoreLocation

class RunningViewController: UIViewController, CLLocationManagerDelegate {

    private var mapView: MKMapView!
    private var locationManager: CLLocationManager!

    private var freeRunButton: UIButton!
    private var buildRunButton: UIButton!
    private var setsRunButton: UIButton!
    private var backButton: UIButton!

    private var buttonContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the map view
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)

        // Configure the map view
        configureMapView()

        // Initialize the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        // Initialize the container view for buttons with a transparent grey background
        buttonContainerView = UIView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.6) // Semi-transparent grey
        view.addSubview(buttonContainerView)

        // Initialize the buttons
        freeRunButton = createButton(withTitle: "Free Run", action: #selector(freeRunButtonTapped), font: UIFont(name: "Avenir-Book", size: 21)!)
        buildRunButton = createButton(withTitle: "Build Run", action: #selector(buildRunButtonTapped), font: UIFont(name: "Avenir-Book", size: 21)!)
        setsRunButton = createButton(withTitle: "Sets Run", action: #selector(setsRunButtonTapped), font: UIFont(name: "Avenir-Book", size: 21)!)

        // Add buttons to the container view
        buttonContainerView.addSubview(freeRunButton)
        buttonContainerView.addSubview(buildRunButton)
        buttonContainerView.addSubview(setsRunButton)

        // Initialize and add the back button directly to the main view
        backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.systemOrange, for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 20)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton) // Add backButton to the main view

        // Set up Auto Layout constraints
        setupConstraints()
    }

    private func configureMapView() {
        let initialLocation = CLLocationCoordinate2D(latitude: 40.785091, longitude: -73.968285)
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        configure3DMapView(at: initialLocation)
    }

    private func configure3DMapView(at location: CLLocationCoordinate2D) {
        let camera = MKMapCamera(lookingAtCenter: location, fromDistance: 1000, pitch: 60, heading: 0)
        mapView.setCamera(camera, animated: true)
    }

    private func createButton(withTitle title: String, action: Selector, font: UIFont) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = UIColor.systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Map view should fill the entire screen
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Container view for buttons at the bottom of the screen
            buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor), // Touch the bottom of the screen
            buttonContainerView.heightAnchor.constraint(equalToConstant: 220),

            // Constraints for the free run button
            freeRunButton.heightAnchor.constraint(equalToConstant: 50),
            freeRunButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 20),
            freeRunButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -20),
            freeRunButton.bottomAnchor.constraint(equalTo: buildRunButton.topAnchor, constant: -10),

            // Constraints for the build run button
            buildRunButton.heightAnchor.constraint(equalToConstant: 50),
            buildRunButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 20),
            buildRunButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -20),
            buildRunButton.bottomAnchor.constraint(equalTo: setsRunButton.topAnchor, constant: -10),

            // Constraints for the sets run button
            setsRunButton.heightAnchor.constraint(equalToConstant: 50),
            setsRunButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 20),
            setsRunButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -20),
            setsRunButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor, constant: -40),

            // Constraints for the back button at the top-left corner
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    @objc private func freeRunButtonTapped() {
        print("Free Run button tapped")
        performSegue(withIdentifier: "FreeRunSegue", sender: self)
    }

    @objc private func buildRunButtonTapped() {
        print("Build Run button tapped")
        performSegue(withIdentifier: "BuildRunSegue", sender: self)
    }

    @objc private func setsRunButtonTapped() {
        print("Sets Run button tapped")
        performSegue(withIdentifier: "SetsRunSegue", sender: self)
    }

    @objc private func backButtonTapped() {
        print("Back button tapped")
        dismiss(animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showLocationAccessDeniedAlert()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        let camera = MKMapCamera(lookingAtCenter: location.coordinate, fromDistance: 1000, pitch: 60, heading: 0)
        mapView.setCamera(camera, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    private func showLocationAccessDeniedAlert() {
        let alert = UIAlertController(title: "Location Access Denied",
                                      message: "Please enable location services in settings to use this feature.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension RunningViewController: MKMapViewDelegate {
    // Implement MKMapViewDelegate methods here for additional control over the map view
}
