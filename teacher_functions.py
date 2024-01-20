import streamlit as st

def offer_course(contract,user_address,_course,_staff_id,max_strength,desc):
    try:
        contract.functions.offer_course(_course, _staff_id,max_strength,desc).transact({'from': user_address})
        st.write("Course Registraion successfull.")
    except:
       st.write("ERROR !")

def set_marks(contract,user_address,_course,prof_id,stud_id,_marks):
    try:
        
        
        contract.functions.setMarks(prof_id,_course,stud_id,_marks).transact({'from': user_address})
        st.write("Marks updated")
    except:
        st.write("Error! PLease ensure that all the details are correct.")

def update_details(contract,user_address,prof_id,new_name):
    try:
        
       
        contract.functions.edit_prof_details(prof_id,new_name ).transact({'from': user_address})
        st.write("Updated successfully")
    except:
        st.write("Error! Please ensure that ID number is correct")

def teacher_functions(contract,user_address):
      
             
            if st.button("Get Id"):
                Id=contract.functions.GetStaffId().call({'from': str(user_address)})  
                st.write(Id)
            
            st.title("Offer a Course")
            _course=st.text_input("Course:")
            prof_id=st.number_input("Professor ID:",step=1,format="%d")
            max_strength=st.number_input("Maximum Strength:",step=1,format="%d")
            desc=st.text_input("Course Descripltion:")
            if st.button(" Offer "):
                offer_course(contract,user_address,_course,prof_id,max_strength,desc)
                
            st.title("Set Marks")
            _course1=st.text_input("Course :")
            prof_id1=st.number_input("Professor ID :",step=1,format="%d")
            stud_id1=st.number_input("Student ID :",step=1,format="%d")
            _marks1=st.number_input("Marks:")
            if st.button(" Set "):
                set_marks(contract,user_address,_course1,prof_id1,stud_id1,_marks1)

            st.title("Update details")
            prof_id2=st.number_input(" Professor ID:",step=1,format="%d")
            new_name2=st.text_input("Updated name:")
            if st.button(" Update "):
                update_details(contract,user_address,prof_id2,new_name2)
