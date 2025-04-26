import UIKit

final class SideMenuAnimator: SideMenuAnimatorProtocol {
    func animate(
        view: UIView,
        isOpen: Bool,
        configuration: SideMenuConfiguration,
        blurView: UIVisualEffectView?,
        completion: (() -> Void)?
    ) {
        let scale = isOpen ? configuration.menuScaleFactor : 1.0
        let x = isOpen ? configuration.menuWidth : 0
        let y = isOpen ? configuration.menuYOffset : 0

        UIView.animate(
            withDuration: configuration.animationDuration,
            delay: 0,
            usingSpringWithDamping: configuration.springDamping,
            initialSpringVelocity: configuration.initialSpringVelocity
        ) {
            let transform = CGAffineTransform.identity
                .translatedBy(x: x, y: y)
                .scaledBy(x: scale, y: scale)

            view.transform = transform
            view.layer.cornerRadius = isOpen ? configuration.cornerRadius : 0
            blurView?.alpha = isOpen ? 0.9 : 0

            view.layoutIfNeeded()

            completion?()
        }
    }
}
