import streamlit as st
from streamlit_option_menu import option_menu
import home, admin, teacher, student, register_staff,register, teacher_functions, time
from web3 import Web3

login_successful=False

ganache_url = "HTTP://127.0.0.1:7545"  # Replace with your Ganache URL
web3 = Web3(Web3.HTTPProvider(ganache_url))

    # Replace with your deployed contract address and ABI
contract_address = "0x53A77A33fC05B3f5c667FD7bEDA2A48634f3E2C3"  # Replace with your contract's address
contract_abi =  [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_school_name",
				"type": "string"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": False,
		"inputs": [
			{
				"indexed": False,
				"internalType": "string",
				"name": "course_name",
				"type": "string"
			},
			{
				"indexed": False,
				"internalType": "uint32",
				"name": "staff_id",
				"type": "uint32"
			},
			{
				"indexed": False,
				"internalType": "uint32",
				"name": "max_strength",
				"type": "uint32"
			},
			{
				"indexed": False,
				"internalType": "string",
				"name": "desc",
				"type": "string"
			}
		],
		"name": "CourseOffered",
		"type": "event"
	},
	{
		"anonymous": False,
		"inputs": [],
		"name": "GradeUpdated",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "GetSchoolStrength",
		"outputs": [
			{
				"internalType": "uint32",
				"name": "",
				"type": "uint32"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint32",
				"name": "_staff_id",
				"type": "uint32"
			}
		],
		"name": "GetStaffDetails",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "GetStaffId",
		"outputs": [
			{
				"internalType": "uint32",
				"name": "",
				"type": "uint32"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "GetStaffStrength",
		"outputs": [
			{
				"internalType": "uint32",
				"name": "",
				"type": "uint32"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint32",
				"name": "_stud_id",
				"type": "uint32"
			}
		],
		"name": "GetStudentDetails",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "GetStudentId",
		"outputs": [
			{
				"internalType": "uint32",
				"name": "",
				"type": "uint32"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			}
		],
		"name": "RegisterStaff",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			}
		],
		"name": "RegisterStudent",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bool",
				"name": "is_stud",
				"type": "bool"
			},
			{
				"internalType": "uint32",
				"name": "id",
				"type": "uint32"
			}
		],
		"name": "Remove",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint32",
				"name": "prof_id",
				"type": "uint32"
			},
			{
				"internalType": "string",
				"name": "new_name",
				"type": "string"
			}
		],
		"name": "edit_prof_details",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint32",
				"name": "stud_id",
				"type": "uint32"
			},
			{
				"internalType": "string",
				"name": "new_name",
				"type": "string"
			},
			{
				"internalType": "uint8",
				"name": "new_grade",
				"type": "uint8"
			}
		],
		"name": "edit_stud_details",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_course",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "stud_id",
				"type": "uint32"
			}
		],
		"name": "enroll_course",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint32",
				"name": "_stud_id",
				"type": "uint32"
			}
		],
		"name": "getGrade",
		"outputs": [
			{
				"internalType": "uint8",
				"name": "",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint32",
				"name": "stud_id",
				"type": "uint32"
			},
			{
				"internalType": "string",
				"name": "_course",
				"type": "string"
			}
		],
		"name": "getMarks",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_marks",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_course",
				"type": "string"
			}
		],
		"name": "get_course_details",
		"outputs": [
			{
				"internalType": "uint32",
				"name": "course_code",
				"type": "uint32"
			},
			{
				"internalType": "uint32",
				"name": "max_strength",
				"type": "uint32"
			},
			{
				"internalType": "uint32",
				"name": "current_strength",
				"type": "uint32"
			},
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "description",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_course",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "_staff_id",
				"type": "uint32"
			},
			{
				"internalType": "uint32",
				"name": "max_strength",
				"type": "uint32"
			},
			{
				"internalType": "string",
				"name": "desc",
				"type": "string"
			}
		],
		"name": "offer_course",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "school_name",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint32",
				"name": "prof_id",
				"type": "uint32"
			},
			{
				"internalType": "string",
				"name": "_course",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "stud_id",
				"type": "uint32"
			},
			{
				"internalType": "uint256",
				"name": "_marks",
				"type": "uint256"
			}
		],
		"name": "setMarks",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "updateGrade",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]

    # Instantiate the contract
contract = web3.eth.contract(address=contract_address, abi=contract_abi)

def main():

    global login_successful
    st.set_page_config(page_title="AMS", page_icon=":books:", layout="wide")

    # Header with Title and Logo
    st.markdown(
        f"""
        <div style='display: flex; align-items: center; padding: 0; background-color: {st.get_option("theme.backgroundColor")};'>
            <h1 style='flex: 1; margin: 0;'>BlockAcademy</h1>
            <img src='https://www.codester.com/static/uploads/items/000/008/8870/icon.png' width='100' alt='AMS Logo'>
        </div>
        """,
        unsafe_allow_html=True
    )

    with st.sidebar:
        app = option_menu(
                    menu_title='Navigation',
                    options=['Home','Admin','Teacher','Teacher Functions','Register Staff','Register Student','Student'],
                    icons=['house-fill','person-circle','book','book','wallet-outline','person-circle','mortarboard'],
                    menu_icon='arrow-up-right-square-fill',
                    default_index=1,
                    styles={
                        "container": {"padding": "5!important","background-color":'black'},
            "icon": {"color": "white", "font-size": "20px"}, 
            "nav-link": {"color":"white","font-size": "15px", "text-align": "left", "margin":"0px", "--hover-color": "blue"},
            "nav-link-selected": {"background-color": "#02ab21"},
            "nav-link-selected": {"background-color": "#02ab21"}}
                        )
   
    if 'login' not in st.session_state:
        st.session_state.login = False

    if 'staff_address' not in st.session_state:
        st.session_state.staff_address = False

    if app == "Home":
        home.home_page()
    elif app == "Admin":
        admin.admin_page()
    elif app == "Teacher":
        st.session_state.staff_address = teacher.teacher_page(contract)
        if st.session_state.staff_address: 
            st.session_state.login = True

    elif app == "Teacher Functions":
        if st.session_state.login:
            st.write("Logged in successfully")
            teacher_functions.teacher_functions(contract, st.session_state.staff_address)
        else:
            st.write("Please login first.")
    elif app == "Register Staff":
        register_staff.staff_functions_page(contract)
    elif app == "Register Student":
        register.register_page(contract)
    elif app == 'Student':
        student.student_page(contract)
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
            <p>&copy; 2024 BlockAcademy. All rights reserved.</p>
        </div>
        """,
        unsafe_allow_html=True
    )

if __name__ == "__main__":
    main()
