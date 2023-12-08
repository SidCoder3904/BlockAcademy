// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AcademicSystem {
    struct Professor {
        string name;
        string password;
        uint256 uniqueId;
    }

    struct Student {
        string name;
        string password;
        uint256 uniqueId;
        mapping(string => uint256) subjectMarks; // Mapping of subjects to marks
    }

    mapping(uint256 => Professor) public professors;
    mapping(uint256 => Student) public students;

    event ProfessorRegistered(uint256 uniqueProfessorId);
    event StudentRegistered(uint256 uniqueStudentId);
    event MarksSet(uint256 uniqueId, string subject, uint256 marks);

    function registerProfessor(string memory _name, string memory _password) external {
        uint256 uniqueProfessorId = 1000 + uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 9000;
        professors[uniqueProfessorId] = Professor(_name, _password, uniqueProfessorId);
        emit ProfessorRegistered(uniqueProfessorId);
    }

    function registerStudent(string memory _name, string memory _password) external {
        uint256 uniqueStudentId = 1000 + uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 9000;
    
        // Initialize the Student struct
        Student storage newStudent = students[uniqueStudentId];
        newStudent.name = _name;
        newStudent.password = _password;
        newStudent.uniqueId = uniqueStudentId;

        // Emit the StudentRegistered event
        emit StudentRegistered(uniqueStudentId);
    }

    function loginProfessor(uint256 _uniqueId, string memory _password) external view returns (bool) {
        return professors[_uniqueId].uniqueId == _uniqueId && keccak256(abi.encodePacked(_password)) == keccak256(abi.encodePacked(professors[_uniqueId].password));
    }

    function loginStudent(uint256 _uniqueId, string memory _password) external view returns (bool) {
        return students[_uniqueId].uniqueId == _uniqueId && keccak256(abi.encodePacked(_password)) == keccak256(abi.encodePacked(students[_uniqueId].password));
    }

    function setMarks(uint256 _uniqueId, string memory _subject, uint256 _marks) external {
        students[_uniqueId].subjectMarks[_subject] = _marks;
        emit MarksSet(_uniqueId, _subject, _marks);
    }

    function getMarks(uint256 _uniqueId, string memory _subject) external view returns (uint256) {
        return students[_uniqueId].subjectMarks[_subject];
    }
}
