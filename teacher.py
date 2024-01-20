import streamlit as st
import time
import app
import teacher_functions




def teacher_page(contract):
    st.write("**Welcome to the Teacher page.**")

   
    user_address = st.text_input("Enter Ethereum Address:")
   
    login_button = st.button("Login")

    if login_button:
        
        login_successful = authenticate_teacher(user_address, contract)
        if login_successful:
            st.write("Login Successfull")
            return user_address
            
def authenticate_teacher(user_address,contract):
    try:
        contract.functions.GetStaffId().call({'from': user_address})
        return True
    except:
        return False

 
