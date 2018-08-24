import UIKit

class FloatingActionItem: UIView {

  let size: CGFloat = 42
  let circleLayer: CAShapeLayer = CAShapeLayer()
  let titleLabel = UILabel()

  var handler: (() -> Void)? = nil
  var title: String? = nil
  var icon: UIImage? = nil
  var floatingActionView: FloatingActionView? = nil

  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    backgroundColor = UIColor.clear
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    createCircleLayer()
    setupTitleLabel()
    setupIconImageView()
    setupShadow()
    setupTapGestures()
  }

  func setupTapGestures() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
    titleLabel.addGestureRecognizer(tapGesture)
    addGestureRecognizer(tapGesture)
  }

  @objc func tapped() {
    floatingActionView!.closeOverlay()
    handler?()
  }

  func createCircleLayer() {
    circleLayer.frame = CGRect(x: size/2 - (size/2), y: 0, width: size, height: size)
    circleLayer.backgroundColor = UIColor.white.cgColor
    circleLayer.cornerRadius = size/2
    layer.addSublayer(circleLayer)
  }

  func setupTitleLabel() {
    titleLabel.text = title
    titleLabel.textColor = .white
    titleLabel.sizeToFit()
    titleLabel.frame.origin.x = -titleLabel.frame.size.width - 10
    titleLabel.frame.origin.y = size/2-titleLabel.frame.size.height/2
    titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
    addSubview(titleLabel)
    bringSubview(toFront: titleLabel)
  }

  func setupIconImageView() {
    let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    iconImageView.image = icon
    iconImageView.center = CGPoint(x: size/2, y: size/2)
    iconImageView.contentMode = UIViewContentMode.scaleAspectFill
    addSubview(iconImageView)
    bringSubview(toFront: iconImageView)
  }

  func setupShadow() {
    circleLayer.shadowOffset = CGSize(width: 1, height: 1)
    circleLayer.shadowRadius = 2
    circleLayer.shadowColor = UIColor.black.cgColor
    circleLayer.shadowOpacity = 0.4
    titleLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
    titleLabel.layer.shadowRadius = 2
    titleLabel.layer.shadowColor = UIColor.black.cgColor
    titleLabel.layer.shadowOpacity = 0.4
  }
}
