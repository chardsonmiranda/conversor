//
//  ConversorViewController.swift
//  Conversor
//
//  Created by Chardson Miranda on 05/10/21.
//

import UIKit

class ConversorViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, ChildViewControllerDelegate {
    //MARK: variaveis
    let deLabel: UILabel = .textLabel(text: "De: (Brazilian Real)", fontSize: 24, numberOfLines: 0)
    let deButton: UIButton = .padraoButton(title: "BRL", backgroundColor: .grayButton)
    let deTextField: UITextField = .padraoTextField(placeHolder: "0,00", placeHolderColor: .grayLabel, backGroundColor: .grayField)

    let paraLabel: UILabel = .textLabel(text: "Para: (United States Dollar)", fontSize: 24, numberOfLines: 0)
    let paraButton: UIButton = .padraoButton(title: "USD", backgroundColor: .grayButton)
    let paraTextField: UITextField = .padraoTextField(placeHolder: "0,00", placeHolderColor: .grayLabel, backGroundColor: .grayField)

    let buttonConverter: UIButton = .padraoButton(title: "Fazer Conversão", backgroundColor: .grayButton)
    
    let botaoInverter: UIButton = .padraoButton(title: " inverter", backgroundColor: .yellow)
    
    
    let viewModel = MoedaViewModel()
    var arrayMoedas = [String:String]()
    var arrayCotacao = [String:Double]()
    var cotacaoList = [CotacaoStruct]()

    let viewMain: UIView = UIView()
    var activityView: UIActivityIndicatorView = .activityView()

    //MARK: ciclo da view
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        setupTela()
        buscarMoedas()
    }
    
    @objc func setInicialScreen() {
        deLabel.text = "De: (Brazilian Real)"
        paraLabel.text = "Para: (United States Dollar)"

        deButton.setTitle("BRL", for: .normal)
        paraButton.setTitle("USD", for: .normal)

        deTextField.text = "0,00"
        paraTextField.text = "0,00"

        buscarMoedas()
    }
    
    //MARK: funcao de setup
    func setupNav() {
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.title = "Conversor de Moedas"
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .grayBackground
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)]
        navigationController?.navigationBar.prefersLargeTitles = false

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(setInicialScreen))
        navigationItem.leftBarButtonItem?.tintColor = .yellow

    }

    func setupTela() {
        deTextField.delegate = self

        deLabel.textColor = .grayLabel
        paraLabel.textColor = .grayLabel

        deTextField.keyboardType = .numberPad
        deTextField.delegate = self

        paraTextField.isEnabled = false
        
        view.backgroundColor = .grayBackground
        
        let deBotaoTextFieldStackView = UIStackView(arrangedSubviews: [deButton, deTextField])
        deBotaoTextFieldStackView.axis = .horizontal
        deBotaoTextFieldStackView.spacing = 5
        deBotaoTextFieldStackView.distribution = .fillEqually

        let deStackView = UIStackView(arrangedSubviews: [deLabel, deBotaoTextFieldStackView])
        deStackView.axis = .vertical
        deStackView.spacing = 5
        view.addSubview(deStackView)
        deStackView.preencher(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: nil,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              padding: .init(top: 20, left: 20, bottom: 10, right: 20)
        )
        
        
        
        let inverterStackView = UIStackView(arrangedSubviews: [botaoInverter])
        view.addSubview(inverterStackView)
        inverterStackView.preencher(top: deStackView.bottomAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: nil,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              padding: .init(top: 10, left: 20, bottom: 10, right: 20),
                                    size: CGSize(width: 50, height: 30)
        )

        let image = UIImage(systemName: "shuffle") as UIImage?
        botaoInverter.setImage(image, for: .normal)
        botaoInverter.backgroundColor = .clear
        botaoInverter.tintColor = .yellow
        botaoInverter.addTarget(self, action: #selector(inverterMoedas), for: .touchUpInside)
        
        let paraBotaoTextFieldStackView = UIStackView(arrangedSubviews: [paraButton, paraTextField])
        paraBotaoTextFieldStackView.axis = .horizontal
        paraBotaoTextFieldStackView.spacing = 5
        paraBotaoTextFieldStackView.distribution = .fillEqually

        let paraStackView = UIStackView(arrangedSubviews: [paraLabel, paraBotaoTextFieldStackView])
        paraStackView.axis = .vertical
        paraStackView.spacing = 5
        view.addSubview(paraStackView)
        paraStackView.preencher(top: inverterStackView.bottomAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: nil,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              padding: .init(top: 10, left: 20, bottom: 10, right: 20)
        )

        let botaoStackView = UIStackView(arrangedSubviews: [buttonConverter])
        botaoStackView.axis = .vertical
        botaoStackView.spacing = 5
        view.addSubview(botaoStackView)
        botaoStackView.preencher(top: paraStackView.bottomAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                                 bottom: nil,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              padding: .init(top: 40, left: 20, bottom: 10, right: 20),
                                 size: .init(width: .zero, height: 40)
        )

        deButton.addTarget(self, action: #selector(selecionarMoedaDe), for: .touchUpInside)
        paraButton.addTarget(self, action: #selector(selecionarMoedaPara), for: .touchUpInside)
        buttonConverter.addTarget(self, action: #selector(fazerConversao), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

    }
    
    @objc private func selecionarMoedaDe() {
        let vc = BuscarMoedaTableViewController()
        vc.modalTransitionStyle = .flipHorizontal
        vc.botaoChamada = "de"
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func selecionarMoedaPara() {
        let vc = BuscarMoedaTableViewController()
        vc.modalTransitionStyle = .flipHorizontal
        vc.botaoChamada = "para"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func inverterMoedas() {
        var moedaDeLabel = deLabel.text
        var moedaParaLabel = paraLabel.text
        
        moedaDeLabel = moedaDeLabel?.replacingOccurrences(of: "De:", with: "Para:")
        moedaParaLabel = moedaParaLabel?.replacingOccurrences(of: "Para:", with: "De:")

        let siglaDe = deButton.titleLabel?.text
        let siglaPara = paraButton.titleLabel?.text

        deLabel.text = moedaParaLabel
        paraLabel.text = moedaDeLabel
        
        deButton.setTitle(siglaPara, for: .normal)
        paraButton.setTitle(siglaDe, for: .normal)

        fazerConversao()
    }

    @objc private func fazerConversao() {
        let dataPlist = getPlistDadosOffLine()

        if (dataPlist != nil) {
            for cotacao in dataPlist!["cotacao"] as! [String : Double] {
                cotacaoList.append(CotacaoStruct(sigla: cotacao.key, valor: cotacao.value))
            }
        }

        let textBuscaDe = "USD\(deButton.title(for: .normal) ?? "")"
        let textBuscaPara = "USD\(paraButton.title(for: .normal) ?? "")"

        let buscaDe = cotacaoList.filter { ($0.sigla?.uppercased().contains(textBuscaDe.uppercased()))!}
        let buscaPara = cotacaoList.filter { ($0.sigla?.uppercased().contains(textBuscaPara.uppercased()))!}

        //A API apresenta apenas as taxas de câmbio em relação a uma moeda de referência (dólar americano - USD), caso o usuário deseje fazer uma conversão entre quaisquer outras duas moedas, será necessário primeiro converter a moeda de origem para dólar e então de dólar para a moeda desejada.

        if buscaDe.count > 0 && buscaPara.count > 0 {
            let valorDe = buscaDe[0].valor!
            let valorPara = buscaPara[0].valor!

            let valorDigitado = valorStringToDouble(valorString: self.deTextField.text ?? "0")
            let valorCalculado = valorDigitado / valorDe
            let valorFinal = valorCalculado * valorPara
            let valorFinalStr = String(format: "%.2f", valorFinal) // "3.14"

            self.paraTextField.text = currencyOutputFormatting(valor: valorFinalStr)
        }

    }

    //MARK: buscao moeda
    @objc private func buscarMoedas() {
        self.showActivityIndicator(textLabel: "Buscando informações aguarde")

        viewModel.buscarMoedas { ret, err in
            if err != nil {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.showMessage(mensagem: err!.localizedDescription)
                }
            } else {
                
                if ret != nil {
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                        self.arrayMoedas = (ret?.currencies)!
                        setPlistDadosOffLine(moeda: self.arrayMoedas, cotacao: nil, tipo: "MOEDA")
                        
                        self.buscarCotacao()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                        self.showMessage(mensagem: "Não foi possivel acessar os dados do cadastro, tente novamente mais tarde!")
                    }
                }
            }

        }
    }

    //MARK: buscao cotacao
    private func buscarCotacao() {
        self.showActivityIndicator(textLabel: "Buscando informações aguarde")

        viewModel.buscarCotacao { ret, err in
            if err != nil {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.showMessage(mensagem: err!.localizedDescription)
                }
            } else {
                
                if ret != nil {
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                        self.arrayCotacao = (ret?.quotes)!
                        
                        setPlistDadosOffLine(moeda: nil, cotacao: self.arrayCotacao, tipo: "COTACAO")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                        self.showMessage(mensagem: "Não foi possivel acessar os dados do cadastro, tente novamente mais tarde!")
                    }
                }
            }

        }
    }

    //MARK: indicators e messages
    func showActivityIndicator(textLabel: String!) {
        self.viewMain.backgroundColor = .black
        self.viewMain.alpha = 0.7
        viewMain.tag = 10
        viewMain.layer.cornerRadius = 10
        
        let label = UILabel()
        label.text = textLabel
        label.textColor = .yellow
        label.textAlignment = .center
        viewMain.addSubview(label)
        
        view.addSubview(viewMain)
        viewMain.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        viewMain.contentMode = .top
        
        activityView = UIActivityIndicatorView(style: .large)
        activityView.color = .yellow
        activityView.center = self.view.center
        self.viewMain.addSubview(activityView)
        activityView.preencherSuperview()
        activityView.startAnimating()

        label.preencher(top: activityView.safeAreaLayoutGuide.topAnchor,
                        leading: activityView.leadingAnchor,
                        bottom: nil,
                        trailing: activityView.trailingAnchor,
                        padding: .init(top: view.bounds.height / 2.5, left: 10, bottom: 50, right: 10)
        )

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

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    func childViewControllerResponse(sigla: String){
        showMessage(mensagem: "sigla: \(sigla)")
    }

}

extension ConversorViewController {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == deTextField {
            if let amountString = textField.text?.currencyInputFormatting() {
                textField.text = amountString
            }
        }

    }
}
