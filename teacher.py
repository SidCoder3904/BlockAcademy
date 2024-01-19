import streamlit as st
import time
import app

def teacher_page(contract):
    st.write("**Welcome to the Teacher page.**")

    # Login Form for Teacher
    user_address = st.text_input("Enter Ethereum Address:")
    # password = st.text_input("Enter Password:", type="password")
    login_button = st.button("Login")

    if login_button:
        # You can integrate your authentication logic here
        login_successful = authenticate_teacher(user_address, contract)

        # Display login status
        if login_successful:
            st.success("Login successful!")
        else:
            st.error("Login failed. Please check your credentials or Register")
            time.sleep(2)
            app.site = 'Register'

def authenticate_teacher(user_address, contract):
    # Implement your logic to authenticate the teacher
    try :
        staffID = contract.functions.GetStaffId().call({'from': str(user_address)})
        print(staffID)
        return True
    except :
        return False