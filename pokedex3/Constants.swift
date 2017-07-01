//
//  Constants.swift
//  pokedex3
//
//  Created by Jeremy Clerico on 30/06/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import Foundation

//URL to the API Website which is always the same url
let URL_BASE = "https://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"


//Network calls (api) are ASYNCHRONOUS - meaning that we dont know EXACTLY when those are going to be completed. Therefore, in out PokemonDetailVC.swift, we cant just start setting the labels to those variables as it would crash because they arent immediatly available on viewDidLoad (As it takes a second or so to pull the data from api). THEREFORE, we want to create a 'CLOSURE' so the View Controller knows when the data will be available
//Block of code that is run at a specific time / a later if needed. 
//We are going to pass this closure to our downloadPokemonDetails() function.
typealias DownloadComplete = () -> ()
