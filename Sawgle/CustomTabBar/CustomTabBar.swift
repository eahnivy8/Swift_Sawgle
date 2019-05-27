//
//  CustomTabBar.swift
//  Sawgle
//
//  Created by Meo MacBook Pro on 27/05/2019.
//  Copyright © 2019 Meo MacBook Pro. All rights reserved.
//

import UIKit

class CustomTabBar: UIViewController {
    
    var homeVC: HomeViewController?
    var boomarkVC: BookMarkViewController?
    var mywriteVC: MyWriteHistoryViewController?
    var settingVC: SettingViewController?
    var navigation: UINavigationController?
    var vcList = [UIViewController]()
    var prevIndex: Int?
    
    @objc func linkAction(_ sender: UIButton) {
        checkView()
        prevIndex = sender.tag
        moveView(sender.tag)
    }
    
    /// 새로운 뷰를 만들기 전에 기본의 뷰가 있으면 그 뷰를 제거한다.
    func checkView() {
        
        guard let prevSelectedIndex = prevIndex else {
            return
        }
        
        navigation?.willMove(toParent: nil)
        navigation?.view.removeFromSuperview()
        navigation?.removeFromParent()
        
        vcList[prevSelectedIndex].willMove(toParent: nil)
        vcList[prevSelectedIndex].view.removeFromSuperview()
        vcList[prevSelectedIndex].removeFromParent()
        
    }
    
    /// 새로운 뷰로 이동한다.
    func moveView(_ index: Int) {
        
        guard let targetView = view as? CustomTabBarView else {
            return
        }
        
        addChild(vcList[index])
        vcList[index].view.frame = targetView.contentView.bounds
        
        
        let newNavigation = UINavigationController(rootViewController: vcList[index])
        newNavigation.navigationBar.barTintColor = .white
        newNavigation.navigationBar.tintColor = .white
        

        navigation = newNavigation
        
        targetView.contentView.addSubview(newNavigation.view)

        vcList[index].didMove(toParent: self)
        
    }
    
    @objc func moveWriteView() {
        
        let writeView = WriteViewController()
        present(writeView,animated: true)
    }
    
    ///각 탭바의 아이템들을 액션에 연결한다.
    func linkTargetAction() {
        
        guard let targetView = view as? CustomTabBarView else {
            return
        }
        
        if let firtButton = targetView.leftStack.firstItem as? ButtonStack {
            firtButton.button.addTarget(self, action: #selector(linkAction), for: .touchUpInside)
           firtButton.button.tag = 0
        }
        if let secondButton = targetView.leftStack.secondItem as? ButtonStack {
            secondButton.button.addTarget(self, action: #selector(linkAction), for: .touchUpInside)
            secondButton.button.tag = 1
        }
        if let thirdButton = targetView.rightStack.firstItem as? ButtonStack {
            thirdButton.button.addTarget(self, action: #selector(linkAction), for: .touchUpInside)
            thirdButton.button.tag = 2
        }
        if let fourButton = targetView.rightStack.secondItem as? ButtonStack {
            fourButton.button.addTarget(self, action: #selector(linkAction), for: .touchUpInside)
             fourButton.button.tag = 3
        }
  
        
        targetView.centerButton.addTarget(self, action: #selector(moveWriteView), for: .touchUpInside)
        
    }
    
    func makeViewList() {
        
        guard let views = [homeVC, boomarkVC, mywriteVC, settingVC] as? [UIViewController] else {
            return
        }
        
        vcList = views
    }
    
    override func loadView() {
        view = CustomTabBarView()
    }
    
    override func viewDidLoad() {
        
        homeVC = HomeViewController()
        boomarkVC = BookMarkViewController()
        mywriteVC = MyWriteHistoryViewController()
        settingVC = SettingViewController()
        
        makeViewList()
        linkTargetAction()
    }
    
    /// 뷰가 로딩이 다 되고 난 뒤 기본 뷰를 셋팅한다.
    override func viewDidAppear(_ animated: Bool) {
        
        if prevIndex == nil {
            prevIndex = 0
            moveView(0)
        }
        
    }
}
extension UIView {
    
    func makeLogoView() -> UIImageView {
        let logo = UIImage(named: "logo")
        let logoImageView = UIImageView(image:logo)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor).isActive = true
        return logoImageView
    }
}