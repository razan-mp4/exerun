import UIKit

class CircularProgressView: UIView {
    
    private var progressLayer: CAShapeLayer!
    
    var progress: CGFloat = 0.0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.clear
        
        // Create circular path
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                                        radius: bounds.width / 2,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 3 * CGFloat.pi / 2,
                                        clockwise: true)
        
        // Create progress layer
        progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.orange.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 20.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        
        // Add progress layer to the view's layer
        layer.addSublayer(progressLayer)
    }
    
    private func updateProgress() {
        // Update the strokeEnd property of the progress layer based on the progress value
        progressLayer.strokeEnd = progress
    }
}
