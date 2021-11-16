// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract GestionnaireEleve {
    
    //Celui qui peut gerer les eleves est le proprietaire du contract, celui qui l'a deploye
    address owner;
    
    struct Grade {
        string subject;
        uint grade;
    }
    
    struct Student {
        string firstName;
        string lastName;
        uint numberOfGrades;
        //Chaque note aura un index qui permettra de recuperer les notes
        mapping(uint => Grade) grades;
    }
    
    //Chaque eleve est represente par une address
    //A une address on map une structure Student qui possede un nom, prenom , etc.
    mapping(address => Student) students;
    
    //Que se passe til quand le contract est deploye
    constructor() {
        //Quand le contract est deploye, la variable owner correspond a l'address avec laquel le contract est deploye (msg.sender)
        owner = msg.sender;
    }
    
    function addStudent(address _studentAddress, string memory _firstName, string memory _lastName) public {
        require(msg.sender == owner, "L ajout d un eleve n'est autorise que par le owner du contract");
        //bytes est comme un string mais consommme moins de gas
        //On recupere le firstName rattache a l'address s'il existe deja
        bytes memory firstNameOfAddress = bytes(students[_studentAddress].firstName);
        //On arrete la fonction si l'eleve existe deja, cad si firstNameOfAddress 
        require(firstNameOfAddress.length == 0, "Eleve existe deja");
        students[_studentAddress].firstName = _firstName;
        students[_studentAddress].lastName = _lastName;
    }
    
    function addGrade(address _studentAddress, uint _grade, string memory _subject) public {
        require(msg.sender == owner, "L ajout d'une note n'est autorise que par le owner du contract");
        bytes memory firstNameOfAddress = bytes(students[_studentAddress].firstName);
        require(firstNameOfAddress.length > 0, "Il faut creer l'eleve");
        //On recupere la structure Student en fonction de l'address de l'eleve
        students[_studentAddress].grades[students[_studentAddress].numberOfGrades].grade = _grade;
        students[_studentAddress].grades[students[_studentAddress].numberOfGrades].subject = _subject;
        students[_studentAddress].numberOfGrades++;
    }
    
    function getEleve(address _studentAddress) public view returns(string memory){
        require(msg.sender == owner, "Seul le owner peut recuperer un eleve");
        string memory eleveName = string(abi.encodePacked(students[_studentAddress].firstName," ", students[_studentAddress].lastName));
        bytes memory tempEleveName = bytes(students[_studentAddress].firstName);
        require(tempEleveName.length > 0, "Il faut creer l'eleve");
        return eleveName;
    }
    
    function getGrade(address _studentAddress) public view returns(uint[] memory){
        require(msg.sender == owner, "Seul le owner peut recuperer les notes");
        uint numberGradesThisStudent = students[_studentAddress].numberOfGrades;
        uint[] memory grades = new uint[](numberGradesThisStudent);
        for(uint i = 0; i < numberGradesThisStudent; i++){
            grades[i] = students[_studentAddress].grades[i].grade;
        }
        return grades;
    }
}
