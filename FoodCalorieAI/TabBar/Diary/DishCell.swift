//
//  DishCell.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 15.03.2026.
//

import SwiftUI
import CoreData

struct DishCell: View {
    
    @EnvironmentObject var diaryViewModel: DiaryViewModel

    @State var name: String
    @State var calories: String
    @State var image: UIImage?
    @State var NSManagedObjectID: NSManagedObjectID
    
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(width: 71, height: 53)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "#565656"), lineWidth: 1)
                    )
                    .clipped()
            }else{
                Image("Group 13")
                    .resizable()
                    .frame(width: 71, height: 53)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Text(name)
                .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive16))

            Spacer()
            Image("noto-v1_fire")
            Text(calories)
                .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive21))
            
            Text("kcal")
                .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive12))
    
            Button {
                diaryViewModel.NSManagedObjectIDToDelete = NSManagedObjectID
                diaryViewModel.showDeleteAlert = true
            } label: {
                Image("material-symbols-light_delete-outline")
            }
        }
        .padding(.vertical, 7)
    }
}

#Preview {
  //  DishCell(name: "Test", NSManagedObjectID: <#NSManagedObjectID#>)
}
