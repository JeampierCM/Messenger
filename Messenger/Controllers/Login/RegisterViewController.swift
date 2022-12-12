//
//  RegisterViewController.swift
//  Messenger
//
//  Created by jeampier on 12/10/22.
//  Copyright © 2022 miempresa. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    private let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.clipsToBounds = true
            return scrollView
        }()
        
        //para el logo
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "person.circle")
            imageView.tintColor = .gray
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            return imageView
        }()
    
        private let firstNameField: UITextField = {
            let field = UITextField()
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.returnKeyType = .continue
            field.layer.cornerRadius = 12
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.lightGray.cgColor
            field.placeholder = "First Name..."
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
            field.leftViewMode = .always
            field.backgroundColor = .secondarySystemBackground
            return field
        }()

        private let lastNameField: UITextField = {
            let field = UITextField()
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.returnKeyType = .continue
            field.layer.cornerRadius = 12
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.lightGray.cgColor
            field.placeholder = "Last Name..."
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
            field.leftViewMode = .always
            field.backgroundColor = .secondarySystemBackground
            return field
        }()
        
        //par input elmail
        private let emailField: UITextField = {
            let field = UITextField()
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.returnKeyType = .continue
            field.layer.cornerRadius = 12
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.lightGray.cgColor
            field.placeholder = "Email Address..."
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
            field.leftViewMode = .always
            field.backgroundColor = .secondarySystemBackground
            return field
        }()
        
        private let passwordField: UITextField = {
            let field = UITextField()
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.returnKeyType = .done
            field.layer.cornerRadius = 12
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.lightGray.cgColor
            field.placeholder = "Password..."
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
            field.leftViewMode = .always
            field.backgroundColor = .secondarySystemBackground
            field.isSecureTextEntry = true
            return field
        }()
        
        //botones
        private let registerButton: UIButton = {
            let button = UIButton()
            button.setTitle("Register", for: .normal)
            button.backgroundColor = .systemGreen
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 12
            button.layer.masksToBounds = true
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            return button
        }()
        /*
        private let facebookLoginButton: FBLoginButton = {
            let button = FBLoginButton()
            button.permissions = ["email,public_profile"]
            return button
        }()
     */
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //estilos
            title = "Register"
            view.backgroundColor = .white

            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(didTapRegister))
            
            registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
            
            emailField.delegate = self
            passwordField.delegate = self
            
            
            //llamado para logo
            view.addSubview(scrollView)
            //llamado al scroll
            scrollView.addSubview(imageView)
            scrollView.addSubview(firstNameField)
            scrollView.addSubview(lastNameField)
            scrollView.addSubview(emailField)
            scrollView.addSubview(passwordField)
            scrollView.addSubview(registerButton)
            
            imageView.isUserInteractionEnabled = true
            scrollView.isUserInteractionEnabled = true
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
            
            imageView.addGestureRecognizer(gesture)
        }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
        
        //para la vista
        override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            scrollView.frame = view.bounds
            let size = scrollView.width/3
            imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                     y: 20,
                                     width: size,
                                     height: size)
            imageView.layer.cornerRadius = imageView.width/2.0

            firstNameField.frame = CGRect(x: 30,
                                      y: imageView.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
            lastNameField.frame = CGRect(x: 30,
                                      y: firstNameField.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
            emailField.frame = CGRect(x: 30,
                                      y: lastNameField.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
            passwordField.frame = CGRect(x: 30,
                                        y: emailField.bottom+10,
                                        width: scrollView.width-60,
                                        height: 52)
            registerButton.frame = CGRect(x: 30,
                                       y: passwordField.bottom+10,
                                       width: scrollView.width-60,
                                       height: 52)

            /*
            facebookLoginButton.frame = CGRect(x: 30,
                                       y: loginButton.bottom+10,
                                       width: scrollView.width-60,
                                       height: 52)

            googleLogInButton.frame = CGRect(x: 30,
                                       y: facebookLoginButton.bottom+10,
                                       width: scrollView.width-60,
                                       height: 52)
            */
        }
        
        @objc private func registerButtonTapped(){
            
            emailField.resignFirstResponder()
            passwordField.resignFirstResponder()
            firstNameField.resignFirstResponder()
            lastNameField.resignFirstResponder()
            
            guard let firstName = firstNameField.text,
                let lastName = lastNameField.text,
                let email = emailField.text,
                let password = passwordField.text,
                !email.isEmpty,
                !password.isEmpty,
                !firstName.isEmpty,
                !lastName.isEmpty,
                password.count >= 6 else {
                    alertUserLoginError()
                    return
            }
    //Firebase register------------------------------
            
            DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
                guard let strongSelf = self else{
                    return
                }
                guard !exists else{
                    //user ya existe
                strongSelf.alertUserLoginError(message: "Parece que ya existe una cuenta de usuario para esa dirección de correo electrónico.")
                    return
                }
                
                FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {
                    authResult, error in
                    
                    guard authResult != nil, error == nil else {
                        print ("Error al crear usuario")
                        return
                    }
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                    strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                })
            })
            
        }
        
        //alerta de error de inicio de secion
    func alertUserLoginError(message: String = "Por favor ingrese toda la información para crear nueva cuenta") {
            let alert = UIAlertController(title: "Woops",
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Aceptar",
                                          style: .cancel, handler: nil))
            present(alert, animated: true)
        }
        
        //navegacion
        @objc private func didTapRegister() {
            let vc = RegisterViewController()
            vc.title = "Create Account"
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    extension RegisterViewController: UITextFieldDelegate{
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            if textField == emailField {
                passwordField.becomeFirstResponder()
            }
            else if textField  == passwordField {
                registerButtonTapped()
            }
            return true
            
        }
    }

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Foto de perfil",
                                            message: "¿Cómo le gustaría seleccionar una imagen?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancelar",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Tomar foto",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentCamera()

        }))
        actionSheet.addAction(UIAlertAction(title: "Elegir foto",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentPhotoPicker()

        }))

        present(actionSheet, animated: true)
    }

    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }

        self.imageView.image = selectedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

