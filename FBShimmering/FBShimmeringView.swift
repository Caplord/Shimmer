//
//  FBShimmeringView.swift
//  AskAnna
//
//  Created by Caplord on 31/03/2017.
//  Copyright © 2017 AskAnna. All rights reserved.
//

import Foundation
import UIKit


class FBShimmeringView: UIView {
    open var  isShimmering: Bool  {
        get {
            return (self.layer as! FBShimmeringLayer).isShimmering
        }
        set {
            (self.layer as! FBShimmeringLayer).isShimmering = newValue
        }
    }
    
    //! @abstract The time interval between shimmerings in seconds. Defaults to 0.4.
    open var shimmeringPauseDuration: CFTimeInterval {
        get {
            return (self.layer as! FBShimmeringLayer).shimmeringPauseDuration
        }
        set {
            (self.layer as! FBShimmeringLayer).shimmeringPauseDuration = newValue
        }
    }
    
    //! @abstract The opacity of the content while it is shimmering. Defaults to 1.0.
    open var shimmeringAnimationOpacity: CGFloat {
        get {
            return (self.layer as! FBShimmeringLayer).shimmeringAnimationOpacity
        }
        set {
            (self.layer as! FBShimmeringLayer).shimmeringAnimationOpacity = newValue
        }
    }
    
    //! @abstract The opacity of the content before it is shimmering. Defaults to 0.5.
    open var shimmeringOpacity: CGFloat {
        get {
            return (self.layer as! FBShimmeringLayer).shimmeringOpacity
        }
        set {
            (self.layer as! FBShimmeringLayer).shimmeringOpacity = newValue
        }
    }
    
    
    //! @abstract The speed of shimmering, in points per second. Defaults to 230.
    open var shimmeringSpeed: CGFloat {
        get {
            return (self.layer as! FBShimmeringLayer).shimmeringSpeed
        }
        set {
            (self.layer as! FBShimmeringLayer).shimmeringSpeed = newValue
        }
    }
    
    //! @abstract The highlight length of shimmering. Range of [0,1], defaults to 0.33.
    open var shimmeringHighlightLength: CGFloat   {
        get {
            return (self.layer as! FBShimmeringLayer).shimmeringHighlightLength
        }
        set {
            (self.layer as! FBShimmeringLayer).shimmeringHighlightLength = newValue
        }
    }
    
    //! @abstract The direction of shimmering animation. Defaults to FBShimmerDirectionRight.
    open var shimmeringDirection: FBShimmerDirection   {
        get {
            return (self.layer as! FBShimmeringLayer).shimmeringDirection
        }
        set {
            (self.layer as! FBShimmeringLayer).shimmeringDirection = newValue
        }
    }
    
    //! @abstract The duration of the fade used when shimmer begins. Defaults to 0.1.
    open var shimmeringBeginFadeDuration: CFTimeInterval  {
        get {
            return (self.layer as! FBShimmeringLayer).shimmeringBeginFadeDuration
        }
        set {
            (self.layer as! FBShimmeringLayer).shimmeringBeginFadeDuration = newValue
        }
    }
    
    //! @abstract The duration of the fade used when shimmer ends. Defaults to 0.3.
    open var  shimmeringEndFadeDuration: CFTimeInterval  {
        get {
            return (self.layer as! FBShimmeringLayer).shimmeringEndFadeDuration
        }
        set {
            (self.layer as! FBShimmeringLayer).shimmeringEndFadeDuration = newValue
        }
    }
    
    /**
     @abstract The absolute CoreAnimation media time when the shimmer will fade in.
     @discussion Only valid after setting {@ref shimmering} to NO.
     */
    open var shimmeringFadeTime: CFTimeInterval {
        get {
            return (self.layer as! FBShimmeringLayer).shimmeringFadeTime
        }
        set {
            (self.layer as! FBShimmeringLayer).shimmeringFadeTime = newValue
        }
    }

    /**
     @abstract The absolute CoreAnimation media time when the shimmer will begin.
     @discussion Only valid after setting {@ref shimmering} to YES.
     */
    open var shimmeringBeginTime: CFTimeInterval  {
        get {
            return (self.layer as! FBShimmeringLayer).shimmeringBeginTime
        }
        set {
            (self.layer as! FBShimmeringLayer).shimmeringBeginTime = newValue
        }
    }

    override class var layerClass: AnyClass {
        get {
            return FBShimmeringLayer.self
        }
    }
    
    var _contentView : UIView?
    var contentView : UIView? {
        get {
            return _contentView
        }
        set {
            if _contentView != newValue {
                _contentView = newValue
                if let newView = newValue {
                    self.addSubview(newView)
                }
                if let layer = self.layer as? FBShimmeringLayer {
                    layer.contentLayer = _contentView?.layer
                }
            }
        }
    }
}
