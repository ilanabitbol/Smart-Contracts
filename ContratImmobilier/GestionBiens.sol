// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import './Owner.sol';

contract TestContract is Owner {
    
    uint compteur;
    
    //Different types de bien possible
    enum typeBien {terrain, appartement, maison}
    
    struct bien {
        uint id;
        string name;
        uint price;
        typeBien _typeBien;
    }
    
    //Le proprietaire d'une address ethereum pourra posseder un tableau de biens nommé Possessions
    mapping(address => bien[]) Possessions;
    
    //Declaration du modifier is Owner permet de n'autoriser que le owner du contract de rajouter un bien pour un proprietaire dans le smart contract
    function addBien(address _proprietaire, string memory _name, uint _price, typeBien _typeBien) public isOwner {
        require(_price > 1000, "Le prix du bien doit etre superieur a 1000 wei");
        require(uint(_typeBien) >= 0, "Le type de bien doit etre compris entre 0 et 2");
        require(uint(_typeBien) <=2, "Le type de bien doit etre compris entre 0 et 2");
        Possessions[_proprietaire].push(bien(compteur, _name, _price, _typeBien));
        compteur++;
        
    }
    
    //Le owner du contract peut recuperer les biens rattaches a une address d'un proprietaire
    function getBiens(address _proprietaire) public view isOwner returns(bien[] memory){
        return Possessions[_proprietaire];
    }
    
    //Recuperer le nombre de bien dun proprietaire
    function getNombreBiens(address _proprietaire) public view isOwner returns(uint){
        return Possessions[_proprietaire].length;
    }
    
    function getMesBiens() public view returns(bien[] memory){
        return Possessions[msg.sender];
    }
    
}
