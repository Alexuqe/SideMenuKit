import UIKit

extension UIView {
    func applyCornerRadius(_ radius: CGFloat, animated: Bool = false) {
        guard animated else {
            layer.cornerRadius = radius
            return
        }

        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fromValue = layer.cornerRadius
        animation.toValue = radius
        animation.duration = 0.25
        layer.add(animation, forKey: "cornerRadius")
        layer.cornerRadius = radius
    }
}
