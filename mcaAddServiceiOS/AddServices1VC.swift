//
//  AddServices1VC.swift
//  mcaAddServiceiOS
//
//  Created by Omar Israel Trujillo Osornio on 2/25/19.
//  Copyright © 2019 Speedy Movil. All rights reserved.
//

import UIKit
import mcaUtilsiOS
import mcaManageriOS
import DLRadioButton

public class AddServices1VC : UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    private var header : UIHeaderForm = UIHeaderForm(frame: .zero)
    let btnRadioYes = MyDLRadioButton()
    ///Objeto del check de la opcion lbNo
    let btnRadioNo = MyDLRadioButton()
    ///Etiqueta que muestra la variable del archivo de config yes
    let lbYes = UILabel()
    ///Etiqueta que muestra la variable del archivo de config no
    let lbNo =  UILabel()
    var lbTitleHeader = UILabel()
    var txtServices = UITextField()
    public var imageHeader = UIImageView()
    let lbTitleTextfieldPeriods = UILabel()
    let tableServices : UITableView = UITableView()

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.changeElements()
    }

    func changeElements(){
    
        self.view.backgroundColor = institutionalColors.claroWhiteColor
        self.initWith(navigationType: .IconBack, headerTitle: "Agregar Servicio")
        header.setupElements(imageName: "ico_seccion_registro", title: "Elige un servicios", subTitle: "Selecciona uno de los servicios autodetectadoso agrega uno manualmente")
        header.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 250)
        view.addSubview(header)
        
        
        btnRadioYes.frame = CGRect (x: 20, y: header.frame.maxY + 10 ,width: 25, height: 25)
        btnRadioYes.iconColor = institutionalColors.claroBlueColor
        btnRadioYes.indicatorColor = institutionalColors.claroBlueColor
        btnRadioYes.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btnRadioNo.isSelected = false
        view.addSubview(btnRadioYes)
        //btnRadioYes.addTarget(self, action: #selector(self.radioButtonPressed(radioButton:)), for: UIControlEvents.touchUpInside)
        
        lbYes.frame = CGRect(x: btnRadioYes.frame.maxX + 80, y: header.frame.maxY, width: 140, height: 40)
        lbYes.textAlignment = NSTextAlignment .left
        lbYes.font = UIFont(name: RobotoFontName.RobotoRegular.rawValue, size: CGFloat(14.0))
        lbYes.textColor = institutionalColors.claroBlackColor
        lbYes.text = "Agrega un servicio"
        lbYes.sizeToFit()
        lbYes.center = CGPoint(x: btnRadioYes.center.x + 65, y: btnRadioYes.center.y)
        view.addSubview(lbYes)
        
        btnRadioNo.frame = CGRect (x: self.view.center.x, y: header.frame.maxY + 10 ,width: 25, height: 25)
        btnRadioNo.iconColor = institutionalColors.claroBlueColor
        btnRadioNo.indicatorColor = institutionalColors.claroBlueColor
        btnRadioNo.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btnRadioNo.isSelected = true
        btnRadioNo.isRadioButtonSelected = true
        view.addSubview(btnRadioNo)
        //btnRadioNo.addTarget(self, action: #selector(self.radioButtonPressed(radioButton:)), for: UIControlEvents.touchUpInside)
        
        
        lbNo.frame = CGRect(x: btnRadioNo.frame.maxX + 80, y: header.frame.maxY, width: 140, height: 40)
        lbNo.textAlignment = NSTextAlignment .left
        lbNo.font = UIFont(name: RobotoFontName.RobotoRegular.rawValue, size: CGFloat(14.0))
        lbNo.textColor = institutionalColors.claroBlackColor
        lbNo.text = "Servicios autodetectados"
        lbNo.numberOfLines = 2
        lbNo.sizeToFit()
        lbNo.center = CGPoint(x: btnRadioNo.center.x + 55, y: btnRadioNo.center.y)
        view.addSubview(lbNo)
        
        lbTitleHeader.text = "Servicios autodetectados"
        lbTitleHeader.textColor = institutionalColors.claroBlackColor
        lbTitleHeader.font = UIFont(name: RobotoFontName.RobotoRegular.rawValue, size: 14.0)
        lbTitleHeader.frame = CGRect(x: 20, y: lbNo.frame.maxY + 20 ,width: view.frame.width - 40, height: 44)
        view.addSubview(lbTitleHeader)
        

        txtServices.textColor = institutionalColors.claroBlackColor
        txtServices.frame = CGRect (x: 20, y: lbTitleHeader.frame.maxY, width: self.view.frame.width - 40, height: 44)
        txtServices.borderStyle = .roundedRect
        view.addSubview(txtServices)
        
        lbTitleTextfieldPeriods.text = "Selecciona un servicio"
        lbTitleTextfieldPeriods.frame = CGRect(x: 10, y: txtServices.frame.height / 2 - 10 , width: txtServices.frame.width, height: 40)
        lbTitleTextfieldPeriods.textAlignment = NSTextAlignment .left
        lbTitleTextfieldPeriods.font = UIFont(name: RobotoFontName.RobotoRegular.rawValue, size: CGFloat(12.0))
        lbTitleTextfieldPeriods.textColor = institutionalColors.claroTextColor
        lbTitleTextfieldPeriods.sizeToFit()
        txtServices.addSubview(lbTitleTextfieldPeriods)
        
        imageHeader = UIImageView(frame: CGRect(x: txtServices.frame.maxX - 55, y: txtServices.frame.height / 2 - 10, width: 21, height: 21))
        let image = mcaUtilsHelper.getImage(image: "ico_drop_down")
        imageHeader.image = image
        txtServices.addSubview(imageHeader)
        
        let btnNext = RedBackgroundButton(textButton: NSLocalizedString("Continuar", comment: ""))
        btnNext.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        btnNext.isEnabled = true
        btnNext.isUserInteractionEnabled = true
        btnNext.titleLabel?.font = UIFont(name: RobotoFontName.RobotoBold.rawValue, size: CGFloat(16.0))
        btnNext.setTitleColor(institutionalColors.claroWhiteColor , for: .normal)
        btnNext.frame = CGRect(x: 20, y: txtServices.frame.maxY + 30, width: self.view.frame.width - 40, height: 45)
        view.addSubview(btnNext)
        
    }
    
    func nextPressed(){
        let vcAssociate = AddAssociate()
        self.navigationController?.pushViewController(vcAssociate, animated: true)
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showServices_OnClick(tag: textField.tag)
        return false
    }
    
    func showServices_OnClick(tag : Int){
        let tableViewWidth = self.view.frame.size.width - 70
        self.tableServices.isHidden = true
        
        tableServices.frame = CGRect(x: 35, y: self.view.frame.size.height * 0.15, width: tableViewWidth, height: 100)
        tableServices.center = CGPoint(x: view.center.x, y: view.center.y - 80)
        tableServices.dataSource = self
        tableServices.delegate = self
        tableServices.separatorColor = UIColor.clear
        tableServices.showsVerticalScrollIndicator = false
        tableServices.reloadData()
        view.addSubview(tableServices)

    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cardCell = UITableViewCell(style: UITableViewCellStyle.default , reuseIdentifier: "Cell")
        
        
        return cardCell
    }
    class MyDLRadioButton : DLRadioButton{
        var isRadioButtonSelected = false
    }
}
