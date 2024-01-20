import streamlit as st
from web3 import Web3



def staff_functions_page(contract):

    st.title('Register as Staff:')
    _name = st.text_input("Enter Name:")
    staff_address=st.text_input("Enter Ethereum Address:")
    #st.write(_name)
     
    if st.button("Register"):
        try:
           contract.functions.RegisterStaff(_name).transact({'from':staff_address})
           st.success("Registered successfully.")
        except Exception as e:
            st.error(f"An error occurred during registration: {e}")

    st.title('Get Staff Id:')
    
    
