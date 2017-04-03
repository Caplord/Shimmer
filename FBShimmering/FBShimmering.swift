//
//  FBShimmering.swift
//  AskAnna
//
//  Created by Caplord on 03/04/2017.
//  Copyright © 2017 AskAnna. All rights reserved.
//

enum FBShimmerDirection {
    case right    // Shimmer animation goes from left to right
    case left     // Shimmer animation goes from right to left
    case up       // Shimmer animation goes from below to above
    case down     // Shimmer animation goes from above to below
    
}

// animations keys
let kFBShimmerSlideAnimationKey = "slide"
let kFBFadeAnimationKey = "fade"
let kFBEndFadeAnimationKey = "fade-end"
let FBShimmerDefaultBeginTime: Float = Float.infinity
