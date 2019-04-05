//
//  AddPrepaidStep2VC.swift
//  MiClaro
//
//  Created by Roberto Gutierrez Resendiz on 07/08/17.
//  Copyright © 2017 am. All rights reserved.
//

import UIKit
import Cartography
import mcaUtilsiOS
import mcaManageriOS

/// Clase encargada de llevar a cabo la segúnda fase de validación para agregar un prepago
public class AddPrepaidStep2VC: UIViewController {
    /// Botón de siguiente
    var nextButton: RedBorderWhiteBackgroundButton!
    /// Vista de contenedor del código donde se ingresará el enviado por SMS
    var codeContainer: CodeContainerView!
    /// Etiqueta con acción para reenviar el código
    var linkeableLabel: LinkableLabel!
    /// Variable contenedora del teléfono del usuario
    public var phoneUser: String = ""
    /// Constante que almacena la configuración
    let conf = mcaManagerSession.getGeneralConfig();
    
    private var scrollView : UIScrollView!
    
    var headerView : UIHeaderForm = UIHeaderForm(frame: .zero)
    
    func setupElements() {
        self.view.backgroundColor = institutionalColors.claroWhiteColor
        //self.initWith(navigationType: navType.addPrePaidCode)
        
        if scrollView == nil {
            scrollView = UIScrollView(frame: .zero)
            let viewContainer : UIView = UIView(frame: self.view.bounds)
            headerView.setupElements(imageName: "ico_seccion_registro", title: conf?.translations?.data?.addService?.header, subTitle: conf?.translations?.data?.registro?.pinValidation)
            viewContainer.addSubview(headerView)
            codeContainer = CodeContainerView()
            codeContainer.numberCode =  6
            codeContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.45, height: 40)
            codeContainer.setPosition()
            codeContainer.setKeyboardType(tipoTeclado: .numberPad)
            viewContainer.addSubview(codeContainer)
            let tap = UITapGestureRecognizer(target: self, action: #selector(resendCode(sender:)));
            linkeableLabel = LinkableLabel()
            linkeableLabel.addGestureRecognizer(tap)
            linkeableLabel.showText(text: conf?.translations?.data?.generales?.resendPin != nil ? "<b>\(conf!.translations!.data!.generales!.resendPin!)</b>" : "" )
            linkeableLabel.textAlignment = .center
            viewContainer.addSubview(linkeableLabel)
            nextButton = RedBorderWhiteBackgroundButton(textButton: conf?.translations?.data?.generales?.validateBtn ?? "")
            nextButton.addTarget(self, action: #selector(validateCode), for: UIControlEvents.touchUpInside)
            viewContainer.addSubview(nextButton)
            scrollView.addSubview(viewContainer)
            scrollView.frame = viewContainer.bounds
            scrollView.contentSize = viewContainer.bounds.size
            self.view.addSubview(scrollView)
            setupConstraints(view: viewContainer)
        }
    
    }
    
    func setupConstraints(view: UIView) {
        constrain(self.view, headerView, codeContainer) { (view, header, container) in
            header.top == view.top
            header.leading == view.leading
            header.trailing == view.trailing
            header.height == view.height * 0.35
            
            container.top == header.bottom + 10.0
            container.centerX == view.centerX
            container.width == view.width * 0.45
            container.height == 40.0
        }
        
        constrain(self.view, codeContainer, linkeableLabel) { (view, container, label) in
            
            label.top == container.bottom + 16.0
            label.leading == view.leading + 31.0
            label.trailing == view.trailing - 31.0
            label.height == 18.0
        }
        
        constrain(self.view, linkeableLabel, nextButton) { (view, label, button) in
            button.top == label.bottom + 38.0
            button.leading == view.leading + 31.0
            button.trailing == view.trailing - 32.0
            button.height == 40
        }
        
    }
    
    
    /// Función encargada de inicializar elementos de la vista e inicializar variables
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    /// Función encargada de validar el código introducido con el del SMS
    func validateCode() {
        let timeSMS = AnalyticsInteractionSingleton.sharedInstance.stopTimer()
        AnalyticsInteractionSingleton.sharedInstance.ADBTrackViewServicioPrepago(viewName: "Mis servicios|Agregar prepago|Paso 4|Ingresar codigo verificacion", type: "4", detenido: false, intervalo: timeSMS)
        AnalyticsInteractionSingleton.sharedInstance.ADBTrackCustomLink(viewName: "Mis servicios|Agregar prepago|Paso 4|Ingresar codigo verificacion:Valida")
        let shouldContinue = self.shouldContinue()
        if shouldContinue.should {
            self.callWSvalidateCode()
        } else {
            GeneralAlerts.showAcceptOnly(title: "",
                                         text: shouldContinue.errorString ?? NSLocalizedString("debes-ingresar-codigo-verificacion", comment: ""),
                                         icon: .IconoAlertaError,
                                         cancelBtnColor: nil,
                                         cancelButtonName: "",
                                         acceptTitle: "",
                                         acceptBtnColor: nil,
                                         buttonName: "",
                                         onAcceptEvent: {})
            
            return
        }
    }
    /// Función que determina si se debe continuar
    /// - Returns should: Bool
    /// - Returns errorString : String?
    func shouldContinue() -> ( should: Bool, errorString : String?) {
        if (codeContainer.getCode().count != 4) {
            return (false, NSLocalizedString("debes-ingresar-codigo-verificacion", comment: ""))
        } else {
            return (true, nil)
        }
    }
    /// Función encargada de llamar al Servicio Web para re-enviar el código
    func resendCode(sender: Any) {
        self.callWebServiceCode()
    }
    
    /// Función para determinar cuando se toque cualquier elemento de la vista
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    /// Alerta de insuficiencia de memoria
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /// Web Services para validación del codigo
    func callWSvalidateCode() {
        let infoUser = mcaManagerSession.getCurrentSession()
        
        let req = ValidatePersonalVerificationQuestionRequest();
        var questions = [SecurityQuestionRequest]()
        
        let question = SecurityQuestionRequest();
        question.idQuestion = "4";
        question.answer = codeContainer.getCode();
        questions.append(question)
        
        /****************/
        let questionRut = SecurityQuestionRequest();
        questionRut.idQuestion = "1";
        questionRut.answer = (infoUser?.retrieveProfileInformationResponse?.personalDetailsInformation?.rUT?.enmascararRut())!.maskedString//self.rutUser
        questions.append(questionRut)
        
        let questionPhone = SecurityQuestionRequest();
        questionPhone.idQuestion = "6";
//        let codigoPais = (mcaManagerSession.getGeneralConfig()?.country?.phoneCountryCode ?? "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "+", with: "")
        let claroNumber = String(format: "%@", self.phoneUser);
        questionPhone.answer = claroNumber
        questions.append(questionPhone)
        
        /****************/
        
        req.validatePersonalVerificationQuestions?.securityQuestions = questions//[question];
        req.validatePersonalVerificationQuestions?.userProfileId = ""//reqNum?.validateNumber?.userProfileId
        req.validatePersonalVerificationQuestions?.lineOfBusiness = "2"//lineOfBusinnes?.rawValue
        mcaManagerServer.executeValidatePersonalVerificationQuestions(params: req,
            onSuccess: { (result) in
                self.callWSAssociateAccount()
        },
            onFailure: { (result, myError) in
                
                GeneralAlerts.showAcceptOnly(title: "",
                                             text: (result?.validatePersonalVerificationQuestionsResponse?.acknowledgementDescription)!,
                                             icon: .IconoAlertaError,
                                             cancelBtnColor: nil,
                                             cancelButtonName: "",
                                             acceptTitle: NSLocalizedString("accept", comment: ""),
                                             acceptBtnColor: nil,
                                             buttonName: "",
                                             onAcceptEvent:  {
                                                if let container = self.so_containerViewController {
                                                    container.isSideViewControllerPresented = false;
                                                }
                })
        })

    }
    
    /// Web Service para Validación del número
    func callWebServiceCode() {
        if "" != self.phoneUser {
            let infoUser = mcaManagerSession.getCurrentSession()
            
            let req = ValidateNumberRequest()
//            let codigoPais = (mcaManagerSession.getGeneralConfig()?.country?.phoneCountryCode ?? "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "+", with: "")
            let claroNumber = String(format: "%@", self.phoneUser);
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
            questionPhone.answer = claroNumber
            questions.append(questionPhone)
            
            req2.validatePersonalVerificationQuestions?.securityQuestions = questions
            
            mcaManagerServer.executeValidateNumber(params: req,
                                                         onSuccess: { (result) in
                                                            
                                                            GeneralAlerts.showAcceptOnly(title: "",
                                                                                         text: NSLocalizedString("alertSmsSent", comment: ""),
                                                                                         icon: .IconoAlertaSMS,
                                                                                         cancelBtnColor: nil,
                                                                                         cancelButtonName: "",
                                                                                         acceptTitle: self.conf!.translations!.data!.generales!.acceptBtn!,
                                                                                         acceptBtnColor: nil,
                                                                                         buttonName: "",
                                                                                         onAcceptEvent: {
                                                                                            if let container = self.so_containerViewController {
                                                                                                container.isSideViewControllerPresented = false;
                                                                                            }
                                                                                            AnalyticsInteractionSingleton.sharedInstance.ADBTrackCustomLink(viewName: "Mis servicios|Agregar prepago|Exito:Cerrar")
                                                                                            })
                                                 
                                                            
                                                            
                                                            
                                                            
                                                            AnalyticsInteractionSingleton.sharedInstance.ADBTrackViewServicioPrepago(viewName: "Mis servicios|Agregar prepago|Paso 3|Mensaje enviado", type: "3", detenido: false)
                                                            
            },
                                                         onFailure: { (result, myError) in
                                                            GeneralAlerts.showAcceptOnly(title: "",
                                                                                         text: (result?.validateNumberResponse?.acknowledgementDescription)!,
                                                                                         icon: .IconoAlertaError,
                                                                                         cancelBtnColor: nil,
                                                                                         cancelButtonName: "",
                                                                                         acceptTitle:  NSLocalizedString("accept", comment: ""),
                                                                                         acceptBtnColor: nil,
                                                                                         buttonName: "",
                                                                                         onAcceptEvent: {
                                                                                            if let container = self.so_containerViewController {
                                                                                                container.isSideViewControllerPresented = false;
                                                                                            }
                                                        })
                                                            
                                                         
                                                            
            });
            
        }
    }
    
    /// Función que hace el llamado al Web service executeAssociateAccount
    func callWSAssociateAccount() {
//        let codigoPais = (mcaManagerSession.getGeneralConfig()?.country?.phoneCountryCode ?? "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "+", with: "")
        let claroNumber = String(format: "%@", self.phoneUser);
        let infoUser = mcaManagerSession.getCurrentSession()
        let req = AssociateAccountRequest()
        req.associateAccount = AssociateAccount()
        req.associateAccount?.lineOfBusiness = "2"
        req.associateAccount?.accountId = claroNumber
        req.associateAccount?.userProfileId = (infoUser?.retrieveProfileInformationResponse?.personalDetailsInformation?.rUT?.enmascararRut())!.maskedString//self.rutUser
        req.associateAccount?.associationRoleType = "1"
        req.associateAccount?.accountAssociationStatus = "1"
        req.associateAccount?.notifyMeAboutChanges = true
        
        mcaManagerServer.executeAssociateAccount(params: req, onSuccess: {
            (associateResult, resultType) in
            
            GeneralAlerts.showAcceptOnly(title: "",
                                         text: NSLocalizedString("AddPrepaid-Confirmation", comment: ""),
                                         icon: .IconoAlertaOK,
                                         cancelBtnColor: nil,
                                         cancelButtonName: "",
                                         acceptTitle:  "",
                                         acceptBtnColor: nil,
                                         buttonName: "",
                                         onAcceptEvent: {
                                            mcaManagerSession.setFullAccountData(account: nil);
                                            //UIApplication.shared.keyWindow?.rootViewController = ContainerVC();
                                            NotificationCenter.default.post(name: Notification.Name("NotificationGoToServicesAccount"), object: nil);

                                            AnalyticsInteractionSingleton.sharedInstance.ADBTrackViewServicioPrepago(viewName: "Mis servicios|Agregar prepago|Exito", type: "5", detenido: false)
                                            AnalyticsInteractionSingleton.sharedInstance.ADBTrackCustomLink(viewName: "Mis servicios|Agregar prepago|Exito:Cerrar")
            })
            
            ////showModal = false
            
        }, onFailure: {(result, error) in
            GeneralAlerts.showAcceptOnly(title: "",
                                         text: (result?.associateAccountResponse?.acknowledgementDescription)!,
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
        })
    }
}
