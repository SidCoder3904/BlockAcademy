// SPDX-License-Identifier: MIT 
pragma solidity >=0.7.4;

contract student {
    enum subjects {MAT, ENG, SCI, SST, COM}
    uint256 internal constant nSubj = 5;

    string public first_name = "Firstname";
    string public last_name = "Lastname";
    uint256 public age = 18;
    bool public isPass;
    mapping (subjects => uint256) internal marks;

    constructor(string memory _fname, string memory _lname, uint256 _age) {
        first_name = _fname;
        last_name = _lname;
        age = _age;
        isPass = true;
        for(uint256 i=0; i<nSubj; i++) marks[subjects(i)] = 100;
    }

    function editName(string memory _fname, string memory _lname) public {
        first_name = _fname;
        last_name = _lname;
    }

    function checkPass() public view returns(bool) {
        for(uint256 i=0; i<nSubj; i++) if(marks[subjects(i)] < 33) return false;
        return true;
    }

    function setMarks(uint256 sub_code, uint256 _marks) public {
        marks[subjects(sub_code)] = _marks;
        isPass = checkPass();
    }

    function getMarks(uint256 sub_code) public view returns(uint256) {
        return marks[subjects(sub_code)];
    }
}