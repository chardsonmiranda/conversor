//
//  BaseTabbarViewController.swift
//  Conversor
//
//  Created by Chardson Miranda on 05/10/21.
//


import UIKit

class BaseTabbarViewController: UITabBarController, UITabBarControllerDelegate {
    private let viewModel = InicioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let conversorViewController = self.criarTabItem(viewController: ConversorViewController(), titulo: "Conversor de Moedas", imagem: "dollarsign.circle")

        viewControllers = [
            conversorViewController
        ]
        
        viewModel.criarPlistouDadosOffLine()
        
        selectedIndex = 0
        tabBar.backgroundColor = .black
        self.delegate = self
    }

    func criarTabItem(viewController: UIViewController, titulo: String, imagem: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = false
        
        viewController.navigationItem.title = titulo
        viewController.tabBarItem.title = titulo
        viewController.tabBarItem.image = UIImage(systemName: imagem)
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .white
        return navController
        
    }
}
