import UIKit

extension UIImageView {
  // MARK: - Computed Properties
  var animatableImage: YQGifImage? {
    if image is YQGifImage {
      return image as? YQGifImage
    } else {
      return nil
    }
  }

  var isAnimating: Bool {
    return animatableImage?.isAnimating() ?? false
  }

  var animatable: Bool {
    return animatableImage != nil
  }

  override public func displayLayer(layer: CALayer!) {
    if let image = animatableImage {
      if let frame = image.currentFrame {
        layer.contents = frame.CGImage
      }
    }
  }

  func setAnimatableImage(named name: String) {
    image = YQGifImage.imageWithName(name, delegate: self)
    layer.setNeedsDisplay()
  }

  func setAnimatableImage(#data: NSData) {
    image = YQGifImage.imageWithData(data, delegate: self)
    layer.setNeedsDisplay()
  }

  /**
    Control Animation to start
  */
  func startAnimating() {
    if animatable {
      animatableImage!.resumeAnimation()
    }
  }

  /**
    Control Animation to stop
  */
  func stopAnimating() {
    if animatable {
      animatableImage!.pauseAnimation()
    }
  }
}
