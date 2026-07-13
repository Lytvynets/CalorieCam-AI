//
//  AddMealView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 16.03.2026.
//

import SwiftUI

struct AddMealView: View {
    
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    @State private var showPicker = false
    @State private var sourceType: UIImagePickerController.SourceType?
    @State private var showDialog = false
    @FocusState private var isKeyboardActive: Bool

    private var isFormValid: Bool {
        !diaryViewModel.newName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !diaryViewModel.newCalories.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            HStack {
                Spacer()
                if #available(iOS 26.0, *) {
                    Button {
                        withAnimation {
                            diaryViewModel.showAddMealView = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }.buttonStyle(.glass)
                } else {
                    Button {
                        withAnimation {
                            diaryViewModel.showAddMealView = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                }
            }
            .overlay {
                Text("Add Meal")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive18))
            }
            .padding(.top, 10)
            
            if let image = diaryViewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 169)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(hex: "#565656"), lineWidth: 1)
                    )
                    .clipped()
                    .onTapGesture {
                        showDialog = true
                    }
                    .overlay {
                        VStack {
                            HStack {
                                Spacer()
                                if #available(iOS 26.0, *) {
                                    Button {
                                        withAnimation {
                                            diaryViewModel.selectedImage = nil
                                        }
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundStyle(.white)
                                    }.buttonStyle(.glass)
                                } else {
                                    Button {
                                        withAnimation {
                                            diaryViewModel.selectedImage = nil
                                        }
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        
                    }
                
            }else{
                VStack {
                    Image("material-symbols_add-a-photo-outline")
                        .padding(.vertical, 10)
                    
                    Text("Add Photo")
                        .font(.custom("Inter-regular", size: AdaptiveFontSize.adaptive16))
                        .foregroundStyle(.gray)
                    
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 169)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color(hex: "#565656"), lineWidth: 1)
                )
                .onTapGesture {
                    showDialog = true
                }
            }
            
            
            TextField("Meal Name", text: $diaryViewModel.newName)
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive16))
                .frame(maxWidth: .infinity)
                .focused($isKeyboardActive)
                .padding(.leading)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color(hex: "#565656"), lineWidth: 1)
                )
            
            TextField("Calories", text: $diaryViewModel.newCalories)
                .keyboardType(.numberPad)
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive16))
                .frame(maxWidth: .infinity)
                .padding(.leading)
                .focused($isKeyboardActive)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color(hex: "#565656"), lineWidth: 1)
                )
            
            
            
            Button {
                diaryViewModel.addFood(name: diaryViewModel.newName, userCalories: Double(diaryViewModel.newCalories) ?? 0, image: diaryViewModel.selectedImage)
                diaryViewModel.showAddMealView = false
            } label: {
                Text("Add")
                    .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive16))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .padding(.leading)
                    .padding(.vertical)
                    .background(isFormValid ? Color(hex: "#26B52F") : Color.gray)
                    .clipShape(.capsule)
                    .disabled(!isFormValid)
            }
            
            
            Button {
                diaryViewModel.showAddMealView = false
                diaryViewModel.newCalories = ""
                diaryViewModel.newName = ""
            } label: {
                Text("Cancel")
                    .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive16))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .padding(.leading)
                    .padding(.vertical)
                    .background(Color(.black).opacity(0.5))
                    .clipShape(.capsule)
            }
            .padding(.bottom, 10)
        }
        .padding(20)
        .background(
            LiquidGlassBackground()
        )
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            isKeyboardActive = false
        }
        .sheet(isPresented: $showDialog) {
            VStack(spacing: 20) {
                
                Text("Choose option")
                    .font(.headline)
                    .padding(.top)
                
                Button {
                    showDialog = false
                    sourceType = .camera
                } label: {
                    Text("Camera")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                }
                
                Button {
                    showDialog = false
                    sourceType = .photoLibrary
                } label: {
                    Text("Gallery")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                }
                
                Button("Cancel") {
                    showDialog = false
                }
                .foregroundColor(.red)
                
            }
            .padding()
            .presentationDetents([.height(220)])
        }
        .sheet(item: $sourceType) { source in
            ImagePicker2(sourceType: source) { image in
                diaryViewModel.selectedImage = image
            }
        }
    }
}

#Preview {
    AddMealView()
}

extension UIImagePickerController.SourceType: @retroactive Identifiable {
    public var id: Int { rawValue }
}
