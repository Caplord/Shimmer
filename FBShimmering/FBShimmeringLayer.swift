//
//  FBShimmeringLayer.swift
//  AskAnna
//
//  Created by Caplord on 24/03/2017.
//  Copyright © 2017 AskAnna. All rights reserved.
//

import UIKit
import QuartzCore

class FBShimmeringMaskLayer: CAGradientLayer {
    // MARK: - Property
    let fadeLayer = CALayer()
    
    // MARK: - LifeCycle
    override init() {
        fadeLayer.backgroundColor = UIColor.white.cgColor
        super.init()
        addSublayer(fadeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fadeLayer.backgroundColor = UIColor.white.cgColor
        super.init(coder: aDecoder)
        addSublayer(fadeLayer)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let r = self.bounds
        fadeLayer.bounds = self.bounds
        fadeLayer.position = CGPoint(x: r.midX, y: r.midY)
    }
    
}

protocol FBShimmering {
    var isShimmering: Bool { get set}
    
    //! @abstract The time interval between shimmerings in seconds. Defaults to 0.4.
    var shimmeringPauseDuration: CFTimeInterval { get set}
    
    //! @abstract The opacity of the content while it is shimmering. Defaults to 1.0.
    var shimmeringAnimationOpacity: CGFloat { get set}
    
    //! @abstract The opacity of the content before it is shimmering. Defaults to 0.5.
    var shimmeringOpacity: CGFloat { get set}
    
    
    //! @abstract The speed of shimmering, in points per second. Defaults to 230.
    var shimmeringSpeed: CGFloat { get set}
    
    //! @abstract The highlight length of shimmering. Range of [0,1], defaults to 0.33.
    var shimmeringHighlightLength: CGFloat { get set}
    
    
    //! @abstract The direction of shimmering animation. Defaults to FBShimmerDirectionRight.
    var shimmeringDirection: FBShimmerDirection { get set}
    
    //! @abstract The duration of the fade used when shimmer begins. Defaults to 0.1.
    var shimmeringBeginFadeDuration: CFTimeInterval { get set}
    
    //! @abstract The duration of the fade used when shimmer ends. Defaults to 0.3.
    var  shimmeringEndFadeDuration: CFTimeInterval { get set}
    
    /**
     @abstract The absolute CoreAnimation media time when the shimmer will fade in.
     @discussion Only valid after setting {@ref shimmering} to NO.
     */
    var shimmeringFadeTime: CFTimeInterval { get set}
    
    /**
     @abstract The absolute CoreAnimation media time when the shimmer will begin.
     @discussion Only valid after setting {@ref shimmering} to YES.
     */
    var shimmeringBeginTime: CFTimeInterval { get set}
    
    //! @abstract @deprecated Same as "shimmeringHighlightLength", just for downward compatibility
    var shimmeringHighlightWidth: CGFloat { get set}
}

class FBShimmeringLayer: CALayer, FBShimmering {
    
    // MARK: - Property
    //! @abstract Set this to YES to start shimming and NO to stop. Defaults to NO.
    fileprivate var _shimmering: Bool = false
    open var  isShimmering: Bool {
        @objc(isShimmering) get {
            return _shimmering
        }
        @objc(setShimmering:) set(enabled) {
            if (enabled != _shimmering) {
                _shimmering = enabled
                self.updateShimmering()
            }
        }
    }
    
    //! @abstract The time interval between shimmerings in seconds. Defaults to 0.4.
    fileprivate var _shimmeringPauseDuration: CFTimeInterval = 0.4
    open var shimmeringPauseDuration: CFTimeInterval  {
        get {
            return _shimmeringPauseDuration
        }
        set {
            if (newValue != _shimmeringPauseDuration) {
                _shimmeringPauseDuration = newValue
                self.updateShimmering()
            }
        }
    }
    
    
    //! @abstract The opacity of the content while it is shimmering. Defaults to 1.0.
    fileprivate var _shimmeringAnimationOpacity: CGFloat = 0.5
    open var shimmeringAnimationOpacity: CGFloat  {
        get {
            return _shimmeringAnimationOpacity
        }
        set {
            if (newValue != _shimmeringAnimationOpacity) {
                _shimmeringAnimationOpacity = newValue
                self.updateShimmering()
            }
        }
    }
    
    //! @abstract The opacity of the content before it is shimmering. Defaults to 0.5.
    fileprivate var _shimmeringOpacity: CGFloat = 1
    open var shimmeringOpacity: CGFloat  {
        get {
            return _shimmeringOpacity
        }
        set {
            if (newValue != _shimmeringOpacity) {
                _shimmeringOpacity = newValue
                self.updateShimmering()
            }
        }
    }
    
    
    //! @abstract The speed of shimmering, in points per second. Defaults to 230.
    fileprivate var _shimmeringSpeed: CGFloat = 230
    open var shimmeringSpeed: CGFloat  {
        get {
            return _shimmeringSpeed
        }
        set {
            if (newValue != _shimmeringSpeed) {
                _shimmeringSpeed = newValue
                self.updateShimmering()
            }
        }
    }
    
    //! @abstract The highlight length of shimmering. Range of [0,1], defaults to 0.33.
    fileprivate var _shimmeringHighlightLength: CGFloat = 1.0
    open var shimmeringHighlightLength: CGFloat  {
        get {
            return _shimmeringHighlightLength
        }
        set {
            if (newValue != _shimmeringHighlightLength) {
                _shimmeringHighlightLength = newValue
                self.updateShimmering()
            }
        }
    }
    
    
    //! @abstract The direction of shimmering animation. Defaults to FBShimmerDirectionRight.
    fileprivate var _shimmeringDirection: FBShimmerDirection = .right
    open var shimmeringDirection: FBShimmerDirection  {
        get {
            return _shimmeringDirection
        }
        set {
            if (newValue != _shimmeringDirection) {
                _shimmeringDirection = newValue
                self.updateShimmering()
            }
        }
    }
    
    //! @abstract The duration of the fade used when shimmer begins. Defaults to 0.1.
    open var shimmeringBeginFadeDuration: CFTimeInterval = 0.1
    
    //! @abstract The duration of the fade used when shimmer ends. Defaults to 0.3.
    open var  shimmeringEndFadeDuration: CFTimeInterval = 0.3
    
    /**
     @abstract The absolute CoreAnimation media time when the shimmer will fade in.
     @discussion Only valid after setting {@ref shimmering} to NO.
     */
    open var shimmeringFadeTime: CFTimeInterval = 0
    
    /**
     @abstract The absolute CoreAnimation media time when the shimmer will begin.
     @discussion Only valid after setting {@ref shimmering} to YES.
     */
    fileprivate var _shimmeringBeginTime: CFTimeInterval = 0
    open var shimmeringBeginTime: CFTimeInterval  {
        get {
            return _shimmeringBeginTime
        }
        set {
            if (newValue != _shimmeringBeginTime) {
                _shimmeringBeginTime = newValue
                self.updateShimmering()
            }
        }
    }
    
    //! @abstract @deprecated Same as "shimmeringHighlightLength", just for downward compatibility
    open var shimmeringHighlightWidth: CGFloat {
        get {
            return _shimmeringHighlightLength
        }
        
        set {
            if (newValue != _shimmeringHighlightLength) {
                _shimmeringHighlightLength = newValue
                self.updateShimmering()
            }
        }
    }
    
    
    var _contentLayer : CALayer?
    var _maskLayer : FBShimmeringMaskLayer?
    
    var contentLayer: CALayer? {
        get {
            return _contentLayer
        }
        set {
            // reset mask
            _maskLayer = nil
            
            // note content layer and add for display
            _contentLayer = newValue
            if let layer = newValue {
                sublayers = [layer]
            }
            else {
                sublayers = nil
            }
            
            // update shimmering animation
            self.updateShimmering()
        }
    }
    
    override var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
        }
    }
    
    // MARK: - Layer lifecycle
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let r = self.bounds
        _contentLayer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        _contentLayer?.bounds = r
        _contentLayer?.position = CGPoint(x: r.midX, y: r.midY)
        
        if let _ = _maskLayer {
            self._updateMaskLayout()
        }
    }
    
    
    // MARK: - Internal
    fileprivate func updateShimmering() {
        // create mask if needed
        self._createMaskIfNeeded()
        
        // if not shimmering and no mask, noop
        if (!isShimmering && _maskLayer == nil) {
            return;
        }
        
        // ensure layout
        self.layoutIfNeeded()
        
        let disableActions = CATransaction.disableActions()
        
        
        if (!isShimmering) {
            if disableActions {
                // simply remove mask
                self._clearMask()
            } else {
                // end slide
                var slideEndTime: CFTimeInterval = CFTimeInterval(0)
                let slideAnimation = _maskLayer?.animation(forKey: kFBShimmerSlideAnimationKey)
                
                if let slideAnimation = slideAnimation {
                    // determine total time sliding
//                    let now = CACurrentMediaTime()
//                    let slideTotalDuration = now - slideAnimation.beginTime
                    
                    // determine time offset into current slide
//                    let slideTimeOffset = fmod(slideTotalDuration, slideAnimation.duration)
                    
                    // transition to non-repeating slide
                    let finishAnimation = FBShimmeringLayer.shimmerSlideFinish(slideAnimation)
                    
                    // adjust begin time to now - offset
//                    let beginTime = now - slideTimeOffset
                    
                    // note slide end time and begin
                    
                    slideEndTime = CFTimeInterval(finishAnimation.beginTime + slideAnimation.duration)
                    _maskLayer?.add(finishAnimation, forKey: kFBShimmerSlideAnimationKey)
                    
                }
                
                
                // fade in text at slideEndTime
                let fadeInAnimation = FBShimmeringLayer.fadeAnimation(_maskLayer!.fadeLayer, opacity: 1.0, duration: shimmeringEndFadeDuration)
                fadeInAnimation.delegate = self
                fadeInAnimation.setValue(true, forKey: kFBEndFadeAnimationKey)
                fadeInAnimation.beginTime = slideEndTime
                _maskLayer?.fadeLayer.add(fadeInAnimation, forKey: kFBFadeAnimationKey)
                
                // expose end time for synchronization
                shimmeringFadeTime = slideEndTime
            }
        } else {
            // fade out text, optionally animated
            var fadeOutAnimation : CABasicAnimation?
            if (shimmeringBeginFadeDuration > 0.0 && disableActions == false ) {
                fadeOutAnimation = FBShimmeringLayer.fadeAnimation(_maskLayer!.fadeLayer, opacity: 0.0, duration: shimmeringBeginFadeDuration)
                _maskLayer?.fadeLayer.add(fadeOutAnimation!, forKey: kFBFadeAnimationKey)
            }
            else {
                let innerDisableActions = CATransaction.disableActions()
                CATransaction.setDisableActions(true)
                
                _maskLayer?.fadeLayer.opacity = 0.0
                _maskLayer?.fadeLayer.removeAllAnimations()
                CATransaction.setDisableActions(innerDisableActions)
            }
            
            // begin slide animation
            let slideAnimation = _maskLayer?.animation(forKey: kFBShimmerSlideAnimationKey)
            
            
            // compute shimmer duration
            var length: CGFloat = 0.0
            switch shimmeringDirection {
            case .down, .up:
                length = _contentLayer!.bounds.height
            default:
                length = _contentLayer!.bounds.width
            }
            
            let animationDuration: CFTimeInterval = Double(length / shimmeringSpeed) + shimmeringPauseDuration
            
            if let slideAnimation = slideAnimation {
                // ensure existing slide animation repeats
                let animationSlideRepeat = FBShimmeringLayer.shimmer_slide_repeat(slideAnimation, duration: animationDuration, direction: shimmeringDirection)
                _maskLayer?.add(animationSlideRepeat, forKey: kFBShimmerSlideAnimationKey)
            } else {
                // add slide animation
                let slideAnimation = FBShimmeringLayer.shimmer_slide_animation(animationDuration, direction: shimmeringDirection);
                slideAnimation.fillMode = kCAFillModeForwards
                slideAnimation.isRemovedOnCompletion = false
                if (shimmeringBeginTime == Double(FBShimmerDefaultBeginTime)) {
                    shimmeringBeginTime = CACurrentMediaTime() + fadeOutAnimation!.duration
                }
                slideAnimation.beginTime = shimmeringBeginTime
                _maskLayer?.add(slideAnimation, forKey: kFBShimmerSlideAnimationKey)
            }
        }
    }
    
    
    fileprivate func _createMaskIfNeeded() {
        if isShimmering == true, _maskLayer == nil {
            _maskLayer = FBShimmeringMaskLayer()
            _maskLayer?.delegate = self
            _contentLayer?.mask = _maskLayer
            self._updateMaskColors()
            self._updateMaskLayout()
        }
    }
    
    
    fileprivate func _updateMaskColors() {
        guard let maskLayer = _maskLayer else {
            return
        }
         
         // We create a gradient to be used as a mask.
         // In a mask, the colors do not matter, it's the alpha that decides the degree of masking.
         let maskedColor = UIColor(white: 1.0, alpha: _shimmeringOpacity)
         let unmaskedColor = UIColor(white: 1.0, alpha: _shimmeringAnimationOpacity);
         
         // Create a gradient from masked to unmasked to masked.
        maskLayer.colors = [maskedColor.cgColor, unmaskedColor.cgColor, maskedColor.cgColor]
    }
    
    
    fileprivate func _updateMaskLayout() {
        // Everything outside the mask layer is hidden, so we need to create a mask long enough for the shimmered layer to be always covered by the mask.
        var length: CGFloat = 0.0
        if (_shimmeringDirection == .down || _shimmeringDirection == .up) {
            length = _contentLayer!.bounds.height
        }
        else {
            length = _contentLayer!.bounds.width
        }
        if (0 == length) {
            return;
        }
        
         // extra distance for the gradient to travel during the pause.
        let extraDistance: CGFloat = length + _shimmeringSpeed * CGFloat(_shimmeringPauseDuration)
         
         // compute how far the shimmering goes
        let fullShimmerLength: CGFloat = length * 3.0 + extraDistance
        let travelDistance: CGFloat = length * 2.0 + extraDistance
         
         // position the gradient for the desired width
        let highlightOutsideLength: CGFloat = (1.0 - _shimmeringHighlightLength) / 2.0
        let firstLocation = NSNumber(floatLiteral: Double(highlightOutsideLength))
        let thirdLocation = NSNumber(floatLiteral: (1 - Double(highlightOutsideLength)))
        _maskLayer?.locations = [firstLocation, NSNumber(floatLiteral: 0.5), thirdLocation]

        
        let startPoint : CGFloat = (length + extraDistance) / fullShimmerLength
        let endPoint : CGFloat = travelDistance / fullShimmerLength
        
         // position for the start of the animation
         _maskLayer?.anchorPoint = CGPoint.zero
         if (_shimmeringDirection == .down ||
            _shimmeringDirection == .up) {
            _maskLayer?.startPoint = CGPoint(x: 0, y: startPoint)
            _maskLayer?.endPoint = CGPoint(x: 0, y: endPoint)
            _maskLayer?.position = CGPoint(x: 0.0, y: -travelDistance)
            _maskLayer?.bounds = CGRect(x: 0, y: 0, width: (_contentLayer?.bounds.width)!, height: fullShimmerLength)
         } else {
            
            _maskLayer?.startPoint = CGPoint(x: startPoint, y: 0)
            _maskLayer?.endPoint = CGPoint(x: endPoint, y: 0)
            _maskLayer?.position = CGPoint(x: -travelDistance, y: 0)
            _maskLayer?.bounds = CGRect(x: 0, y: 0, width: fullShimmerLength, height: (_contentLayer?.bounds.height)!)
         }
    }
    
    internal func _clearMask() {
        if (nil == _maskLayer) {
            return;
        }
        
        let disableActions = CATransaction.disableActions()
        CATransaction.setDisableActions(true)
        
        _maskLayer = nil
        _contentLayer?.mask = nil
        CATransaction.setDisableActions(disableActions)
    }
    
    static func shimmerSlideFinish(_ a: CAAnimation) -> CAAnimation {
        let anim : CAAnimation = a.copy() as! CAAnimation
        anim.repeatCount = 0
        return anim
    }
    
    static func fadeAnimation(_ layer: CALayer, opacity: CGFloat, duration: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = (layer.presentation() ?? layer).opacity
        animation.toValue = opacity
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        animation.duration = duration
        FBShimmeringLayerAnimationApplyDragCoefficient(animation)
        return animation;
    }
    
    // take a shimmer slide animation and turns into repeating
    static func shimmer_slide_repeat(_ a: CAAnimation, duration: CFTimeInterval, direction: FBShimmerDirection) -> CAAnimation {
        let anim : CAAnimation = a.copy() as! CAAnimation
        anim.repeatCount = Float.infinity
        anim.duration = duration
        anim.speed = (direction == .right || direction == .down) ? fabsf(anim.speed) : -fabsf(anim.speed)
        return anim
    }
    
    static func shimmer_slide_animation(_ duration: CFTimeInterval, direction: FBShimmerDirection) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.toValue = NSValue(cgPoint: CGPoint.zero)
        animation.duration = duration;
        animation.repeatCount = Float.infinity;
        FBShimmeringLayerAnimationApplyDragCoefficient(animation)
        if (direction == .left ||
            direction == .up) {
            animation.speed = -fabsf(animation.speed);
        }
        return animation;
    }
    static func FBShimmeringLayerAnimationApplyDragCoefficient(_ animation: CAAnimation) {
        let k = FBShimmeringLayerDragCoefficient
        
        if (k != 0 && k != 1) {
            animation.speed = Float(CGFloat(1.0) / k)
        }
    }
    
    
    static var FBShimmeringLayerDragCoefficient: CGFloat {
        get {
            //            if Platform.isSimulator {
            //                return UIAnimationDragCoefficient()
            //            }
            //            else {
            return 1.0
            //            }
        }
    }
}

import Foundation

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
    }    
}

@available(iOS 8.0, *)
extension FBShimmeringLayer: CALayerDelegate, CAAnimationDelegate {
    @available(iOS 8.0, *)
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return nil
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let isAnmiationEndFade = anim.value(forKey: kFBEndFadeAnimationKey) as? Bool, isAnmiationEndFade == true, flag == true {
            _maskLayer?.fadeLayer.removeAnimation(forKey: kFBFadeAnimationKey)
            self._clearMask()
        }
    }
}
