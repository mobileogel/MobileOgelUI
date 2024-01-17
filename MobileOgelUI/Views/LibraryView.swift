//
//  LibraryView.swift
//  MobileOgelUI
//
//  Contributors: Harsimran Kanwar, Shuvaethy Neill, and Guy Morgenshtern
//

import SwiftUI

struct LibraryView: View {
    @State private var viewModel = LegoSetViewModel()
    @State private var selectedItem: LegoSetViewModel.FilterCategory = .Perfect // Default
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                VStack {
                    HeaderView(title: "Library")
                    
                    VStack {
                        HStack() {
                            ForEach(LegoSetViewModel.FilterCategory.allCases, id: \.self) { item in
                                FilterItem(filterCategory: item, selectedFilter: $selectedItem)
                            }
                        }
                        
                        // check if filter array is empty
                        if let filteredSets = viewModel.filterMap[selectedItem], filteredSets.isEmpty {
                            Spacer()
                            Text("No sets available for this filter.")
                                .foregroundColor(.gray)
                            Spacer()
                        } else {
                            SetsListView(setList: viewModel.filterMap[selectedItem] ?? [])
                        }
                    }
                }
            }
        }
    }
}

//TODO: very rough, need to refactor (also ideally we would would want to use VM for all data)
struct FilterItem: View {
    let filterCategory: LegoSetViewModel.FilterCategory
    @Binding var selectedFilter: LegoSetViewModel.FilterCategory
    
    private let selectedColor = Color(red: 0.859, green: 0.929, blue: 0.702)
    private let defaultColor = Color(red: 0.902, green: 0.906, blue: 0.91)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(selectedFilter == filterCategory ? selectedColor : defaultColor)
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

struct SetsListView: View {
    var setList: [LegoSet]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                Section {
                    ForEach(setList, id: \.self) { sample in
                        LegoSetView(set: sample)
                    }
                }
            }
            .padding(20)
        }
    }
}

struct LegoSetView: View {
    var set: LegoSet
    var body: some View {
        HStack(alignment: .top) {
            Image("\(set.setId)_thumbnail")
                .resizable()
                .frame(width: 80, height:80)
            
            
            VStack(alignment: .leading) {
                Text(set.setName)
                    .foregroundStyle(.black)
                    .font(.headline)
                Text("\(set.pieceCount) Pieces")
                    .foregroundStyle(.black)
                Link("Instructions", destination: URL(string: "https://www.lego.com/en-ca/service/buildinginstructions/\(set.setId)")!)
                if set.piecesMissing != nil {
                    MissingPiecesView(visible: false, missingPieces: set.piecesMissing!)
                }
            }
            
            Spacer()
        }
        .modifier(TileViewModifier())
    }
}

struct MissingPiecesView: View {
    @State var visible: Bool
    var missingPieces: [LegoPiece]
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button("Missing Pieces") {
                    visible.toggle()
                }.frame(alignment: .leading)
                Spacer()
            }
            if visible {
                ForEach(missingPieces, id: \.self) { piece in
                    PieceTileView(piece: piece).scaleEffect(1)
                        .padding(.bottom, 10)
                }
            }
        }
    }
    
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
