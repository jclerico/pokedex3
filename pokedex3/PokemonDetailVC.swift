//
//  PokemonDetailVC.swift
//  pokedex3
//
//  Created by Jeremy Clerico on 29/06/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name.capitalized
        
        //Set up Main Image and Current Evolution Image (same image)&Update PokedexId number in the Detail View Controller
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        
        //Whatever we write inside pokemon.downloadPokemonDetail { } will only be called afer the network call is complete.
        pokemon.downloadPokemonDetail {
            //Whenever data is available, update the UI to have that data
            self.updateUI()
        }
    }
    
    //Update UI text labels on VC when you click on a Pokemon (Detail VC)
    func updateUI() {
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        //Case where there is no next evolution - Change evoLbl and hide nextEvoImg. AS nextEvoImg is in a stackview, that stackview will automatically center the remaining image.
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            //If there IS a next evolution, dont hide nextEvoImg and change it to the next evolution image (which is the ID we got from the API)
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            //If theres a next evolution, change the evoLbl text to display the name and at what level it evolves.
            let str = "Next Evolution \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        //Take user back to home view (original view)
        dismiss(animated: true, completion: nil)
    }
    

}
