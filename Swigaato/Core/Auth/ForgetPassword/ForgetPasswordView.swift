//
//  ForgetPasswordView.swift
//  FigmaToSwiftUI
//
//  Created by Tech Exactly iPhone 6 on 31/01/25.
//

import SwiftUI

struct ForgetPasswordView: View {
    @State private var email: String = ""
    @Environment(\.dismiss) var GoBack
    
    var body: some View {
        NavigationStack{
            VStack{
                
                HStack(){
                    Button {
                        GoBack()
                        
                    } label: {
                        Image(systemName: "arrow.backward")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    Spacer()
                    
                }.padding(.leading, 20)
                    .padding(.top, 50)
                
                VStack(spacing: 10){
                    Text("Recovery Password!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Please Enter Your Email Address to Receive a verification Code!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }.padding(.top,70)
                    .padding(.vertical, 40)
                
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
                .padding(.vertical)
                
                Button(action: {
                    // Handle sign in action
                }) {
                    Text("Recover Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(28)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1)) // Apply background color to ScrollView
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            
        }
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView()
    }
}
