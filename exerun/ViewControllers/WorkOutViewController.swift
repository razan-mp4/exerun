import UIKit

class WorkOutViewController: UIViewController {

    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    private var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitleLabel()
        setupScrollView()
        setupImageViews()
    }

    private func setupTitleLabel() {
        // Create and configure the title label
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Workout Options"
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 33.0)
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)

        // Set constraints for the title label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), // Space from top
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Adjust the font color based on the appearance mode
        updateTitleColor(for: traitCollection)
    }

    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true  // Enable vertical scrolling
        scrollView.alwaysBounceHorizontal = false // Disable horizontal scrolling
        scrollView.showsVerticalScrollIndicator = false // Hide vertical scroll indicator
        scrollView.showsHorizontalScrollIndicator = false // Hide horizontal scroll indicator
        view.addSubview(scrollView)

        // Set scrollView constraints to respect the space for the title label
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 9), // Space below the title
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10), // Reduced side margin
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10), // Reduced side margin
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15 // Spacing between each view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        // Set stackView constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor), // No extra margin needed
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor), // Removed extra margin
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor), // Removed extra margin
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Match scrollView width
        ])
    }

    private func setupImageViews() {
        // Initialize and configure image views with images
        let quickWorkout = createImageView(imageName: "quick2", title: "QUICK WORKOUT", description: "Timer for work-rest sets", tag: 1)
        let running = createImageView(imageName: "running", title: "RUNNING", description: "Build a route depending on distance", tag: 2)
        let gymWorkout = createImageView(imageName: "workout", title: "GYM WORKOUT", description: "Make your personalized plan for gym session", tag: 3)
        let hikeWalk = createImageView(imageName: "hikeWalk", title: "HIKE/WALK", description: "Track your hike or walk efficiently", tag: 4)
        let bicycle = createImageView(imageName: "bicycle", title: "BICYCLE", description: "Track your cycling routes and stats", tag: 5)

        // Add image views to the stack view
        stackView.addArrangedSubview(quickWorkout)
        stackView.addArrangedSubview(running)
        stackView.addArrangedSubview(gymWorkout)
        stackView.addArrangedSubview(hikeWalk)
        stackView.addArrangedSubview(bicycle)
    }

    private func createImageView(imageName: String, title: String, description: String, tag: Int) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill // Set content mode to Aspect Fill
        imageView.tag = tag // Assign a tag to identify the image view

        // Add a dark overlay
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(overlayView)

        // Add title label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.systemOrange
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 28)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add shadow to title label
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        titleLabel.layer.shadowOpacity = 0.4
        titleLabel.layer.shadowRadius = 2

        // Add description label
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add shadow to description label
        descriptionLabel.layer.shadowColor = UIColor.black.cgColor
        descriptionLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        descriptionLabel.layer.shadowOpacity = 0.5
        descriptionLabel.layer.shadowRadius = 1

        // Add labels and overlay to imageView
        imageView.addSubview(overlayView)
        overlayView.addSubview(titleLabel)
        overlayView.addSubview(descriptionLabel)

        // Set constraints for overlay
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])

        // Center the title label and place description below
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor, constant: -30), // More space above
            descriptionLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15) // Increased spacing below
        ])

        // Set imageView height based on device type
        let imageViewHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 340 : 150
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imageViewHeight)
        ])

        // Add tap gesture recognizer to each image view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

        return imageView
    }

    // Update the title color based on the current interface style
    private func updateTitleColor(for traitCollection: UITraitCollection) {
        if traitCollection.userInterfaceStyle == .dark {
            titleLabel.textColor = UIColor.white
        } else {
            titleLabel.textColor = UIColor.black
        }
    }

    // This method will be called whenever the interface environment changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateTitleColor(for: traitCollection)
    }

    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        // Identify the tapped image view using its tag
        guard let tappedImageView = sender.view as? UIImageView else { return }
        
        switch tappedImageView.tag {
        case 1:
            // Perform segue or action for QUICK WORKOUT
            performSegue(withIdentifier: "showQuickWorkOutViewController", sender: self)
        case 2:
            // Perform segue or action for RUNNING
            performSegue(withIdentifier: "showRunningViewController", sender: self)
        case 3:
            // Perform segue or action for GYM WORKOUT
            performSegue(withIdentifier: "showGymWorkOutViewController", sender: self)
        case 4:
            // Perform segue or action for HIKE/WALK
            performSegue(withIdentifier: "showHikeWalkViewController", sender: self)
        case 5:
            // Perform segue or action for BICYCLE
            performSegue(withIdentifier: "showBicycleViewController", sender: self)
        default:
            break
        }
    }
}
