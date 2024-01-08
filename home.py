import streamlit as st

def home_page():
    st.markdown("**Welcome to the Academic Management System home page.**")
    st.markdown("**Made possible with:**")

    # Ethereum Logo
    ethereum_logo = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Ethereum_logo_2014.svg/256px-Ethereum_logo_2014.svg.png"

    # Solidity Logo
    solidity_logo = "https://cdn.icon-icons.com/icons2/2107/PNG/512/file_type_solidity_icon_130156.png"

    # Python Logo
    python_logo = "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Python-logo-notext.svg/1869px-Python-logo-notext.svg.png"

    # Streamlit Logo
    streamlit_logo = "https://streamlit.io/images/brand/streamlit-mark-color.png"

    # Display logos side by side
    logos_col = st.columns(4)  # You can adjust the number of columns based on your preference

    logo_sizes = [75, 120, 110, 200]  # Adjust the sizes as needed
    captions=['Ethereum', 'Solidity', 'Python', 'Streamlit']

    for col, logo, size, cap in zip(logos_col, [ethereum_logo, solidity_logo, python_logo, streamlit_logo], logo_sizes, captions):
        col.image(logo, caption=cap, width=size)