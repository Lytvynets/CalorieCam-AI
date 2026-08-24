//
//  DailyCaloriesView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 01.08.2025.
//

import SwiftUI

struct DiaryView: View {
    
    @EnvironmentObject var inAppPurchaseViewModel: InAppPurchaseViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            LiquidBackground()
            header
            
            VStack {
                CalorieProgressView(
                    currentCalories: Double(diaryViewModel.totalCalories),
                    goalCalories: Double(profileViewModel.dailyCalories ?? 0)
                )
                addButton
                if diaryViewModel.filteredFoods.isEmpty {
                    emptyContent
                }else{
                    content
                }
                Spacer()
            }
            .padding(.top, 65)
            
            if diaryViewModel.showAddMealView {
                BlurView(style: .systemUltraThinMaterialDark)
                    .ignoresSafeArea()
                AddMealView()
            }
            
            if diaryViewModel.showDeleteAlert {
                BlurView(style: .systemUltraThinMaterialDark)
                    .ignoresSafeArea()
                DeleteMealAlert()
            }
            
        }
        .onAppear {
            diaryViewModel.setContext(viewContext)
        }
    }
    
    
    private var header: some View {
        VStack {
            HStack {
                
                if #available(iOS 26.0, *) {
                    Button {
                        withAnimation {
                            diaryViewModel.goToPreviousDay()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .frame(width: 25, height: 25)
                    }
                    .padding(.horizontal)
                    .buttonStyle(.glass)
                } else {
                    Button {
                        withAnimation {
                            diaryViewModel.goToPreviousDay()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .frame(width: 25, height: 25)
                    }
                    .clipShape(.circle)
                    .padding(.horizontal)
                }
                
                Rectangle()
                    .frame(width: 50, height: 5)
                    .foregroundStyle(.clear)
                
                if #available(iOS 26.0, *) {
                    Button {
                        withAnimation {
                            diaryViewModel.goToNextDay()
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .frame(width: 25, height: 25)
                        
                    }
                    .padding(.horizontal)
                    .buttonStyle(.glass)
                } else {
                    Button {
                        withAnimation {
                            diaryViewModel.goToNextDay()
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .frame(width: 25, height: 25)
                    }
                    .clipShape(.circle)
                    .padding(.horizontal)
                }
            }.overlay {
                
                Text("\(diaryViewModel.formattedDate)")
                    .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive20))
                    .foregroundStyle(.white)
            }
            
            Spacer()
        }
    }
    
    
    private var addButton: some View {
        HStack {
            Text("Meals:")
                .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive18))
            
            Spacer()
            
            Button {
                if inAppPurchaseViewModel.isSubscribed {
                    diaryViewModel.selectedImage = nil
                    diaryViewModel.newName = ""
                    diaryViewModel.newCalories = ""
                    withAnimation {
                        diaryViewModel.showAddMealView = true
                    }
                }else{
                    inAppPurchaseViewModel.showInAppPaywall = true
                }
            } label: {
                HStack {
                    Image("material-symbols_add-rounded")
                    Text("Add")
                        .foregroundStyle(.white)
                        .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive16))
                }
                .padding(.vertical, 7)
                .padding(.horizontal)
                .background(Color(hex: "#26B52F"))
                .clipShape(.capsule)
            }
        }
        .padding()
        .padding(.top)
    }
    
    
    private var content: some View {
        ScrollView {
            ForEach(diaryViewModel.filteredFoods) { food in
                DishCell(name: food.name, calories: "\(Int(food.calories))", image: food.image, NSManagedObjectID: food.objectID)
                    .onTapGesture {
                        print("DATE \(food.date)")
                    }
                Divider()
                    .background(.gray)
            }
        }
        .padding(.horizontal)
        .scrollIndicators(.hidden)
    }
    
    
    private var emptyContent: some View {
        ScrollView {
            Image("hugeicons_dish-01")
                .padding(.bottom, 10)
            
            Text("Your list is empty")
                .font(.custom("Inter-Regular", size: AdaptiveFontSize.adaptive16))
                .foregroundStyle(Color(hex: "#979797"))
        }.scrollIndicators(.hidden)
    }
}


#Preview {
    DiaryView()
}
