//
//  ScaleUpPresentAnimationController.swift
//  Movieator
//
//  Created by Matej Korman on 18/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class ZoomInPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let originFrame: CGRect
    private let poster: String
    
    init(originFrame: CGRect, poster: String) {
        self.originFrame = originFrame
        self.poster = poster
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let posterFetcher = MoviePosterFetcher()
        posterFetcher.fetchMoviePoster(with: poster,
            success: { [weak self] data in
                if let image = UIImage(data: data) {
                    self?.animateTransition(using: transitionContext, withImage: image)
                }
            },
           failure: { error in
                print("Error getting poster, \(error)")
        })
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning, withImage image: UIImage) {
        guard let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else { return }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = originFrame
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        
        containerView.addSubview(imageView)
        containerView.addSubview(snapshot)
        containerView.addSubview(toVC.view)
        snapshot.alpha = 0
        snapshot.frame = originFrame
        toVC.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.9) {
                    imageView.layer.cornerRadius = 0
                    imageView.frame = finalFrame
                    snapshot.frame = finalFrame
                }
                UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1) {
                    snapshot.alpha = 1
                }
        },
            completion: { _ in
                toVC.view.isHidden = false
                imageView.removeFromSuperview()
                snapshot.removeFromSuperview()
                toVC.view.addSubview(imageView)
                toVC.view.sendSubview(toBack: imageView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
