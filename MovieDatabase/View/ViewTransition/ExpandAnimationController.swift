import UIKit

class ExpandAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  private let originFrame: CGRect

  init(originFrame: CGRect) {
    self.originFrame = originFrame
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 1
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let collectionViewController = transitionContext.viewController(forKey: .from) as? NowPlayingViewController else {
      return
    }
    guard let viewController = transitionContext.viewController(forKey: .to) as? MovieViewController else {
      return
    }
    guard let snapshot = collectionViewController.collectionView?.cellForItem(at: collectionViewController.movieSelectedIndex)?.snapshotView(afterScreenUpdates: true)  else {
      return
    }
    let containerView = transitionContext.containerView
    snapshot.frame = originFrame
    snapshot.layer.masksToBounds = true
    containerView.addSubview(viewController.view)
    containerView.addSubview(snapshot)
    viewController.view.alpha = 0
    let duration = transitionDuration(using: transitionContext)
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: .calculationModeCubic,
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4) {
          collectionViewController.view.alpha = 0
          let width = collectionViewController.view.frame.width
          snapshot.frame = CGRect(x: 0, y: 0, width: width, height: width * 1.5)
          snapshot.center = collectionViewController.view.center
        }
        UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/4) {
          snapshot.alpha = 0
        }
        UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
          viewController.view.alpha = 1
        }
    },
      completion: { _ in
        snapshot.removeFromSuperview()
        collectionViewController.view.alpha = 1
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}

