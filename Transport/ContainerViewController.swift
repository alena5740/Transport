//
//  ContainerViewController.swift
//  Transport
//
//  Created by Алена on 26.02.2022.
//

import UIKit

// Контейнер для экрана с картами
class ContainerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let contentViewController: MapViewController
    private let bottomSheetViewController: TransportInfoViewController
    
    private var topConstraint = NSLayoutConstraint()
    private let height: CGFloat
    private let initialOffset: CGFloat
    
    private var state: BottomSheetState = .initial
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.delegate = self
        pan.addTarget(self, action: #selector(handlePan))
        return pan
    }()
    
    private enum BottomSheetState {
        case initial
        case full
    }
    
    init(contentViewController: MapViewController,
         bottomSheetViewController: TransportInfoViewController) {
        
        self.contentViewController = contentViewController
        self.bottomSheetViewController = bottomSheetViewController
        
        self.height = UIScreen.main.bounds.height * 0.4
        self.initialOffset = UIWindow().safeAreaInsets.bottom + 105
        
        super.init(nibName: nil, bundle: nil)
        
        self.setupContentViewController()
        self.setupBottomSheetViewController()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    private func showBottomSheet(animated: Bool = true) {
        self.topConstraint.constant = -height
        
        if animated {
            UIView.animate(withDuration: 0.2, animations:  {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.state = .full
            })
        } else {
            self.view.layoutIfNeeded()
            self.state = .full
        }
    }
    
    private func hideBottomSheet(animated: Bool = true) {
        self.topConstraint.constant = -initialOffset
        
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseOut],
                           animations: {
                            self.view.layoutIfNeeded()
            }, completion: { _ in
                self.state = .initial
            })
        } else {
            self.view.layoutIfNeeded()
            self.state = .initial
        }
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: bottomSheetViewController.view)
        let velocity = sender.velocity(in: bottomSheetViewController.view)
        
        let yTranslationMagnitude = translation.y.magnitude
        switch sender.state {
        case .began, .changed:
            if self.state == .full {
                guard translation.y > 0 else { return }
                
                topConstraint.constant = -(height - yTranslationMagnitude)
                
                self.view.layoutIfNeeded()
            } else {
                let newConstant = -(initialOffset + yTranslationMagnitude)
                
                guard translation.y < 0 else { return }
                guard newConstant.magnitude < height else {
                    self.showBottomSheet()
                    return
                }
                topConstraint.constant = newConstant
                
                self.view.layoutIfNeeded()
            }
        case .ended:
            if self.state == .full {
                if velocity.y < 0 {
                    self.showBottomSheet()
                } else if yTranslationMagnitude >= height / 2 || velocity.y > 1000 {
                    self.hideBottomSheet()
                } else {
                    self.showBottomSheet()
                }
            } else {
                if yTranslationMagnitude >= height / 2 || velocity.y < -1000 {
                    self.showBottomSheet()
                } else {
                    self.hideBottomSheet()
                }
            }
        case .failed:
            if self.state == .full {
                self.showBottomSheet()
            } else {
                self.hideBottomSheet()
            }
        default: break
        }
    }
    
    private func setupContentViewController() {
        self.addChild(contentViewController)
        self.view.addSubview(contentViewController.view)
        makeConstraintsContentViewController()
        contentViewController.didMove(toParent: self)
    }
    
    private func makeConstraintsContentViewController() {
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentViewController.view.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            contentViewController.view.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            contentViewController.view.topAnchor
                .constraint(equalTo: self.view.topAnchor),
            contentViewController.view.bottomAnchor
                .constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setupBottomSheetViewController() {
        self.addChild(bottomSheetViewController)
        self.view.addSubview(bottomSheetViewController.view)
        bottomSheetViewController.view.addGestureRecognizer(panGesture)
        makeConstraintsBottomSheetViewController()
        bottomSheetViewController.didMove(toParent: self)
    }
    
    private func makeConstraintsBottomSheetViewController() {
        bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        topConstraint = bottomSheetViewController.view.topAnchor
            .constraint(equalTo: self.view.bottomAnchor,
                        constant: -initialOffset)
        
        NSLayoutConstraint.activate([
            bottomSheetViewController.view.heightAnchor
                .constraint(equalToConstant: height),
            bottomSheetViewController.view.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            bottomSheetViewController.view.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            topConstraint
        ])
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
