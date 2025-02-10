//
//  SignUpView.swift
//  FigmaToSwiftUI
//
//  Created by Tech Exactly iPhone 6 on 30/01/25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        NavigationStack{
            
            
            ScrollView {
                VStack(spacing: 10) {
                    VStack(spacing: 10){
                        Text("Create Account!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Welcome let's create account together")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }.padding(.top,70)
                    .padding(.vertical, 40)
                    
                    VStack(alignment: .leading, spacing:10){
                        Text("Your Name")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        TextField("Enter Your Name", text: $name)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(28)
                            .padding(.horizontal)
                    }
                    //.padding(.vertical)
                    
                    
                    VStack(alignment: .leading, spacing:10){
                        Text("Email Address")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        TextField("Email Address", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(28)
                            .padding(.horizontal)
                    }
                    //.padding(.vertical)
                    
                    VStack(alignment: .leading, spacing:10){
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(28)
                            .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing:10){
                        Text("Confirm Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(28)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    
//                    Button(action: {
//                        // Handle sign in action
//                    }) {
//                        Text("Sign Up")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .cornerRadius(28)
//                            .padding(.horizontal)
//                    }
                    
                    Button(action: {
                        viewModel.signUp(name: name,
                                       email: email,
                                       password: password,
                                       confirmPassword: confirmPassword)
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(28)
                            .padding(.horizontal)
                    }

                    
                    HStack {
                        VStack { Divider() }
                        Text("or")
                        VStack { Divider() }
                    }
                    .padding(.horizontal)
                    
                    VStack (spacing: 50){
                        Button(action: {
                            // Handle Google sign in action
                        }) {
                            HStack {
                                Image("google")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Sign in with Google")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(28)
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text("Already Have An Account?")
                                .foregroundColor(.gray)
//                            Button(action: {
//                                // Handle sign up action
//                            }) {
//                                Text("Login")
//                                    .foregroundColor(.blue)
//                            }
                            NavigationLink {
                                LoginView()
                            } label: {
                                Text("Login")
                                    .foregroundColor(.black)
                                    .bold()

                            }

                        }
                    }
                    .padding(.top)
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1)) // Apply background color to ScrollView
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button("OK") {
                if viewModel.isSuccess {
                    viewModel.navigateToHome = true
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.navigateToHome) {
            HomeView()
        }
    }
}
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
