//
//  PokeCell.swift
//  pokedex3
//
//  Created by Jeremy Clerico on 28/06/2017.
//  Copyright © 2017 Jeremy Clerico. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    //!!READ!! https://stackoverflow.com/questions/38386339/what-exactly-is-init-coder-adecoder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Rounding the corners of each cell
        layer.cornerRadius = 5.0
    }
    
    //function will be called when we want to change contents of each cell
    func configureCell(_ pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    
}
