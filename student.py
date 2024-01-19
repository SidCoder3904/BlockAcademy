import streamlit as st
import time
import app

def student_page(contract):
    st.write("**Welcome to the Student page.**")

    # Login Form for Student
    # user_name = st.text_input("Enter Name:")
    user_address = st.text_input("Enter Ethereum Address:")
    # password = st.text_input("Enter Password:", type="password")
    login_button = st.button("Login")

    if login_button:
        # You can integrate your authentication logic here
        login_successful = authenticate_student(user_address, contract)

        # Display login status
        if login_successful:
            st.success("Login successful!")
        else:
            st.error("Login failed. Please check your credentials.")
            time.sleep(2)
            app.site = 'Register'  # Update the app variable to "Register"

def authenticate_student(user_address, contract):
    try :
        studID = contract.functions.GetStudentId().call({'from': str(user_address)})
        print(studID)
        return True
    except :
        return False