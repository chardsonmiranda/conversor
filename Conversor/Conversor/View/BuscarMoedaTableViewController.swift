//
//  BuscarMoedaTableViewController.swift
//  Conversor
//
//  Created by Chardson Miranda on 06/10/21.
//

import UIKit

protocol ChildViewControllerDelegate
{
    func childViewControllerResponse(sigla: String)
}

class BuscarMoedaTableViewController: UITableViewController, UISearchBarDelegate, UINavigationControllerDelegate {
    var delegate: ChildViewControllerDelegate?
    
    var botaoChamada = ""
    let dataPlist = getPlistDadosOffLine()
    let cellId = "cellId"
    let searchController = UISearchController(searchResultsController: nil)

    var moedasList = [MoedasStruct]()
    var moedasBusca = [MoedasStruct]()
    
    let viewMain: UIView = UIView()
    var activityView: UIActivityIndicatorView = .activityView()
    
    let refreshLabel: UILabel = .textLabel(text: "Buscando Moedas...", fontSize: 14)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .grayBackground

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .grayBackground
        tableView.separatorColor = .grayLabel

        self.tableView.register(BuscarMoedaCell.self, forCellReuseIdentifier: "cellId")

        view.addSubview(refreshLabel)

        carregaListaMoedas();
        configurarNavigation()
        configurarSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        searchController.hidesNavigationBarDuringPresentation = true

        view.addSubview(refreshLabel)
        refreshLabel.preencher(top: view.topAnchor,
                               leading: view.leadingAnchor,
                               bottom: nil,
                               trailing: view.trailingAnchor,
                               padding: .init(top: 0, left: 20, bottom: 0, right: 20),
                               size: CGSize(width: tableView.bounds.width, height: 30)
        )
        
        refreshLabel.textAlignment = .center
        self.refreshLabel.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            //navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    func carregaListaMoedas(){
        if (dataPlist != nil) {
            for moeda in dataPlist!["moedas"] as! [String : String] {
                //let dict1: [String: String] = ["sigla": moeda.key, "nome": moeda.value]
                //moedasList.append(dict1)
                
                moedasList.append(MoedasStruct(sigla: moeda.key, nome: moeda.value))
            }
            
            moedasList.sort {
                $0.nome ?? "" < $1.nome ?? ""
            }

            moedasBusca = moedasList
        }
    }
    
    func configurarNavigation(){
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.title = "Buscar Moedas"
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .grayBackground
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)]
        navigationController?.navigationBar.prefersLargeTitles = false

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "return"), style: .plain, target: self, action: #selector(voltaTapped))
        navigationItem.leftBarButtonItem?.tintColor = .yellow

    }
    
    func configurarSearchBar() {
        
        navigationItem.searchController = self.searchController
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Digite a sigla e/ou nome da moeda..."
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.barTintColor = .red
        self.searchController.searchBar.tintColor = .yellow
        
        self.searchController.searchBar.searchTextField.defaultTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        if #available(iOS 13.0, *) {
            self.searchController.searchBar.searchTextField.leftView?.tintColor = .yellow
        }
    }
    //MARK: acao
    @objc private func voltaTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: search
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.moedasBusca = self.moedasList
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filtraMoedas(texto: searchText)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moedasBusca.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BuscarMoedaCell

        // Create String
        cell.setupCell(sigla: moedasBusca[indexPath.item].sigla!, nome: moedasBusca[indexPath.item].nome!)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        //self.delegate?.childViewControllerResponse(sigla: moedasBusca[indexPath.item].sigla!)
        
        //self.navigationController?.popViewController(animated: true)
        //guard let vc = navigationController?.topViewController as? ConversorViewController else { return }
//        let vc = ConversorViewController()
//        vc.siglaRetorno = moedasBusca[indexPath.item].sigla!
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        let viewController = self.navigationController?.viewControllers[0] as! ConversorViewController
        
        if botaoChamada == "de" {
            viewController.deButton.setTitle(moedasBusca[indexPath.item].sigla!, for: .normal)
            viewController.deLabel.text = "De: (\(moedasBusca[indexPath.item].nome!))"
        } else {
            viewController.paraButton.setTitle(moedasBusca[indexPath.item].sigla!, for: .normal)
            viewController.paraLabel.text = "Para: (\(moedasBusca[indexPath.item].nome!))"
        }
        
        self.navigationController?.popViewController(animated: true)

        
    }
}

extension BuscarMoedaTableViewController{
    func filtraMoedas (texto: String){
        //BuscaService.shared.buscaApps(texto: texto)

        print(texto)
        
        if texto == "" {
            moedasBusca = moedasList
            
        } else {

            moedasBusca = moedasList.filter { ($0.sigla?.uppercased().contains(texto.uppercased()))! || ($0.nome?.uppercased().contains(texto.uppercased()))! }

            moedasBusca.sort {
                $0.nome ?? "" < $1.nome ?? ""
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


    //MARK: indicators
    func showActivityIndicator(textLabel: String!) {
        self.viewMain.backgroundColor = .black
        self.viewMain.alpha = 0.7
        viewMain.tag = 10
        viewMain.layer.cornerRadius = 10
        view.addSubview(viewMain)
        viewMain.frame = CGRect(x: (view.bounds.width / 2) - 40, y: 130, width: 80, height: 80)
        viewMain.contentMode = .center
        
        activityView = UIActivityIndicatorView(style: .large)
        activityView.color = .purple
        activityView.center = self.view.center
        self.viewMain.addSubview(activityView)
        activityView.preencherSuperview()
        activityView.startAnimating()

    }

    func hideActivityIndicator(){
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
        }
        DispatchQueue.main.async {
            if let viewWithTag = self.view.viewWithTag(10) {
                viewWithTag.removeFromSuperview()
            }
        }
    }

    private func showMessage (mensagem: String) {
        let dialogMessage = UIAlertController(title: "Atenção", message: mensagem, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        dialogMessage.addAction(ok)
        DispatchQueue.main.async {
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }

}
