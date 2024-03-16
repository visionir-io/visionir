import streamlit as st

with st.form(key="paycheck calculation"):
    st.write("Welcome to the paycheck calculator")
    st.write("Enter your details below")
    total_money = st.number_input("Enter your total money", min_value=0.0)
    interest_paid = st.number_input("Enter the interest paid", min_value=0.0)
    if st.form_submit_button("Calculate"):
        st.write(f"Your interest rate is: {interest_paid / total_money * 100:.2f}%")
