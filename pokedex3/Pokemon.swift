//
//  Pokemon.swift
//  pokedex3
//
//  Created by Jeremy Clerico on 28/06/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import Foundation
import Alamofire

//Be able to display long list of all pokemon (718) with their images and names. To do this, we have a class of pokemon that can store all that information for each pokemon. [Think of it as a blueprint or mould for each pokemon]
class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    
    //Properties from the second VC
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    
    //Variable for the API URL
    private var _pokemonURL: String!
    
    
    //Getters for properties (private vars) above: Want to protect the data and make sure we are only providing a real value or if there isnt anything in there well return an empty string
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    
    //Getters for private vars name and pokedexID
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
        
        //Each time we create a Pokemon we also want to create the API URL. Combination of URL's in constants.swift file and the PokedexID.
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    //Dont want to make 718 API calls in one go. Want it so whenever we click on a Pokemon and go to the Detail VC, THEN we want to make the API call and pull the data. (Called 'lazy loading')
    //Also, want this function to run when were done downloading - thats why we created the (completed: @escaping DownloadComplete)
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        //Created our AlamoFire get request and we passed in the _pokemonURL. All the data were going to get back is going to be in 'response'.
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
             if let dict =  response.result.value as? Dictionary<String, AnyObject> {
                
                //Drill down and get the values we want from the dictionary.
                //Setting each one to a String, although we dont know 100% that they will be a String value - if it is different it will return nil or give us an error
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
    //Recap for this function: We are calling the downloadPokemonDetail function, then do network request with AlamoFire ('GET' request) and sending _pokemonURL that contains the API and the specific Pokemon, and were getting a 'response' back. Were putting response inside the dictionary, and we use additional 'if let' calls to go further into the dictionary and extract the data that we want.
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                //Grabbing Types of pokemon from the API. Were going into the main dictionary and finding the attribute of types from the dictionary from the API.
                //The ', types.count > 0 ' means create the dictionary called types if there is > 0 types in the dictionary.
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                    
                    //Below we are taking the first dictionary in the array of dictionary 'types', and look for the attribute name, and were going to assign the value of that to 'name', and assign the class value of _type to that name and capitalize it.
                    //If only one type, then the below condition will be called.
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    //Taking care of the scenario where there are more than one type for a pokemon
                    //If there are more than 1 types, it will loop through however many dictionaries there are with the attribute 'name', and take the value of it (the type) and it will add onto it with a slash (the self._type! += .... part)
                    if types.count > 1 {
                        
                        for x in 1..<types.count {
                            
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                    print(self._type)
                    
                } else {
                    //Taking care of the scenario where there are no types
                    self._type = ""
                }
                
                //Description of Pokemon
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    
                    //Get URL we need to follow (The value of the key in the description dictionary is a link to another api which contains the description text) [E.g. see https://pokeapi.co/api/v1/pokemon/1/ and you can see it says in the description dictionary "resource_uri":"/api/va/description/5/".
                    if let url = descArr[0]["resource_uri"] {
                        let descURL = "\(URL_BASE)\(url)"
                        
                        //calling next api to get to the descriptions
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            //Now we followed the api to the description, we need to extract the description data.
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    
                                    //Fixing Description as it doesnt display the é.
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokémon")
                                    
                                    self._description = newDescription
                                    print(newDescription)
                                }
                            }
                            //For 2nd API Call
                            completed()
                            
                        })
                    }
                } else {
                    //If no description at all
                    self._description = ""
                }
                
                //Evolution API
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        //Exclude unsupported Evolutions ('Mega' Evolution stage)
                        if nextEvo.range(of: "mega") == nil {
                         
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                //Similar to description, value of key leads to another API. (example /api/v1/pokemon/2/). As it gives us the ID of the pokemon the current one evolves into, we can replace the /api/..../ so we just have the ID left
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                //Remove trailing / --> api/.../2/ <-- This one!
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                //Next, the 'Next Evolution' label. Not all Pokemon evolve in same way so we have to take that into account.
                                if let lvlExist = evolutions[0]["level"] {
                                    
                                    if let lvl = lvlExist as? Int {
                                        
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                } else {
                                    
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                    print(self.nextEvolutionLevel)
                    print(self.nextEvolutionName)
                    print(self.nextEvolutionId)
                }
                
                
            }
            completed() //Only works for the 1st API call so we need a 2nd one for the second description api call (above)
        }
    }
}


































