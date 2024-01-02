// SPDX-License-Identifier: MIT 
pragma solidity >0.7.0 <=0.8.23;

contract School {

    mapping(string => uint32) internal course_codes;    // maps string course code to number, can be edited only by admin

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
        address acct;   // maybe we can remove it
        string first_name;
        string last_name;
        uint32 stud_id;     // students will have their unique identity
        uint8 n_grades;
        grade[] grades;
        // can add more personal details like dob, parents, contact, address etc
    }

    struct program {
        uint32 course_code;
        uint16 max_strength;
        uint16 current_strength;
        // we can add constraints like eligibility criterian etc...
    }

    struct Staff {
        address acct;   // maybe we can remove it
        string first_name;
        string last_name;
        uint32 staff_id;    // staff will have unique id
        uint8 n_programs;
        program[] programs_offered;  // offered by this prof
        // can add more personal info like contact, degree etc...
    }

    uint32 internal school_strenght = 999;   // to get only 4 digit ids
    uint32 internal staff_strenght = 999;    // to get only 4 digit ids
    string public school_name;
    address internal admin;      // can validate and unenroll students/staff in case situation arises but enrollment is decentralized by student themselves
    uint32 course_counter=100; 

    mapping(uint32 => Student) internal all_students;   // stud_id -> student info
    mapping(address => uint32) internal student_map;    // acct adrs -> stud_id
    mapping(uint32 => Staff) internal all_staff;     // staff_id -> staff info
    mapping(address => uint32) internal staff_map;      // acct adrs -> staff_id

    // ****************** constructors and modifiers to manage access *********************

    constructor(string memory _school_name) {     // initialize school
        school_name = _school_name;
        admin = msg.sender;
    }

    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }

    modifier onlyStaff(uint32 _staff_id) {
        require(msg.sender == all_staff[_staff_id].acct);      // should be a valid instructor
        // bool valid_course = false;
        // for(uint8 i=0; i<all_staff[_staff_id].n_programs; i++)    // should be taking the course
        //     if(course_codes[_course_name] == all_staff[_staff_id].programs_offered[i].course_code) valid_course = true;
        // require(valid_course == true);
        _;
    }

    modifier validStaffId(uint32 _staff_id) {
        require(_staff_id <= staff_strenght && _staff_id > 999);
        _;
    }

    modifier validStudId(uint32 _stud_id) {
        require(_stud_id <= school_strenght && _stud_id > 999);
        _;
    }

    modifier onlyStudent(uint32 _inst_id) {
        require(msg.sender == all_students[_inst_id].acct);
        _;
    }

    modifier notStaff {
        require(staff_map[msg.sender] == 0);
        _;
    }
    
    modifier notStudent {
        require(student_map[msg.sender] == 0);
        _;
    }

    
    // *************** functions to access student record ********************
    // to be edited...
    // functions to be made:
    // register, enroll, get details, edit details, setmarks, getmarks, add courses, unregister

    function GetSchoolStrenght() public view returns(uint32) {
        return school_strenght-999;
    }

    function GetStaffStrenght() public view returns(uint32) {
        return staff_strenght-999;
    }

    function RegisterStudent(string memory _fname, string memory _lname) public notStudent notStaff returns(uint32) {   // staff also cannot register as student for now
        uint32 stud_id = ++school_strenght;
        student_map[msg.sender] = stud_id;
        all_students[stud_id].acct = msg.sender;
        all_students[stud_id].first_name = _fname;
        all_students[stud_id].last_name = _lname;
        all_students[stud_id].stud_id = stud_id;
        all_students[stud_id].n_grades = 1;
        return stud_id;
        // add time lock so that someone else might not be able to edit the blockchain at same time
    }

    function GetStudentDetails(uint32 _stud_id) public view validStudId(_stud_id) onlyStudent(_stud_id) returns(string memory, string memory) {
        return (all_students[_stud_id].first_name, all_students[_stud_id].last_name);
    }

    function RegisterStaff(string memory _fname, string memory _lname) public notStudent notStaff returns(uint32) {   // staff also cannot register as student for now
        uint32 staff_id = ++staff_strenght;
        staff_map[msg.sender] = staff_id;
        all_staff[staff_id].acct = msg.sender;
        all_staff[staff_id].first_name = _fname;
        all_staff[staff_id].last_name = _lname;
        all_staff[staff_id].staff_id = staff_id;
        program memory initial_prog;
        all_staff[staff_id].programs_offered.push(initial_prog);
        all_staff[staff_id].n_programs = 1;     // bcoz we have added 
        return staff_id;
        // add time lock so that someone else might not be able to edit the blockchain at same time
    }

    function GetStaffDetails(uint32 _staff_id) public view validStaffId(_staff_id) onlyStaff(_staff_id) returns(string memory, string memory) {
        return (all_staff[_staff_id].first_name, all_staff[_staff_id].last_name);
    }
    
    function offer_course(string memory _course,uint32 _id,uint16 max_strength ) public  validStaffId(_id) onlyStaff(_id) {
        all_staff[_id].n_programs=all_staff[_id].n_programs+1;

        course_codes[_course]=course_counter++;  //maybe course code could be suggested by prof. themselves
        all_staff[_id].programs_offered.push(program({course_code: course_codes[_course], max_strength: max_strength, current_strength:0}));
        
    }

    function enroll_course(string memory _course,uint32 stud_id,uint32 prof_id) public validStudId(stud_id) onlyStudent(stud_id){
        uint i=0;
        while(course_codes[_course]!=all_staff[prof_id].programs_offered[i].course_code ){
            require(i<(all_staff[prof_id].programs_offered).length,"No such course available.");
           i++;
        }
       require( all_staff[prof_id].programs_offered[i].current_strength < all_staff[prof_id].programs_offered[i].max_strength, "No more students are being accepted in this course.");
       all_staff[prof_id].programs_offered[i].current_strength++;
       uint n=all_students[stud_id].n_grades;
       all_students[stud_id].grades[n].courses.push(course({course_code:course_codes[_course],marks:0}));
       all_students[stud_id].grades[n].n_courses++; // a limit to number of courses that can be taken and what are available   
    }
    // function editName(string memory _fname, string memory _lname) public {
    //     first_name = _fname;
    //     last_name = _lname;
    // }

    // function checkPass(uint256 _marks) public pure returns(bool) {
    //     if(_marks < 33) return false;
    //     return true;
    // }
    // function setMarks(string memory _fname,string memory _lname,subjects sub_code, uint256 _marks) public onlyProfessor(sub_code) {
    //     address _address=student[_fname][_lname];
    //     marks[_address][sub_code]=_marks; 
    //     isPass = checkPass(_marks);
    // }

    // function getMarks(string memory _fname,string memory _lname,subjects sub_code) public view onlystudent(_fname,_lname) returns(uint256)  {
    //     return marks[msg.sender][sub_code];
    // }
}
