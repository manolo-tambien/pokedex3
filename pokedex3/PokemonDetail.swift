//
//  PokemonDetail.swift
//  pokedex3
//
//  Created by Manolo on 21/02/24.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var pokemon: Pokemon
    
    // State that shows pokemon shiny
    @State var showShiny = false
    
    var body: some View {
        ScrollView{
            ZStack{
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
                AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 6)
                } placeholder: {
                    ProgressView()
                }
            }
            
            HStack{
                ForEach(pokemon.types!, id:\.self){ type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 1)
                        .padding([.top, .bottom])
                        .padding([.leading, .trailing])
                        .background(Color(type.capitalized))
                        .cornerRadius(50)
                }
                
                Spacer()
                
                Button{
                    withAnimation{
                        pokemon.favorite.toggle()
                        
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                } label: {
                    if pokemon.favorite{
                        Image(systemName: "star.fill")
                    } else {
                        Image(systemName: "star")
                    }
                }
                .font(.title)
                .foregroundColor(.yellow)
            }
            .padding()
            
            Text("Stats")
                .font(.title)
            
            Stats()
                .environmentObject(pokemon)
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button{
                    showShiny.toggle()
                } label: {
                    if showShiny {
                            Image(systemName: "wand.and.stars")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "wand.and.stars.inverse")
                    }
                }
            }
        }
    }
}

struct PokemonDetail_Previews: PreviewProvider{
    static var previews: some View {
        return PokemonDetail()
            .environmentObject(SamplePokemon.samplePokemon )
    }
}
