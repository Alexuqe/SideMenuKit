import UIKit

@MainActor
public final class SideMenuController: NSObject {
    public weak var delegate: SideMenuDelegate?

    private let configuration: SideMenuConfiguration
    private let menuViewController: SideMenuViewController
    private let containerView: UIView
    private let contentViewController: UIViewController

    private var blurView: UIVisualEffectView?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var panGestureRecognizer: UIPanGestureRecognizer?

    private var isMenuOpen = false
    private var contentViewOriginalTransform = CGAffineTransform.identity

    public init(
        configuration: SideMenuConfiguration,
        contentViewController: UIViewController,
        containerView: UIView
    ) {
        self.configuration = configuration
        self.contentViewController = contentViewController
        self.containerView = containerView
        self.menuViewController = SideMenuViewController(configuration: configuration)
        super.init()

        setupHierarchy()
        setupGestures()
    }

    public func toggleMenu() {
        isMenuOpen ? hideMenu() : showMenu()
    }

    public func updateConfiguration(_ newConfig: SideMenuConfiguration) {
        menuViewController.updateConfiguration(newConfig)
        adjustLayoutForCurrentOrientation()
    }
}

    // MARK: - Setup
private extension SideMenuController {
    func setupHierarchy() {
        menuViewController.view.frame = CGRect(
            x: -configuration.appearance.menuWidth,
            y: 0,
            width: configuration.appearance.menuWidth,
            height: containerView.bounds.height
        )

        containerView.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: contentViewController)

        setupBlurEffect()
    }

    func setupBlurEffect() {
        guard let blurEffect = configuration.appearance.blurEffect else { return }

        blurView = UIVisualEffectView(effect: blurEffect)
        blurView?.frame = containerView.bounds
        blurView?.alpha = 0
        containerView.insertSubview(blurView!, belowSubview: menuViewController.view)
    }

    func setupGestures() {
        tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )

        tapGestureRecognizer?.delegate = self
        blurView?.addGestureRecognizer(tapGestureRecognizer!)
    }
}

    // MARK: - Animation Handling
extension SideMenuController {
    private func showMenu() {
        guard !isMenuOpen else { return }
        animateMenu(show: true)
    }

    public func hideMenu() {
        guard isMenuOpen else { return }
        animateMenu(show: false)
    }

    private func animateMenu(show: Bool) {
        let scale = show ? configuration.animation.contentScaleFactor : 1.0
        let offsetX = show ? configuration.animation.menuOffsetX : 0
        let offsetY = show ? configuration.animation.menuOffsetY : 0
        let corner = show ? configuration.animation.cornerRadius : 0
        let blurAlpha = show ? configuration.animation.blurAlpha : 0

        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let translationTransform = CGAffineTransform(translationX: offsetX, y: offsetY)
        let combinedTransform = translationTransform.concatenating(scaleTransform)

        contentViewController.view.layer.masksToBounds = true

        UIView.animate(
            withDuration: configuration.animation.duration,
            delay: 0,
            usingSpringWithDamping: configuration.animation.dampingRatio,
            initialSpringVelocity: 0
        ) { [weak self] in
            guard let self = self else { return }

            self.contentViewController.view.transform = combinedTransform
            self.menuViewController.view.frame.origin.x = show ? 0 : -self.configuration.appearance.menuWidth
            self.contentViewController.view.layer.cornerRadius = corner
            self.blurView?.alpha = blurAlpha
        } completion: { [weak self] _ in
            self?.isMenuOpen = show
            self?.delegate?.menuStateChanged(isOpen: show)
        }
    }
}

    // MARK: - Gesture Handling
extension SideMenuController: UIGestureRecognizerDelegate {
    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        hideMenu()
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return isMenuOpen || gestureRecognizer == panGestureRecognizer
    }
}

    // MARK: - Rotation Handling
extension SideMenuController {
    private func adjustLayoutForCurrentOrientation() {
        let menuWidth = configuration.appearance.menuWidth
        menuViewController.view.frame.size.width = menuWidth
        menuViewController.view.frame.origin.x = isMenuOpen ? 0 : -menuWidth
        blurView?.frame = containerView.bounds
    }
}
