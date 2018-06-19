//
//  ZoomOutPresentAnimationController.swift
//  Movieator
//
//  Created by Matej Korman on 19/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class ZoomOutPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let finalFrame: CGRect
    private let poster: String
    
    init(finalFrame: CGRect, poster: String) {
        self.finalFrame = finalFrame
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
            let fromVC = transitionContext.viewController(forKey: .from),
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) else { return }
        
        let containerView = transitionContext.containerView
        let originFrame = transitionContext.finalFrame(for: toVC)
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame = originFrame
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 0
        imageView.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(imageView)
        containerView.addSubview(snapshot)
        snapshot.alpha = 1
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2) {
                    snapshot.alpha = 0
                }
                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 1) {
                    snapshot.frame = (self.finalFrame)
                    imageView.layer.cornerRadius = 30
                    imageView.frame = (self.finalFrame)
                }
        },
            completion: { _ in
                imageView.removeFromSuperview()
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
