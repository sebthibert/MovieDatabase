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
    guard let movieFeedViewController = transitionContext.viewController(forKey: .from) as? MovieFeedViewController else {
      return
    }
    guard let movieViewController = transitionContext.viewController(forKey: .to) as? MovieViewController else {
      return
    }
    guard let snapshot = movieFeedViewController.collectionView?.cellForItem(at: movieFeedViewController.movieSelectedIndex)?.snapshotView(afterScreenUpdates: true)  else {
      return
    }
    let containerView = transitionContext.containerView
    snapshot.frame = originFrame
    snapshot.layer.masksToBounds = true
    containerView.addSubview(movieViewController.view)
    containerView.addSubview(snapshot)
    movieViewController.view.alpha = 0
    let duration = transitionDuration(using: transitionContext)
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: .calculationModeCubic,
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4) {
          movieFeedViewController.view.alpha = 0
          let width = movieFeedViewController.view.frame.width
          snapshot.frame = CGRect(x: 0, y: 0, width: width, height: width * 1.5)
          snapshot.center = movieFeedViewController.view.center
        }
        UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/4) {
          snapshot.alpha = 0
        }
        UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
          movieViewController.view.alpha = 1
        }
    },
      completion: { _ in
        snapshot.removeFromSuperview()
        movieFeedViewController.view.alpha = 1
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}

