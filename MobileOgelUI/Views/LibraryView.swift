//
//  LibraryView.swift
//  MobileOgelUI
//
//  Contributors: Harsimran Kanwar, Shuvaethy Neill, and Guy Morgenshtern
//

import SwiftUI

enum FilterCategory: String, CaseIterable {
    case Perfect, Similar, All
}

struct LibraryView: View {
    @State private var viewModel = LegoSetViewModel()
    
    @State private var selectedItem: FilterCategory = .Perfect // Default
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                VStack {
                    HeaderView(title: "Library")
                    
                    VStack {
                        HStack() {
                            ForEach(FilterCategory.allCases, id: \.self) { item in
                                FilterItem(filterCategory: item, selectedFilter: $selectedItem)
                            }
                            
                        }
                        switch selectedItem {
                        case .All:
                            SetsListView(setList: viewModel.allSets)
                        case .Similar:
                            SetsListView(setList: viewModel.fuzzySets)
                        default:
                            SetsListView(setList: viewModel.perfectSets)
                        }
                    }
                }
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
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
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
