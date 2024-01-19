import streamlit as st

def transaction(address) :
    return {
    'from': address,
    'gasPrice': w3.to_wei('50', 'gwei'),
    'nonce': w3.eth.get_transaction_count(address)}

def register_page(contract):
    st.write("**Welcome to our portal. Register to join us!**")

    # Login Form for Student
    user_name = st.text_input("Enter Name:")
    user_address = st.text_input("Enter Ethereum Address:")
    # password = st.text_input("Enter Password:", type="password")
    register_button = st.button("Register")

    if register_button:
        # You can integrate your authentication logic here
        register_successful = register_student(user_name, user_address, contract)

        # Display login status
        if register_successful:
            st.success("Registered successfully!")

        else:
            st.error("Register failed. Please check if you already enrolled.")
            
def register_student(user_name, user_address, contract):
    # Implement your logic to authenticate the student
    try :
        contract.functions.RegisterStudent(user_name).transact(transaction(user_address))
        return True
    except :
        return False