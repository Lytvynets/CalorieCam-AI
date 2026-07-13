//
//  DeleteMealAlert.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 16.03.2026.
//

import SwiftUI

struct DeleteMealAlert: View {
    
    @EnvironmentObject var diaryViewModel: DiaryViewModel

    
    var body: some View {
        
        VStack(spacing: 20) {
            
            HStack {
                Spacer()
                if #available(iOS 26.0, *) {
                    Button {
                        diaryViewModel.showDeleteAlert = false
                        diaryViewModel.NSManagedObjectIDToDelete = nil
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }.buttonStyle(.glass)
                } else {
                    Button {
                        diaryViewModel.showDeleteAlert = false
                        diaryViewModel.NSManagedObjectIDToDelete = nil
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
            

            Text("Are you sure you want to delete this \nmeal “Caesar Salad”?")
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
            
            
            Button {
                if let id = diaryViewModel.NSManagedObjectIDToDelete {
                    diaryViewModel.deleteFood(by: id)
                    diaryViewModel.showDeleteAlert = false
                    diaryViewModel.NSManagedObjectIDToDelete = nil
                }
            } label: {
                Text("Delete")
                    .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive16))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .padding(.leading)
                    .padding(.vertical)
                    .background(Color(hex: "#26B52F"))
                    .clipShape(.capsule)
            }
            
            
            Button {
                diaryViewModel.showDeleteAlert = false
                diaryViewModel.NSManagedObjectIDToDelete = nil
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
    }

}

#Preview {
    DeleteMealAlert()
}
