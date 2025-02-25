//
//  LoginView.swift
//  FigmaToSwiftUI
//
//  Created by Tech Exactly iPhone 6 on 29/01/25.
//

//import SwiftUI
//
//struct LoginView: View {
//    @StateObject private var viewModel = LoginViewModel()
//    @State private var email: String = ""
//    @State private var password: String = ""
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 10) {
//                    VStack(spacing: 10){
//                        Text("Hello Again!")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                        
//                        Text("Welcome Back You've Been Missed!")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                            .lineLimit(1)
//                    }.padding(.top,70)
//                    .padding(.vertical, 40)
//                    
//                    VStack(alignment: .leading, spacing:10){
//                        Text("Email Address")
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                            .padding(.horizontal)
//                        TextField("Email Address", text: $email)
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(28)
//                            .padding(.horizontal)
//                    }
//                    .padding(.vertical)
//                    
//                    VStack(alignment: .leading, spacing:10){
//                        Text("Password")
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                            .padding(.horizontal)
//                        
//                        SecureField("Password", text: $password)
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(28)
//                            .padding(.horizontal)
//                            .padding(.bottom)
//                        
//                        HStack{
//                            Spacer()
//                            NavigationLink {
//                                ForgetPasswordView()
//                            } label: {
//                                Text("Recovery Password")
//                                    .font(.subheadline)
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.gray)
//                            }
//
//                        }
//                    }
//                    
//                    Button(action: {
//                        viewModel.login(email: email, password: password)
//                    }) {
//                        Text("Login")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.black)
//                            .cornerRadius(28)
//                            .padding(.horizontal)
//                    }
//                    
//                    HStack {
//                        VStack { Divider() }
//                        Text("or")
//                        VStack { Divider() }
//                    }
//                    .padding(.horizontal)
//                    
//                    VStack (spacing: 50){
//                        Button(action: {
//                            // Handle Google sign in action
//                        }) {
//                            HStack {
//                                Image("google")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                Text("Sign in with Google")
//                                    .foregroundColor(.black)
//                            }
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
//                            .cornerRadius(28)
//                            .padding(.horizontal)
//                        }
//                        
//                        Spacer()
//                        
//                        HStack {
//                            Text("Don't Have An Account?")
//                                .foregroundColor(.gray)
//                            NavigationLink {
//                                SignUpView()
//                            } label: {
//                                Text("SignUp")
//                                    .foregroundColor(.black)
//                                    .bold()
//                            }
//                        }
//                    }
//                    .padding(.top)
//                }
//                .padding()
//            }
//            .background(Color.gray.opacity(0.1)) // Apply background color to ScrollView
//            .ignoresSafeArea()
//            .navigationBarBackButtonHidden(true)
//            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
//                Button("OK") {
//                    if viewModel.isSuccess {
//                        viewModel.navigateToHome = true
//                    }
//                }
//            }
//            .navigationDestination(isPresented: $viewModel.navigateToHome) {
//                HomeView()
//            }
//        }
//    }
//}
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @StateObject private var googleSignInVM = GoogleSignInViewModel()
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    VStack(spacing: 10) {
                        Text("Hello Again!")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Welcome Back! You've Been Missed!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    .padding(.top, 70)
                    .padding(.vertical, 40)

                    VStack(alignment: .leading, spacing: 10) {
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
                    .padding(.vertical)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(28)
                            .padding(.horizontal)
                            .padding(.bottom)

                        HStack {
                            Spacer()
                            NavigationLink {
                                ForgetPasswordView()
                            } label: {
                                Text("Recovery Password")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    Button(action: {
                        viewModel.login(email: email, password: password)
                    }) {
                        Text("Login")
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

                    VStack(spacing: 50) {
                        Button(action: {
                            print("Button tapped")
                          //  googleSignInVM.signIn()
                        }) {
                            HStack {
                                Image("google") // Ensure this image exists in Assets
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
                            Text("Don't Have An Account?")
                                .foregroundColor(.gray)
                            NavigationLink {
                                SignUpView()
                            } label: {
                                Text("Sign Up")
                                    .foregroundColor(.black)
                                    .bold()
                            }
                        }
                    }
                    .padding(.top)
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("OK") { }
            }
            .navigationDestination(isPresented: $viewModel.navigateToHome) {
                HomeView()
                    .navigationBarBackButtonHidden(true)
            }
            .onChange(of: viewModel.isSuccess) { success in
                if success {
                    // Add a slight delay before navigation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.navigateToHome = true
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


