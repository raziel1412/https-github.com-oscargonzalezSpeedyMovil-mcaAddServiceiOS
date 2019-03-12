//
//  AddAssociate.swift
//  mcaAddServiceiOS
//
//  Created by Omar Israel Trujillo Osornio on 2/26/19.
//  Copyright © 2019 Speedy Movil. All rights reserved.
//

import UIKit
import mcaManageriOS
import mcaUtilsiOS

class AddAssociate: UIViewController {
    private var header : UIHeaderForm = UIHeaderForm(frame: .zero)
    var lbTitleView = UILabel()
    var txtNumCta : SimpleGrayTextField!
    var txtRFC : SimpleGrayTextField!
    var imgNumCta = UIImageView()
    var imgRFC = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeElements()
    }
    
    func changeElements(){
        let marginX : CGFloat = view.frame.width * 0.10
        let textFieldHeight : CGFloat = 40

        
        self.view.backgroundColor = institutionalColors.claroWhiteColor
        self.initWith(navigationType: .IconBack, headerTitle: "Asociar")
        header.setupElements(imageName: "ico_seccion_registro", title: "Validacion de Servicio", subTitle: "Ingresa los siguientes datos para validar que seas el titual del servicio")
        header.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 250)
        view.addSubview(header)
        
        
        lbTitleView.text = "Plan TV Pro"
        lbTitleView.frame = CGRect(x: 10, y: header.frame.maxY, width: self.view.frame.width - 20, height: 40)
        lbTitleView.textAlignment = NSTextAlignment .center
        lbTitleView.font = UIFont(name: RobotoFontName.RobotoRegular.rawValue, size: CGFloat(14.0))
        lbTitleView.textColor = institutionalColors.claroTextColor
        self.view.addSubview(lbTitleView)
        
        
        
        
        
        txtNumCta = SimpleGrayTextField(text: "Numero de cuenta", placeholder: "Numero de cuenta")
        txtNumCta.frame = CGRect(x: 60, y: lbTitleView.frame.maxY + 15, width: self.view.frame.width - marginX*2 - 40, height: textFieldHeight)
        txtNumCta.tag = 1
        txtNumCta.backgroundColor = UIColor.clear
        txtNumCta.autocapitalizationType = UITextAutocapitalizationType.none
        txtNumCta.isSecureTextEntry = false
        if self.view.frame.width == 320 {
            txtNumCta.customFont = UIFont(name: RobotoFontName.RobotoRegular.rawValue, size: CGFloat(12))!
        }
        self.view.addSubview(txtNumCta)
        
        imgNumCta = UIImageView(frame: CGRect(x: 20, y: txtNumCta.frame.maxY - 30, width: 30.0, height: 30.0))
        imgNumCta.image = mcaUtilsHelper.getImage(image: "icon_boleta_off_navbar")
        imgNumCta.backgroundColor = UIColor.clear
        self.view.addSubview(imgNumCta)
        
        
        txtRFC = SimpleGrayTextField(text: "RFC", placeholder: "RFC")
        txtRFC.frame = CGRect(x: 60, y: txtNumCta.frame.maxY + 30, width: self.view.frame.width - marginX*2 - 40, height: textFieldHeight)
        txtRFC.tag = 1
        txtRFC.backgroundColor = UIColor.clear
        txtRFC.autocapitalizationType = UITextAutocapitalizationType.none
        txtRFC.isSecureTextEntry = false
        if self.view.frame.width == 320 {
            txtRFC.customFont = UIFont(name: RobotoFontName.RobotoRegular.rawValue, size: CGFloat(12))!
        }
        self.view.addSubview(txtRFC)
        
        imgRFC = UIImageView(frame: CGRect(x: 20, y: txtRFC.frame.maxY - 30, width: 30.0, height: 30.0))
        imgRFC.image = mcaUtilsHelper.getImage(image: "icon_numserie_input")
        imgRFC.backgroundColor = UIColor.clear
        self.view.addSubview(imgRFC)
        
        let btnNext = RedBackgroundButton(textButton: NSLocalizedString("Continuar", comment: ""))
        btnNext.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        btnNext.isEnabled = true
        btnNext.isUserInteractionEnabled = true
        btnNext.titleLabel?.font = UIFont(name: RobotoFontName.RobotoBold.rawValue, size: CGFloat(16.0))
        btnNext.setTitleColor(institutionalColors.claroWhiteColor , for: .normal)
        btnNext.frame = CGRect(x: 20, y: txtRFC.frame.maxY + 30, width: self.view.frame.width - 40, height: 45)
        self.view.addSubview(btnNext)
        
    }
    
    func nextPressed(){
        let vcAssociate = AddAssociate()
        self.navigationController?.pushViewController(vcAssociate, animated: true)
    }
}



