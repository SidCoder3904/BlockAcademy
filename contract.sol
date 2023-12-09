// SPDX-License-Identifier: MIT 
pragma solidity >=0.7.4;

contract student_ {
    enum subjects {MAT, ENG, SCI, SST, COM}
    address admin ;
    
    uint256 internal constant nSubj = 5;

    string public first_name = "Firstname";
    string public last_name = "Lastname";
    uint256 public age = 18;
    bool public isPass;
   mapping (address=>mapping(subjects => uint256)) internal marks;
    mapping (subjects => address) internal  prof;
    mapping (string => mapping(string => address)) internal student;
    
    constructor(){
       
        prof[subjects.MAT]=0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
        prof[subjects.ENG]=0x583031D1113aD414F02576BD6afaBfb302140225;
        prof[subjects.SCI]=0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB;
        prof[subjects.SST]=0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;
        prof[subjects.COM]=0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
        admin=0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC;
    }

    modifier onlyProfessor(subjects sub_code) {

        require(msg.sender == prof[sub_code]);
        _;
    }
    modifier onlyAdmin{
        require (msg.sender == admin);
        _;
    }
    modifier onlystudent(string memory _fname,string memory _lname){
        require(student[_fname][_lname] == msg.sender);
        _;
    }
    

    /*constructor(string memory _fname, string memory _lname, uint256 _age) {
        first_name = _fname;
        last_name = _lname;
        age = _age;
        isPass = true;
        for(uint256 i=0; i<nSubj; i++) marks[i] = 100;
    }*/

    function Register(string memory _fname,string memory _lname,address _address) public onlyAdmin{
         student[_fname][_lname]=_address;
    }

function editName(string memory _fname, string memory _lname) public {
        first_name = _fname;
        last_name = _lname;
    }

    function checkPass(uint256 _marks) public pure returns(bool) {
        if(_marks < 33) return false;
        return true;
    }
    function setMarks(string memory _fname,string memory _lname,subjects sub_code, uint256 _marks) public onlyProfessor(sub_code) {
        address _address=student[_fname][_lname];
        marks[_address][sub_code]=_marks; 
        isPass = checkPass(_marks);
    }

    function getMarks(string memory _fname,string memory _lname,subjects sub_code) public view onlystudent(_fname,_lname) returns(uint256)  {
        return marks[msg.sender][sub_code];
    }
}
        
