import UIKit

/// Default animator for the side menu transitions.
///
/// This class handles the animation of the menu opening and closing,
/// including scaling, translation, and blur effects.
///
/// The animator uses spring animations to create a natural, dynamic feel
/// when the menu opens and closes. It combines multiple transformations:
/// - Translation to slide the main view
/// - Scale to create a depth effect
/// - Corner radius animation for polish
/// - Optional blur effect
///
/// Example usage:
/// ```swift
/// let animator = SideMenuAnimator()
/// animator.animate(
///     view: mainView,
///     isOpen: true,
///     configuration: config,
///     blurView: blurEffectView
/// ) {
///     // Animation completed
/// }
/// ```
final class SideMenuAnimator: SideMenuAnimatorProtocol {
    
    /// Animates the menu's open/close transition.
    ///
    /// This method combines several animations to create a polished transition:
    /// 1. Translates the main view to reveal/hide the menu
    /// 2. Scales the main view to create a depth effect
    /// 3. Applies corner radius for visual polish
    /// 4. Fades the blur effect if present
    ///
    /// - Parameters:
    ///   - view: The main view to animate (typically the root view or navigation controller view)
    ///   - isOpen: Whether to animate to the open state (true) or closed state (false)
    ///   - configuration: Configuration parameters for the animation
    ///   - blurView: Optional blur effect view to fade in/out during the animation
    ///   - completion: Optional closure to call when the animation completes
    func animate(
        view: UIView,
        isOpen: Bool,
        configuration: SideMenuConfiguration,
        blurView: UIVisualEffectView?,
        completion: (() -> Void)?
    ) {
        // Calculate the final transform
        let scale = isOpen ? configuration.menuScaleFactor : 1.0
        let x = isOpen ? configuration.menuWidth : 0
        let y = isOpen ? configuration.menuYOffset : 0

        // Combine scale and translation transforms
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let translation = CGAffineTransform(translationX: x, y: y)
        let combined = translation.concatenating(scaleTransform)

        // Set initial corner radius
        view.layer.cornerRadius = isOpen ? configuration.cornerRadius : 0

        // Perform the animation
        UIView.animate(
            withDuration: configuration.animationDuration,
            delay: 0,
            usingSpringWithDamping: configuration.springDamping,
            initialSpringVelocity: configuration.initialSpringVelocity
        ) {
            // Apply transforms
            view.transform = combined
            view.layer.cornerRadius = isOpen ? configuration.cornerRadius : 0
            
            // Animate blur effect if present
            blurView?.alpha = isOpen ? 0.9 : 0
            
            // Ensure layout updates are applied
            view.layoutIfNeeded()
            
            // Call completion handler if provided
            completion?()
        }
    }
}
