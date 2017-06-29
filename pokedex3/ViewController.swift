//
//  ViewController.swift
//  pokedex3
//
//  Created by Jeremy Clerico on 28/06/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit
import AVFoundation //If working with audio need to import this

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Create array of pokemon
    var pokemon = [Pokemon]()
    
    //Create array for searchbar pokemon and boolean for if we are in search mode or not
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    //Create Music Player Variable
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assigning delegate & datasource to self so we can see a collection
        collection.dataSource = self
        collection.delegate = self
        //Assigning delegate to self for searchbar so we can implement methods that are connect to the delegate
        searchBar.delegate = self
        
        //Call Func when the application loads so its ready for us to use
        parsePokemonCSV()
        
        //Automatically start playing music
        initAudio()
        
    }
    
    //Function thats gets any audio ready
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!//Force Unwrap as know path is valid
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)//Pass in url for audio ('path' from above constant)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //Loop continuously
            musicPlayer.play()
            
        } catch let err as NSError {
            
            print(err.debugDescription) //AudioPlayer can throw error so have to use do { } catch let..... etc incase of error.
        }
    }
    
    
    
    //Function to parse the Pokemon CSV data and put it into a form that is useful to us
    func  parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!//Force unwrap as we know it will have a value. This code is taking us to the location of the CSV file (pokemon.csv)
        
        do {
            //Using the parser to pull out the rows
            let csv = try CSV(contentsOfURL: path)//defined 'path' above
            let rows = csv.rows
            print(rows)
            
            for row in rows {
                //Go through each row and get pokeId and name
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                //create pokemon object called poke &attach it to the array called pokemon (created above)
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    //Breif Explanation So Far:  Once parsePokemonCSV() is called in viewDidLoad, should have an array of pokemon that is filled with 718 Pokemon with the name and pokeId for each.
    //Then look at cellForItemAt.... the cell.configureCell(poke) will go into PokeCell.swift and assign the name and thumb image to our PokeCell in the main.storyboard.
    
    
    
    
    //Where we want to create cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Set the ReuseIdentifier in the Attributes Inspector fo the cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke = pokemon[indexPath.row]
            //Each time this function is called, take the pokemon at indexPath.row, assign it to poke and then pass poke into cell.configureCell
            cell.configureCell(poke)
            
            return cell
        } else {
            return UICollectionViewCell()
            //Using dequeueReusableCell since there are 718 Pokemon, dont want app to try and load all 718 cells.. Using this it only loads how many are going to be displayed at a time. When you scroll, those that go off the screen dequeue and we pick up another cell..... The else statement is saying grab a dequeue cell if you can, if not return empty generic cell.
        }
    }
    
    //Code will be executed when we tap on a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    //Sets the number of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pokemon.count //As many pokemon as are in the array
    }
    
    //The number of sections in the collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
         return 1
    }
    
    //Helps us to define the size of the cells 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
        
    }
    
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        //Pause music when button is pressed
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            
            //Playing => button is opaque
            sender.alpha = 0.2
            
        } else {
            //If not playing, when button is pressed music starts playing
            musicPlayer.play()
            
            //Paused => button is a bit transparent
            sender.alpha = 1.0
        }
    }
    
    //Whenever a keystroke is made in the searchbar, the code below will be called
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //If below is true, we are NOT in search mode ( || is "OR" Operator)
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            
            //If nothings in search bar or if we deleted what we had in the search bar, then revert back to the original list of Pokemon 
            collection.reloadData()
            
        } else {
            //ELSE we ARE in search mode
            inSearchMode = true
            
            //NEXT PART: We want to take the string that is in the search bar and compare it with any and all the Pokemon object names. If what we have in the search bar is included in any of the pokemon names then we put that into the new filtered Pokemon array and display that one.
            
            //String that is entered in the search bar
            let lower = searchBar.text!.lowercased()
            
            //Filter - Explanation: Were saying the filtered pokemon list is going to be equal to the original Pokemon list, but its filtered.
            //The $0 can be though of as a placeholder for any and all objects in the original Pokemon Array.
            //We're saying for each object which is a placeholder for $0, we take the name value and then were saying 'is what we put in the search bar contained inside of that name'? If it is, put it into the filteredPokemon list.
            
            //Alternative Explanation: Were creating a filterd list from the original list of Pokemon, and were filtering it based on whether the search bar text is inculded in the range of the original name, and the $0 is just a placeholder for each item in that array.
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil })
            
            //Repopulate the collection view with the new data
            collection.reloadData()
            
        }
    }
    
}






