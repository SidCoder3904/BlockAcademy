# app.py
import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

def main():
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

    # Add a sidebar for user selection with title
    st.sidebar.title("Navigation")

    icon_options = {
        "Home 🏠": "Home",
        "Admin 👤": "Admin",
        "Teacher 📚": "Teacher",
        "Student 🎓": "Student",
    }

    selected_user_type = st.sidebar.selectbox("Select User Type", list(icon_options.keys()))

    # Display content based on user selection
    if selected_user_type == "Home 🏠":
        show_home_page()
    elif selected_user_type == "Admin 👤":
        show_admin_page()
    elif selected_user_type == "Teacher 📚":
        show_teacher_page()
    elif selected_user_type == "Student 🎓":
        show_student_page()

    # Contact information under the sidebar
    st.sidebar.markdown("---")
    st.sidebar.subheader("Contact")
    st.sidebar.write("- Email: [Siddharth Verma](siddharthverma3904@gmail.com)")
    st.sidebar.write("- GitHub: [GitHub Repo](https://github.com/Sid-3904/Acad_Management_System)")

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
            <p>&copy; 2023 Academic Management System. All rights reserved.</p>
        </div>
        """,
        unsafe_allow_html=True
    )

def show_home_page():
    st.markdown("**Welcome to the Academic Management System home page.**")
    # Add content specific to the home page

def show_admin_page():
    st.write("**Welcome to the Admin page.**")

    # Login Form for Admin
    user_address = st.text_input("Enter Ethereum Address:")
    password = st.text_input("Enter Password:", type="password")
    login_button = st.button("Login")

    if login_button:
        # You can integrate your authentication logic here
        login_successful = authenticate_admin(user_address, password)

        # Display login status
        if login_successful:
            st.success("Login successful!")
            show_admin_dashboard()

        else:
            st.error("Login failed. Please check your credentials.")

def show_teacher_page():
    st.write("**Welcome to the Teacher page.**")

    # Login Form for Teacher
    user_address = st.text_input("Enter Ethereum Address:")
    password = st.text_input("Enter Password:", type="password")
    login_button = st.button("Login")

    if login_button:
        # You can integrate your authentication logic here
        login_successful = authenticate_teacher(user_address, password)

        # Display login status
        if login_successful:
            st.success("Login successful!")
            show_teacher_dashboard()
        else:
            st.error("Login failed. Please check your credentials.")

def show_student_page():
    st.write("**Welcome to the Student page.**")

    # Login Form for Student
    user_address = st.text_input("Enter Ethereum Address:")
    password = st.text_input("Enter Password:", type="password")
    login_button = st.button("Login")

    if login_button:
        # You can integrate your authentication logic here
        login_successful = authenticate_student(user_address, password)

        # Display login status
        if login_successful:
            st.success("Login successful!")
            show_student_dashboard()
        else:
            st.error("Login failed. Please check your credentials.")

# Placeholder functions for authentication logic
def authenticate_admin(user_address, password):
    # Implement your logic to authenticate the admin
    # This could involve checking a database, validating against a smart contract, etc.
    # For now, just return True for demonstration purposes
    return True

def authenticate_teacher(user_address, password):
    # Implement your logic to authenticate the teacher
    # This could involve checking a database, validating against a smart contract, etc.
    # For now, just return True for demonstration purposes
    return True

def authenticate_student(user_address, password):
    # Implement your logic to authenticate the student
    # This could involve checking a database, validating against a smart contract, etc.
    # For now, just return True for demonstration purposes
    return True

def show_admin_dashboard():
    st.subheader("Admin Dashboard")

    # Add Ethereum Address Form
    st.subheader("Add Ethereum Address")
    user_type_add = st.radio("Select User Type ", ["Teacher", "Student"], key="add")
    new_address_add = st.text_input(f"Enter New Ethereum Address for {user_type_add}")
    new_address_password = st.text_input(f"Enter Default Ethereum Password for {user_type_add}")

    add_button = st.button(f"Add {user_type_add} Address")

    if add_button:
        # Implement logic to add the Ethereum address to the smart contract
        st.success(f"Successfully added {user_type_add.lower()} address: {new_address_add}")

    # Remove Ethereum Address Form
    st.subheader("Remove Ethereum Address")
    user_type_remove = st.radio("Select User Type ", ["Teacher", "Student"], key="remove")
    address_to_remove = st.text_input(f"Enter Ethereum Address to Remove for {user_type_remove}")
    
    remove_button = st.button(f"Remove {user_type_remove} Address")

    if remove_button:
        # Implement logic to remove the Ethereum address from the smart contract
        st.success(f"Successfully removed {user_type_remove.lower()} address: {address_to_remove}")

def show_teacher_dashboard():
    st.subheader("Teacher Dashboard")

    # Subject selection
    selected_subject = st.selectbox("Select Subject", ["Math", "Science", "History", "English"])

    # Student selection
    selected_student = st.text_input("Enter Student Ethereum Address")

    # Marks input
    marks = st.number_input("Enter Marks", min_value=0, max_value=100)

    # Set Marks button
    set_marks_button = st.button("Set Marks")

    if set_marks_button:
        # Implement logic to set marks for the selected student in the selected subject
        st.success(f"Successfully set {selected_subject} marks ({marks}) for student: {selected_student}")

def show_student_dashboard():
    st.subheader("Student Dashboard")

    # Subject selection
    selected_subject = st.selectbox("Select Subject", ["Math", "Science", "History", "English"])

    # Display marks for the selected subject and student
    # In a real application, you would fetch the marks from a database or another data source
    student_marks = fetch_student_marks(selected_subject)

    if student_marks is not None:
        st.success(f"Your marks in {selected_subject}: {student_marks}")
    else:
        st.warning("Marks not available for the selected subject.")

    # Data Analytics Section
    st.subheader("Data Analytics")

    # Example: Display a bar chart of average marks in different subjects using Matplotlib
    df = generate_example_data()
    plot_bar_chart(df)

def fetch_student_marks(subject):
    # Implement logic to fetch the student's marks from a database or another data source
    # For demonstration purposes, return None
    return None

def generate_example_data():
    # Example data for analytics
    data = {
        "Subject": ["Math", "Science", "History", "English"],
        "Average Marks": [75, 80, 65, 90]
    }
    df = pd.DataFrame(data)
    return df

def plot_bar_chart(df):
    plt.figure(figsize=(8, 6))
    plt.bar(df["Subject"], df["Average Marks"], color='skyblue')
    plt.title('Average Marks in Different Subjects')
    plt.xlabel('Subject')
    plt.ylabel('Average Marks')
    st.pyplot(plt)

if __name__ == "__main__":
    main()
