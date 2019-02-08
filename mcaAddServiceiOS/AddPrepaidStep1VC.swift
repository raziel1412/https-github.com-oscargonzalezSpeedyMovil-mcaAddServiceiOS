//
//  AddPrepaidStep1VC.swift
//  MiClaro
//
//  Created by Roberto Gutierrez Resendiz on 07/08/17.
//  Copyright © 2017 am. All rights reserved.
//

import UIKit
import Cartography
import mcaManageriOS
import mcaUtilsiOS

/// Clase que permite agregar un número prepago a una cuenta ya asociada
public class AddPrepaidStep1VC: UIViewController, MobilePhoneNumberOnChangeDelegate, UITextFieldDelegate {
    
    /// Constante que almacena la configuración
    let conf = mcaManagerSession.getGeneralConfig();
    private var headerView : UIHeaderForm = UIHeaderForm(frame: .zero)
    private var textGroup : UITextFieldGroupPhone = UITextFieldGroupPhone(frame: .zero)
    private var termsBox : TermsAndConditions = TermsAndConditions(frame: .zero)
    /// Botón para continuar
    var nextButton: RedBorderWhiteBackgroundButton!
    
    func setupElements() {
        self.view.backgroundColor = UIColor.white
        let scrollView : UIScrollView = UIScrollView(frame: .zero)
        let viewContent : UIView = UIView(frame: self.view.bounds)
        headerView.setupElements(imageName: "ico_seccion_registro", title: conf?.translations?.data?.addService?.header, subTitle: conf?.translations?.data?.registro?.registerPrepaid)
        viewContent.addSubview(headerView)
        
        textGroup.setupContent(imageName: "icon_telefono_input", text: conf?.translations?.data?.registro?.registerPrepaidNumber, placeHolder: conf?.translations?.data?.registro?.registerPrepaidNumber, countryCodeText: conf?.country?.phoneCountryCode)
        textGroup.textField.delegate = self
        textGroup.textField.keyboardType = .phonePad
        viewContent.addSubview(textGroup)
        let parte1 = conf?.translations?.data?.registro?.registerTyCFirst ?? "";
        let parte2 = conf?.translations?.data?.generales?.termsAndConditions ?? "";
        let parte3 = conf?.translations?.data?.registro?.registerTyCFinal ?? "";
        //termsBox.setContent(String(format: "%@ <b>%@</b> %@", parte1, parte2, parte3))
        //termsBox.setupClickDelegate(target: self, action: #selector(self.lnkTerminos_OnClick(sender:)))
        
        termsBox.setContent(String(format: "%@ <b>%@</b> %@", parte1, parte2, parte3), url: (mcaManagerSession.getGeneralConfig()?.termsAndConditions?.url)!, title: mcaManagerSession.getGeneralConfig()?.translations?.data?.generales?.termsAndConditions ?? "", acceptTitle: mcaManagerSession.getGeneralConfig()?.translations?.data?.generales?.closeBtn ?? "", offlineAction: {
            mcaManagerSession.showOfflineMessage()
        })
        

        viewContent.addSubview(termsBox)
        nextButton = RedBorderWhiteBackgroundButton(textButton: conf?.translations?.data?.generales?.nextBtn ?? "")
        nextButton.addTarget(self, action: #selector(sendSMS), for: UIControlEvents.touchUpInside)
        nextButton.isEnabled = true
        self.nextButton?.isUserInteractionEnabled = false
        self.nextButton?.alpha = 0.5
        viewContent.addSubview(nextButton)
        scrollView.addSubview(viewContent)
        scrollView.frame = viewContent.bounds
        scrollView.contentSize = viewContent.bounds.size
        self.view.addSubview(scrollView)
        termsBox.checkBox.addTarget(self, action: #selector(self.chkValidate), for: UIControlEvents.touchUpInside)
        setupConstraints(view: viewContent)
    }
    
    func setupConstraints(view: UIView) {
        constrain(view, headerView, textGroup, termsBox, nextButton) { (view, header, group, box, button) in
            header.top == view.top
            header.leading == view.leading
            header.trailing == view.trailing
            header.height == view.height * 0.35
            
            group.top == header.bottom + 16.0
            group.leading == view.leading + 32.0
            group.trailing == view.trailing - 31.0
            group.height == 60.0
            
            box.top == group.bottom + 16.0
            box.leading == view.leading + 32.0
            box.trailing == view.trailing - 31.0
            box.height == 40.0
            
            button.top == box.bottom + 24.0
            button.leading == view.leading + 32.0
            button.trailing == view.trailing - 31.0
            button.height == 40.0
            
        }
    }
    
    

    /// Función encargada de inicializar elementos de la vista e inicializar variables
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        //meter codigo aqui
        
        self.setupElements()

        let actionType = mcaManagerSession.getActionType()
        if (actionType != 0 || mcaManagerSession.getCustomerWithoutServices()){
            AnalyticsInteractionSingleton.sharedInstance.ADBTrackView(viewName: "Sin servicios|Agregar prepago", detenido: false)
            
        }else{
            AnalyticsInteractionSingleton.sharedInstance.ADBTrackViewServicioPrepago(viewName: "Mis servicios|Agregar prepago|Paso 1|Ingresar numero movil", type: "1", detenido: false)
        }
    }
    
    /// Función depreciada
    public func MobilePhoneChangeData(texto: String) {
    }
    
    
    @objc func chkValidate(){
        if termsBox.isChecked == true{
            self.nextButton?.isUserInteractionEnabled = true
            self.nextButton?.alpha = 1.0
        }else{
            self.nextButton?.isUserInteractionEnabled = false
            self.nextButton?.alpha = 0.5
        }
    }
    
    
    /// Función encargada de enviar a términos y condiciones
    func lnkTerminos_OnClick(sender: Any) {
        let actionType = mcaManagerSession.getActionType()
        if (actionType != 0 || mcaManagerSession.getCustomerWithoutServices()){
            AnalyticsInteractionSingleton.sharedInstance.ADBTrackCustomLink(viewName: "Sin servicios|Agregar prepago:Terminos y condiciones")
        }else{
              AnalyticsInteractionSingleton.sharedInstance.ADBTrackCustomLink(viewName: "Mis servicios|Agregar prepago|Paso 1|Ingresar numero movil:Terminos y condiciones")
        }
        
        if false == mcaManagerSession.isNetworkConnected() {
            mcaManagerSession.showOfflineMessage()
            return;
        }
        
        GeneralAlerts.showDataWebView(title: mcaManagerSession.getGeneralConfig()?.translations?.data?.generales?.termsAndConditions ?? "",
                                      url: (mcaManagerSession.getGeneralConfig()?.termsAndConditions?.url)!,
                                      method: "GET",
                                      acceptTitle: mcaManagerSession.getGeneralConfig()?.translations?.data?.generales?.closeBtn ?? "",
                                      onAcceptEvent: {})
    }
    /// Función encargada de validar y envíar el SMS para la fase 2 de agregar prepago
    func sendSMS() {
        let actionType = mcaManagerSession.getActionType()
        if (actionType != 0 || mcaManagerSession.getCustomerWithoutServices()){
            AnalyticsInteractionSingleton.sharedInstance.ADBTrackCustomLink(viewName: "Sin servicios|Agregar prepago:Continuar")
        }else{
            AnalyticsInteractionSingleton.sharedInstance.ADBTrackCustomLink(viewName: "Mis servicios|Agregar prepago|Paso 1|Ingresar numero movil:Continuar")
        }
        
        var message = ""
        var callService = false
        textGroup.mandatoryInformation.hideView()
        if termsBox.isChecked {
            if textGroup.textField.text!.isEmpty {
                message = conf?.translations?.data?.generales?.emptyField ?? ""
                callService = false
                AnalyticsInteractionSingleton.sharedInstance.ADBTrackViewServicioPrepago(viewName: "Mis servicios|Agregar prepago|Paso 1|Ingresar numero movil|Detenido", type: "1", detenido: true, mensaje: message)
            }else {
                message = ""
                callService = true
            }
            if callService {
                print("CALL WEB SERVICE")
                self.callWebService()
            }else {
                self.textGroup.mandatoryInformation.displayView(customString: message)
            }
        }
    }
    /// Función para determinar cuando se toque cualquier elemento de la vista
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// Alerta de insuficiencia de memoria
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// WEB SERVICE VALIDATE NUMBER
    func callWebService() {
        textGroup.mandatoryInformation.hideView()
        if false == mcaManagerSession.isNetworkConnected() {
            //NotificationCenter.default.post(name: Observers.ObserverList.ShowOfflineMessage.name, object: nil);
            return;
        }
        let telefono = textGroup.textField.text?.trimmingCharacters(in: .whitespaces);

        if "" != telefono, let count = telefono?.count, count >= 8 {
            let infoUser = mcaManagerSession.getCurrentSession()
            
            let req = ValidateNumberRequest()
            let codigoPais = (mcaManagerSession.getGeneralConfig()?.country?.phoneCountryCode ?? "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "+", with: "")
            let claroNumber = String(format: "%@%@", codigoPais, telefono!);
            req.validateNumber?.claroNumber = claroNumber
            
            req.validateNumber?.lineOfBusiness = TypeLineOfBussines(rawValue: "2").map { $0.rawValue }
            
            let req2 = ValidatePersonalVerificationQuestionRequest();
            var questions = [SecurityQuestionRequest]()
            
            /****************/
            let questionRut = SecurityQuestionRequest();
            questionRut.idQuestion = "1";
            questionRut.answer = (infoUser?.retrieveProfileInformationResponse?.personalDetailsInformation?.rUT?.enmascararRut())!.maskedString//self.rutUser
            questions.append(questionRut)
            
            let questionPhone = SecurityQuestionRequest();
            questionPhone.idQuestion = "6";
            questionPhone.answer = claroNumber // mobilePhoneView.mobileTextfield.text!//self.phoneUser
            questions.append(questionPhone)
            
            req2.validatePersonalVerificationQuestions?.securityQuestions = questions
            
            mcaManagerServer.executeValidateNumber(params: req,
                                                         onSuccess: { (result) in
                                                
                                                            GeneralAlerts.showAcceptOnly(title: self.conf?.translations?.data?.generales?.pinAlertTitle ?? "",
                                                                                         text: self.conf?.translations?.data?.generales?.pinAlert ?? "",
                                                                                         icon: .IconoAlertaSMS,
                                                                                         cancelBtnColor: nil,
                                                                                         cancelButtonName: "",
                                                                                         acceptTitle: self.conf!.translations!.data!.generales!.closeBtn!,
                                                                                         acceptBtnColor: nil,
                                                                                         buttonName: "",
                                                                                         onAcceptEvent: {
                                                                                            if let container = self.so_containerViewController {
                                                                                                container.isSideViewControllerPresented = false;
                                                                                            }
                                                                                            let prepaid2 = AddPrepaidStep2VC()
                                                                                            prepaid2.phoneUser = self.textGroup.textField.text!
                                                                                            self.navigationController?.pushViewController(prepaid2, animated: true)
                                                                                            AnalyticsInteractionSingleton.sharedInstance.ADBTrackCustomLink(viewName: "Mis servicios|Agregar prepago|Paso 3|Mensaje enviado:Cerrar")
                                                            })
                                             
                                                            
                                                            
                                                            
                                                            
                                                            AnalyticsInteractionSingleton.sharedInstance.ADBTrackViewServicioPrepago(viewName: "Mis servicios|Agregar prepago|Paso 2|Enviar codigo verificacion", type: "2", detenido: false)
                                                            AnalyticsInteractionSingleton.sharedInstance.initTimer()
                                                            AnalyticsInteractionSingleton.sharedInstance.ADBTrackCustomLink(viewName: "Mis servicios|Agregar prepago|Paso 2|Enviar codigo verificacion:Enviar")
            },
                                                         onFailure: { (result, myError) in
                                                            
                                                            GeneralAlerts.showAcceptOnly(title: "",
                                                                                         text: (result?.validateNumberResponse?.acknowledgementDescription)!,
                                                                                         icon: .IconoAlertaError,
                                                                                         cancelBtnColor: nil,
                                                                                         cancelButtonName: "",
                                                                                         acceptTitle: NSLocalizedString("accept", comment: ""),
                                                                                         acceptBtnColor: nil,
                                                                                         buttonName: "",
                                                                                         onAcceptEvent: {
                                                                                            if let container = self.so_containerViewController {
                                                                                                container.isSideViewControllerPresented = false;
                                                                                            }
                                                            })
            });
        } else if "" != telefono, termsBox.isChecked == true {
            textGroup.mandatoryInformation.displayView(customString: "eight-digits".localized)
        }
    }
    
    /// Función que permite determinar si el texto ingresado son caracteres validos y modifica / agrega / Elimina o no el caracter
    /// - parameter textField: campo de texto que se está editando
    /// - parameter range: Rango de los caracteres
    /// - parameter string: Cadena a anexar
    /// - Returns: Bool
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       /* let maxLength = 9
        if string.count == 0 {
            return true
        }
        if let text = textField.text, text.count > maxLength - 1 {
            return false
        }
        return true
    }*/
        
        let lenght = (mcaManagerSession.getGeneralConfig()?.rules?.mobileNumberRules?.mobileMaxLength) ?? ""
        let lenghtStr = (lenght as NSString).integerValue
        //if (mobilePhoneView.mobileTextfield.text != nil) {
            if (textGroup.textField.text != nil) {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
            let nsString = NSString(string: newString)
            return !(nsString.length > lenghtStr)
            
        }
        return true
    }
    
}
