import streamlit as st
from streamlit_option_menu import option_menu
import home, admin, teacher, student

login_successful=False

def main():
    global login_successful
    st.set_page_config(page_title="AMS", page_icon=":books:", layout="wide")

    # Header with Title and Logo
    st.markdown(
        f"""
        <div style='display: flex; align-items: center; padding: 0; background-color: {st.get_option("theme.backgroundColor")};'>
            <h1 style='flex: 1; margin: 0;'>Academic Management System</h1>
            <img src='https://www.codester.com/static/uploads/items/000/008/8870/icon.png' width='100' alt='AMS Logo'>
        </div>
        """,
        unsafe_allow_html=True
    )

    with st.sidebar:
        app = option_menu(
                    menu_title='Navigation',
                    options=['Home','Admin','Teacher','Student'],
                    icons=['house-fill','person-circle','book','mortarboard'],
                    menu_icon='arrow-up-right-square-fill',
                    default_index=1,
                    styles={
                        "container": {"padding": "5!important","background-color":'black'},
            "icon": {"color": "white", "font-size": "20px"}, 
            "nav-link": {"color":"white","font-size": "15px", "text-align": "left", "margin":"0px", "--hover-color": "blue"},
            "nav-link-selected": {"background-color": "#02ab21"},}
                    
                    )
    if app == "Home":
        home.home_page()
    if app == "Admin":
        admin.admin_page()
    if app == "Teacher":
        teacher.teacher_page()       
    if app == 'Student':
        student.student_page()

    # Contact information under the sidebar
    whatsapp_logo_url = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/640px-WhatsApp.svg.png"
    github_logo_url = "https://cdn-icons-png.flaticon.com/512/25/25231.png"
    email_logo_url = "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Gmail_icon_%282020%29.svg/640px-Gmail_icon_%282020%29.svg.png"
    st.sidebar.markdown("---")
    st.sidebar.subheader("Contact")
    st.sidebar.markdown(f"- <img src='{whatsapp_logo_url}' width='25' height='25' /> &nbsp;[WhatsApp Number](https://wa.me/1234567890)", unsafe_allow_html=True)
    st.sidebar.markdown(f"- <img src='{github_logo_url}' width='27' height='27' /> [GitHub Repository](https://github.com/Sid-3904/Acad_Management_System)", unsafe_allow_html=True)
    st.sidebar.markdown(f"- <img src='{email_logo_url}' width='25' height='20' /> &nbsp;[E-Mail Address](mailto:siddharthverma3904@gmail.com)", unsafe_allow_html=True)

    # Home Page Footer with CSS modifications
    st.markdown(
        f"""
        <style>
        .footer {{
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            width: 100%;
            text-align: center;
            padding: 20px;
            background-color: {st.get_option("theme.backgroundColor")};
            color: #FFFFFF;
        }}
        </style>
        <div class="footer">
            <p>&copy; 2024 Academic Management System. All rights reserved.</p>
        </div>
        """,
        unsafe_allow_html=True
    )

if __name__ == "__main__":
    main()
