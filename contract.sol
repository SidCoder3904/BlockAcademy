// SPDX-License-Identifier: MIT 
pragma solidity >0.7.0 <=0.8.23;

contract School {

    mapping(string => uint32) public course_codes;    // maps string course code to number, can be edited only by admin

    // ************* custom structures to store students/staff info ****************

    struct course {
        uint32 course_code;    // each subject/course will have unique code
        uint256 marks;    // can be extended to part wise marks like midsem, endsem, etc
    }
    
    struct grade {
        uint8 class;    // class like 1,2,...,12 or sem like 1,2,...,8  
        course[] courses;
        uint8 n_courses;
    }

    struct Student {
        address acct;
        string first_name;
        string last_name;
        uint32 inst_id;     // students will have their unique identity
        grade[] grades;
        uint8 n_grades;
        // can add more personal details like dob, parents, contact, address etc
    }

    struct program {
        uint32 course_code;
        uint16 max_strenght;
        // we can add constraints like eligibility criterian etc...
    }

    struct Instructor {
        address acct;
        string first_name;
        string last_name;
        uint32 staff_id;    // staff will have unique id
        program[] programs_offered;  // offered by this prof
        uint8 n_programs;
        // can add more personal info like contact, degree etc...
    }

    string public school_name;
    address internal admin;      // can validate and unenroll students/staff in case situation arises but enrollment is decentralized by student themselves
    mapping(uint32 => Student) internal all_students;
    mapping(uint32 => Instructor) internal all_instructors;

    // ****************** constructors and modifiers to manage access *********************

    constructor(string memory _school_name) {     // initialize school
        school_name = _school_name;
        admin = msg.sender;
    }

    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }

    modifier onlyProfessor(uint32 _staff_id, string memory _course_name) {
        require(msg.sender == all_instructors[_staff_id].acct);      // should be a valid instructor
        bool valid_course = false;
        for(uint8 i=0; i<all_instructors[_staff_id].n_programs; i++)    // should be taking the course
            if(course_codes[_course_name] == all_instructors[_staff_id].programs_offered[i].course_code) valid_course = true;
        require(valid_course == true);
        _;
    }

    modifier onlyStudent(uint32 _inst_id){
        require(msg.sender == all_students[_inst_id].acct);
        _;
    }

    // *************** functions to access student record ********************
    // to be edited...
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
        
