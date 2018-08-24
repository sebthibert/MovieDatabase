import UIKit

class FloatingActionView: UIView {
  let size: CGFloat = 56
  let padding: CGFloat = 20
  let circleLayer: CAShapeLayer = CAShapeLayer()
  let overlayView : UIControl = UIControl()

  var items: [FloatingActionItem] = []
  var buttonImage = UIImage()
  var buttonText = ""
  var overlayClosed = true

  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    backgroundColor = .clear
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    setupTapGestures()
    setRightBottomFrame()
    setCircleLayer()
    setShadow()
    buttonText != "" ? setButtonText() : setButtonImage()
  }

  func setupTapGestures() {
    let floatingActionTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
    let overlayTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
    addGestureRecognizer(floatingActionTapGesture)
    overlayView.addGestureRecognizer(overlayTapGesture)
  }

  @objc func tapped() {
    toggle()
  }

  func toggle() {
    overlayClosed ? openOverlay() : closeOverlay()
  }

  func openOverlay() {
    setOverlayView()
    superview?.addSubview(overlayView)
    superview?.bringSubview(toFront: self)
    overlayView.alpha = 1
    popAnimationWithOpen()
    overlayClosed = false
  }

  func closeOverlay() {
    overlayView.removeFromSuperview()
    popAnimationWithClose()
    overlayClosed = true
  }

  func addItem(_ title: String, icon: UIImage?, handler: @escaping (() -> Void)) {
    let item = FloatingActionItem()
    item.title = title
    item.icon = icon
    item.handler = handler
    item.frame.origin = CGPoint(x: size / (2 - (item.size / 2)), y: size / (2 - (item.size / 2)))
    item.alpha = 0
    item.floatingActionView = self
    items.append(item)
    addSubview(item)
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    if !overlayClosed {
      for item in items {
        var itemPoint = item.convert(point, from: self)
        let tapArea = determineTapArea(item: item)
        if tapArea.contains(itemPoint) {
          itemPoint = item.bounds.origin
          return item.hitTest(itemPoint, with: event)
        }
      }
    }

    return super.hitTest(point, with: event)
  }

  private func determineTapArea(item : FloatingActionItem) -> CGRect {
    let tappableMargin : CGFloat = 30.0
    let x = item.titleLabel.frame.origin.x + item.bounds.origin.x
    let y = item.bounds.origin.y
    let width = item.titleLabel.bounds.size.width + item.bounds.size.width + tappableMargin
    let height = item.bounds.size.height
    return CGRect(x: x, y: y, width: width, height: height)
  }

  private func setCircleLayer() {
    circleLayer.removeFromSuperlayer()
    circleLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
    circleLayer.backgroundColor = UIColor.lightGray.cgColor
    circleLayer.cornerRadius = size/2
    layer.addSublayer(circleLayer)
  }

  private func setButtonText() {
    let buttonLabel = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size))
    buttonLabel.textColor = .white
    buttonLabel.font = .systemFont(ofSize: 15)
    buttonLabel.textAlignment = .center
    buttonLabel.removeFromSuperview()
    buttonLabel.center = CGPoint(x: size/2, y: size/2)
    buttonLabel.text = buttonText
    addSubview(buttonLabel)
  }

  private func setButtonImage() {
    let buttonImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
    buttonImageView.removeFromSuperview()
    buttonImageView.center = CGPoint(x: size/2, y: size/2)
    buttonImageView.image = buttonImage
    addSubview(buttonImageView)
  }

  private func setOverlayView() {
    setOverlayFrame()
    overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    overlayView.alpha = 0
    overlayView.isUserInteractionEnabled = true
  }

  private func setOverlayFrame() {
    if let superview = superview {
      overlayView.frame = CGRect(x: 0,y: 0, width: superview.bounds.width, height: superview.bounds.height)
    }
  }

  private func setShadow() {
    circleLayer.shadowOffset = CGSize(width: 1, height: 1)
    circleLayer.shadowRadius = 2
    circleLayer.shadowColor = UIColor.black.cgColor
    circleLayer.shadowOpacity = 0.4
  }

  private func setRightBottomFrame() {
    frame = CGRect(x: (superview!.bounds.size.width-size) - padding, y: (superview!.bounds.size.height-size) - padding, width: size + padding, height: size + padding)
  }

  private func popAnimationWithOpen() {
    var itemHeight: CGFloat = 0
    var delay = 0.0
    for item in items {
      itemHeight += item.size + 14
      item.layer.transform = CATransform3DIdentity
      let big = size > item.size ? size : item.size
      let small = size <= item.size ? size : item.size
      item.frame.origin.x = big/2-small/2
      item.frame.origin.y = -itemHeight
      item.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
      UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3, options: [], animations: { () -> Void in
        item.layer.transform = CATransform3DIdentity
        item.alpha = 1
      })

      delay += 0.1
    }
  }

  private func popAnimationWithClose() {
    var delay = 0.0
    for item in items.reversed() {
      UIView.animate(withDuration: 0.15, delay: delay, options: [], animations: {
        item.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
        item.alpha = 0
      })
      delay += 0.1
    }
  }
}
