//
//  LibraryView.swift
//  MobileOgelUI
//
//  Created by Harsimran Kanwar and Shuvaethy Neill on 2023-11-03.
//

import SwiftUI

enum FilterCategory: String, CaseIterable {
    case Perfect, Similar, All
}

struct LibraryView: View {
    @State private var selectedItem: FilterCategory = .Perfect // Default

    var body: some View {
        NavigationStack{
            VStack {
                HeaderView(title: "Library")
                
                VStack {
                    //perhaps we can do something like this
                    ScrollView {
                        HStack() {
                            ForEach(FilterCategory.allCases, id: \.self) { item in
                                FilterItem(filterCategory: item, selectedFilter: $selectedItem)
                            }
                        }
                        switch selectedItem {
                        case .All:
                            //TODO: iterate all results that fall under perfect
                            Text("All results!")
                        case .Similar:
                            //TODO: iterate all results that fall under perfect
                            Text("Fuzzy results!")
                        default:
                            //TODO: iterate all results that fall under perfect
                            Text("Perfect results!")
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}

//TODO: very rough, need to refactor (also ideally we would would want to use VM for all data)
struct FilterItem: View {
    let filterCategory: FilterCategory
    @Binding var selectedFilter: FilterCategory
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(selectedFilter == filterCategory ? Color(red: 0.859, green: 0.929, blue: 0.702) : Color(red: 0.902, green: 0.906, blue: 0.91))
                .frame(width: 80, height: 50)

            Text(filterCategory.rawValue)
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
            }
            .onTapGesture {
                selectedFilter = filterCategory
            }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
