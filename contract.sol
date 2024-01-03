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
        all_stuents[stud_id].grades[0].n_courses=0;
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
    function edit_stud_details(uint32 stud_id,string memory new_fname, string memory new_lname, uint8 new_grade ) public  validStudId(stud_id) onlyStudent(stud_id){
      all_students[stud_id].first_name=new_fname;
      all_students[stud_id].last_name=new_lname;
      all_students[stud_id].n_grades = new_grade;
    }
    function edit_prof_details(uint32 prof_id,string memory new_fname, string memory new_lname ) public  validStaffId(prof_id) onlyStaff(prof_id){
      all_staff[prof_id].first_name=new_fname;
      all_staff[prof_id].last_name=new_lname;
    }
     
     
    function get_staff_details(uint32 prof_id) public view validStaffId(prof_id) returns(string memory f_name,string memory l_name) {
     f_name=all_staff[prof_id].first_name;
     l_name=all_staff[prof_id].last_name;
    }
    function get_student_details(uint32 stud_id,uint32 prof_id) public view validStudId(stud_id) returns(string memory f_name,string memory l_name) {
     if(msg.sender == all_staff[prof_id].acct){
     f_name=all_students[stud_id].first_name;
     l_name=all_students[stud_id].last_name;
     uint8 _grade=all_students[stud_id].n_grades;
     uint8 i;
     for(i=0;i<(all_students[stud_id].grades[_grade].n_courses);i++){
         return all_students[stud_id].grades[_grade].course[i].
     }
     }
     require(msg.sender == all_staff[prof_id].acct);
    }

    // function checkPass(uint256 _marks) public pure returns(bool) {
    //     if(_marks < 33) return false;
    //     return true;
    // }
 
    function get_staff_details(uint32 prof_id) public view validStaffId(prof_id) returns(string memory f_name,string memory l_name) {
     f_name=all_staff[prof_id].first_name;
     l_name=all_staff[prof_id].last_name;
    }
    function get_student_details(uint32 stud_id,uint32 prof_id) public view validStudId(stud_id) returns(string memory f_name,string memory l_name) {
     if(msg.sender == all_staff[prof_id].acct){
     f_name=all_students[stud_id].first_name;
     l_name=all_students[stud_id].last_name;
     uint8 _grade=all_students[stud_id].n_grades;
     uint8 i;
     for(i=0;i<(all_students[stud_id].grades[_grade].n_courses);i++){
         return all_students[stud_id].grades[_grade].course[i].
     }
     }
     require(msg.sender == all_staff[prof_id].acct);
    }

    // function checkPass(uint256 _marks) public pure returns(bool) {
    //     if(_marks < 33) return false;
    //     return true;
    // }
     function setMarks(uint32 prof_id,string memory _course,uint32 stud_id, uint256 _marks) public validStaffId(prof_id) onlyStaff(prof_id) {
        uint32 course_code=course_codes[_course];
        uint i=0;
        uint8 _grade=all_students[stud_id].n_grades;
         while(all_students[stud_id].grades[_grade].courses[i].course_code!=course_code){
            require(i<(all_students[stud_id].grades[_grade].courses).length,"The student is not enrolled in this course.");
           i++;
        }
        all_students[stud_id].grades[_grade].courses[i].marks=_marks;
     }

    function getMarks(uint32 stud_id,string memory _course) public view validStudId(stud_id) onlyStudent(stud_id) returns(uint256 _marks)  {
        uint32 course_code=course_codes[_course];
        uint i=0;
        uint8 _grade=all_students[stud_id].n_grades;
         while(all_students[stud_id].grades[_grade].courses[i].course_code!=course_code){
            require(i<(all_students[stud_id].grades[_grade].courses).length,"You are not enrolled in this course.");
           i++;
        }
        _marks=all_students[stud_id].grades[_grade].courses[i].marks;
     }

    function RemoveStudent(uint32 stud_id) internal {
        address stud_acct = all_students[stud_id].acct;
        delete student_map[stud_acct];
        delete all_students[stud_id];
    }
    
    function RemoveStaff(uint32 staff_id) internal {
        address staff_acct = all_staff[staff_id].acct;
        delete staff_map[staff_acct];
        delete all_staff[staff_id];
    }

    function Remove(bool is_stud, uint32 id) public onlyAdmin {
        if(is_stud) RemoveStudent(id);
        else RemoveStaff(id);
    }
}
