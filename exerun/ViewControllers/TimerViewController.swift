import UIKit
import AudioToolbox // Import AudioToolbox for vibration
import AVFoundation  // Import AVFoundation for sound playback

class TimerViewController: UIViewController {
    
    var timeTracker: TimeTrackerModel!
    
    var circularProgressView: CircularProgressView!
    var statusLabel: UILabel!
    var setsLeftLabel: UILabel!
    var timeLabel: UILabel!
    var stopButton: UIButton!
    let continueButton = UIButton(type: .system)
    let finishButton = UIButton(type: .system)
    
    var audioPlayer: AVAudioPlayer? // AVAudioPlayer instance for sound playback
    
    // Variable to track whether the timer is paused
    var isTimerPaused = false
    
    // Variable to track whether it is countdown
    var isCountDown = true
    
    var timer: Timer?
    var currentTime: TimeInterval = 0.0 // Current time remaining
    var countdownTime: TimeInterval = 4.0 // Countdown time before the main timer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and add the circular progress view to your view hierarchy
        circularProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        circularProgressView.center = view.center
        view.addSubview(circularProgressView)
        
        // Add a label at the top
        statusLabel = UILabel(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: 30))
        statusLabel.textAlignment = .center
        statusLabel.textColor = .systemOrange
        statusLabel.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(statusLabel)
        
        // Add a label in the center to display the time left
        timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        timeLabel.center = circularProgressView.center
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(timeLabel)
        
        // Add a "Stop" button at the bottom
        stopButton = UIButton(type: .system)
        stopButton.setTitle("Stop", for: .normal)
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.backgroundColor = .systemOrange
        stopButton.titleLabel?.font = UIFont(name: "Avenir", size: 21)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.layer.cornerRadius = 20 // Set corner radius
        stopButton.widthAnchor.constraint(equalToConstant: 100).isActive = true // Set width
        stopButton.heightAnchor.constraint(equalToConstant: 40).isActive = true // Set width
        stopButton.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
        view.addSubview(stopButton)
        
        // Add constraints for the "Stop" button
        NSLayoutConstraint.activate([
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Add a "Sets Left" label between the "Stop" button and circularProgressView
        setsLeftLabel = UILabel()
        setsLeftLabel.text = ""
        setsLeftLabel.font = UIFont(name: "Avenir", size: 16)
        setsLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(setsLeftLabel)
        
        // Add constraints for the "Sets Left" label
        NSLayoutConstraint.activate([
            setsLeftLabel.bottomAnchor.constraint(equalTo: stopButton.topAnchor, constant: -20),
            setsLeftLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Set initial status
        updateStatus(isWorkTime: timeTracker.isWorkTime, coundownStartStop: true, countdownTime: countdownTime)
        
        // Start the timer for countdown
        startCountdownTimer()
    }
    
    // Function to update the status label based on whether it is work time or rest time
    private func updateStatus(isWorkTime: Bool, coundownStartStop: Bool, countdownTime: TimeInterval = 0.0) {
        let newStatus: String
        
        // Tracking whether it is countdown
        isCountDown = coundownStartStop
        
        if isCountDown {
            if countdownTime == 3 {
                newStatus = "Ready!"
                playSoundAndVibrate()
            } else if countdownTime == 2 {
                newStatus = "Steady!"
                playSoundAndVibrate()
            } else if countdownTime == 1 {
                newStatus = "Go!"
                playSoundAndVibrate()
            } else {
                newStatus = "" // No status change needed outside 3-1 countdown
            }
        } else {
            newStatus = isWorkTime ? "Work Time" : "Rest Time"
            playSoundAndVibrate()
        }
        
        // Avoid unnecessary updates
        if self.statusLabel.text != newStatus && !newStatus.isEmpty {
            UIView.transition(with: statusLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.statusLabel.text = newStatus
            })
        }
    }
    
    // Function to play sound and vibrate
    private func playSoundAndVibrate() {
        // Vibration
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        // Sound
        if let soundURL = Bundle.main.url(forResource: "boop", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Failed to play sound: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found")
        }
    }
    
    // Function to update the label color based on the current user interface style
    private func updateLabelColor() {
        timeLabel.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        statusLabel.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .systemOrange
        setsLeftLabel.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    }
    
    // Function to start the countdown timer
    private func startCountdownTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownTimer), userInfo: nil, repeats: true)
    }
    
    // Function to update the countdown timer
    @objc private func updateCountdownTimer() {
        countdownTime -= 1.0
        
        updateStatus(isWorkTime: true, coundownStartStop: true, countdownTime: countdownTime)
        
        // Declare roundedSeconds before the UIView.animate block
        let roundedSeconds = Int(countdownTime.rounded())
        
        // Update timeLabel for the countdown as an integer with fade animation
        UIView.transition(with: timeLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.timeLabel.text = String(roundedSeconds)
        }, completion: nil)
        
        // Update circularProgressView for the countdown
        let progress = Float(countdownTime / 3.0) // Assuming a 3-second countdown
        circularProgressView.progress = CGFloat(1.0 - progress) // Reverse progress for a decreasing effect
        
        if countdownTime <= 0 {
            // Countdown finished, start the main timer
            timer?.invalidate()
            updateStatus(isWorkTime: true, coundownStartStop: false) // Change status to "Work Time"
            startMainTimer()
        }
    }
    
    // Function to start the main timer
    private func startMainTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // Function to update the timer and circular progress
    @objc private func updateTimer() {
        currentTime += 1.0
        let progress = Float(currentTime / timeTracker.currentIntervalTime)
        circularProgressView.progress = CGFloat(progress)
        updateTimeLabel()
        updateSetsLeftLabel()
        
        if currentTime >= timeTracker.currentIntervalTime {
            timer?.invalidate()
            timer = nil // Explicitly set timer to nil
            
            timeTracker.isWorkTime = !timeTracker.isWorkTime
            if timeTracker.isWorkTime {
                timeTracker.currentSet += 1
            }
            if timeTracker.currentSet == timeTracker.totalSets {
                performSegue(withIdentifier: "WorkOutFinishedSegue", sender: self)
                return // Exit the function to prevent restarting the timer
            }
            updateStatus(isWorkTime: timeTracker.isWorkTime, coundownStartStop: false)
            currentTime = 0.0
            startMainTimer() // Restart or switch timers as needed
        }
    }
    
    // Function to update the time label
    private func updateTimeLabel() {
        let timeLeft = timeTracker.currentIntervalTime - currentTime
        let minutes = Int(timeLeft) / 60
        let seconds = Int(timeLeft) % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Override trait collection changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Update label color when trait collection changes
        updateLabelColor()
    }
    
    // Function to stop the timer
    @objc private func stopTimer() {
        timer?.invalidate()
        timer = nil // Ensure timer is cleared
        
        // Update UI to show finish and continue buttons
        configureStopUI()
    }
    
    // Function to finish the timer
    @objc private func finishTimer() {
        // Perform the segue with the specified identifier
        performSegue(withIdentifier: "FinishSegue", sender: self)
        stopAllOperations()
    }
    
    // Function to continue the timer
    @objc private func continueTimer() {
        // Resume the timer
        if isCountDown {
            startCountdownTimer()
        } else {
            startMainTimer()
        }
        stopButton.isHidden = false
        finishButton.isHidden = true
        continueButton.isHidden = true
    }
    
    // Function to update the "Sets Left" label
    private func updateSetsLeftLabel() {
        let setsLeft = timeTracker.totalSets - timeTracker.currentSet
        setsLeftLabel.text = "Sets Left: \(setsLeft)"
    }
    
    // Call this method to safely stop all operations and cleanup
    func stopAllOperations() {
        timer?.invalidate()
        timer = nil
    }
    
    func configureStopUI() {
        // Create "Finish" button
        finishButton.isHidden = false
        finishButton.setTitle("Finish", for: .normal)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.backgroundColor = .systemGray4
        finishButton.titleLabel?.font = UIFont(name: "Avenir", size: 21)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.layer.cornerRadius = 20
        finishButton.addTarget(self, action: #selector(finishTimer), for: .touchUpInside)
        view.addSubview(finishButton)
        
        // Create "Continue" button
        continueButton.isHidden = false
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = .systemOrange
        continueButton.titleLabel?.font = UIFont(name: "Avenir", size: 21)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.layer.cornerRadius = 20
        continueButton.addTarget(self, action: #selector(continueTimer), for: .touchUpInside)
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
        
        // Hide the original stop button
        stopButton.isHidden = true
    }
    
    // Add the deinit method
    deinit {
        timer?.invalidate()
    }
}
