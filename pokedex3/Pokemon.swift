//
//  Pokemon.swift
//  pokedex3
//
//  Created by Jeremy Clerico on 28/06/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import Foundation

//Be able to display long list of all pokemon (718) with their images and names. To do this, we have a class of pokemon that can store all that information for each pokemon. [Think of it as a blueprint or mould for each pokemon]
class Pokemon {
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    
    //Getters for private vars
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    //Initilize each pokemon object
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
    
    
}
