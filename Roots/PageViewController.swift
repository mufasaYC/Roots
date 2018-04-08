//
//  PageViewController.swift
//  Roots
//
//  Created by Mustafa Yusuf on 08/04/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    lazy var viewControllerList:[UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier: "Status")
        
        let vc2 = sb.instantiateViewController(withIdentifier: "Profile")
        
        return [vc1]
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.delegate = self
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            
        }
        
    }
    
}

extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else { return nil}
        
        guard  viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]
    }
    
}

extension UIPageViewController {
    
    func goToPage(id: String, direction: UIPageViewControllerNavigationDirection) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: id)
        setViewControllers([vc1], direction: direction, animated: true, completion: nil)
    }
}


