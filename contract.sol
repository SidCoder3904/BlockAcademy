// SPDX-License-Identifier: MIT 
pragma solidity >0.7.0 <=0.8.23;

contract School {
    // ************* custom structures to store students/staff info ****************

    struct CourseData {
        uint32 course_id;
        uint32 current_strength;
        uint32 max_strength;
        uint32 staff_id;
        string description;
    }
    
    struct grade {
        uint8 class;    // class like 1,2,...,12 or sem like 1,2,...,8
        mapping(uint32 => uint256)  courses;
        uint256 n_courses;
    }

    struct Student {
        address acct;   // maybe we can remove it
        string _name;
        uint32 stud_id;     // students will have their unique identity
        uint8 n_grades;
       mapping(uint8 => uint32[]) grade;  //grade(like 1,2,3...) to course_codes in each grade(like 1,2,3...)
        mapping (uint32 => uint256) marks; //course_code to marks 
    }

    struct program {
        uint32 course_code;
        uint16 max_strength;
        uint16 current_strength;
        // we can add constraints like eligibility criterian etc...
    }

    struct Staff {
        address acct;   // maybe we can remove it
        string _name;
        uint32 staff_id;    // staff will have unique id
        uint8 n_programs;
        string[] courses;
        program[] programs_offered;  // offered by this prof
        // can add more personal info like contact, degree etc...
    }

    uint32 internal school_strength = 999;   // to get only 4 digit ids
    uint32 internal staff_strength = 999;    // to get only 4 digit ids
    string public school_name;
    address internal admin;      // can validate and unenroll students/staff in case situation arises but enrollment is decentralized by student themselves
    uint32 course_counter=0; 

    mapping(uint32 => Student) internal all_students;   // stud_id -> student info
    mapping(address => uint32) internal student_map;    // acct adrs -> stud_id
    mapping(uint32 => Staff) internal all_staff;     // staff_id -> staff info
    mapping(address => uint32) internal staff_map;      // acct adrs -> staff_id
    mapping(string => CourseData) internal course_data;    // maps string course code to number, can be edited only by admin

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
        require(_staff_id <= staff_strength && _staff_id > 999);
        _;
    }

    modifier validStudId(uint32 _stud_id) {
        require(_stud_id <= school_strength && _stud_id > 999);
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

    function GetSchoolStrength() public view returns(uint32) {
        return school_strength-999;
    }

    function GetStaffStrength() public view returns(uint32) {
        return staff_strength-999;
    }
    
    function RegisterStudent(string memory _name) public notStudent notStaff returns(uint32) {   // staff also cannot register as student for now
        uint32 stud_id = ++school_strength;
        student_map[msg.sender] = stud_id;
        all_students[stud_id].acct = msg.sender;
        all_students[stud_id]._name = _name;
        all_students[stud_id].stud_id = stud_id;
        all_students[stud_id].n_grades = 1;
        
        return stud_id;
        // add time lock so that someone else might not be able to edit the blockchain at same time
    }

    function GetStudentDetails(uint32 _stud_id) public view validStudId(_stud_id) onlyStudent(_stud_id) returns(string memory) {
        return (all_students[_stud_id]._name);
    }

    function RegisterStaff(string memory _name) public notStudent notStaff returns(uint32) {   // staff also cannot register as student for now
        uint32 staff_id = ++staff_strength;
        staff_map[msg.sender] = staff_id;
        all_staff[staff_id].acct = msg.sender;
        all_staff[staff_id]._name = _name;
        all_staff[staff_id].staff_id = staff_id;
        program memory initial_prog;
        all_staff[staff_id].programs_offered.push(initial_prog);
        all_staff[staff_id].n_programs = 1;     // bcoz we have added 
        return staff_id;
        // add time lock so that someone else might not be able to edit the blockchain at same time
    }

    function GetStaffDetails(uint32 _staff_id) public view validStaffId(_staff_id) onlyStaff(_staff_id) returns(string memory) {
        return (all_staff[_staff_id]._name);
    }
    
    function offer_course(string memory _course,uint32 _staff_id,uint32 max_strength, string memory desc ) public  validStaffId(_staff_id) onlyStaff(_staff_id) {
        all_staff[_staff_id].n_programs=all_staff[_staff_id].n_programs+1;

        course_data[_course].course_id =course_counter++;  //maybe course code could be suggested by prof. themselves
        course_data[_course].max_strength = max_strength;
        course_data[_course].staff_id = _staff_id;
        course_data[_course].description = desc;
        // all_staff[_staff_id].programs_offered.push(program({course_code: course_data[_course], max_strength: max_strength, current_strength:0}));
        
    }
    
    function enroll_course(string memory _course,uint32 stud_id) public validStudId(stud_id) onlyStudent(stud_id) {
        //require(course_data[_course].course_id > 100,"No such course available.");
        require(course_data[_course].current_strength < course_data[_course].max_strength, "No more students are being accepted in this course.");
        course_data[_course].current_strength++;
    }
    function edit_stud_details(uint32 stud_id,string memory new_name, uint8 new_grade ) public  validStudId(stud_id) onlyStudent(stud_id){
      all_students[stud_id]._name=new_name;
      all_students[stud_id].n_grades = new_grade;
    }
    function edit_prof_details(uint32 prof_id,string memory new_name ) public  validStaffId(prof_id) onlyStaff(prof_id){
      all_staff[prof_id]._name=new_name;
    }
     
    
   
    function updateGrade(uint32 _stud_id) internal view returns(bool) {
        uint8 current_grade = all_students[_stud_id].n_grades-1;
        uint256 n_courses = all_students[_stud_id].grade[current_grade].length;
        bool isPass = true;
        for(uint256 i=0; i<n_courses; i++) if(all_students[_stud_id].grade[current_grade][i]<33) isPass = false;
        return isPass;
    }
    
    function getGrade(uint32 _stud_id) public onlyStudent(_stud_id) returns(uint8) {
        if(updateGrade(_stud_id)) all_students[_stud_id].n_grades++;
        return all_students[_stud_id].n_grades;
    }

    // function checkPass(uint256 _marks) public pure returns(bool) {
    //     if(_marks < 33) return false;
    //     return true;
    // }
    function setMarks(uint32 prof_id,string memory _course,uint32 stud_id, uint256 _marks) public validStaffId(prof_id) onlyStaff(prof_id) {
        uint32 course_code = course_data[_course].course_id;
        all_students[stud_id].marks[course_code]=_marks;
     }

    function getMarks(uint32 stud_id,string memory _course) public view validStudId(stud_id) onlyStudent(stud_id) returns(uint256 _marks)  {
        uint32 course_code=course_data[_course].course_id;
        _marks=all_students[stud_id].marks[course_code];
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
