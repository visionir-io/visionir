import streamlit as st
from apps.paychecks.src.logger import Logger


@st.cache_resource()
def get_logger():
    return Logger().init_logger("paychecks")


def main():
    logger = get_logger()
    logger.debug("Application started")
    with st.form(key="paycheck calculation"):
        st.write("Welcome to the paycheck calculator")
        st.write("Enter your details below")
        check_amount = st.number_input("Enter the check amount", min_value=0)
        interest_paid = st.number_input("Enter the interest paid", min_value=0)
        days_to_pay = st.number_input(
            "Enter the days to collect the money", min_value=0
        )
        if st.form_submit_button("Calculate"):
            logger.info(
                f"params received: {check_amount=}, {interest_paid=}, {days_to_pay=}"
            )
            daily_interest_rate = interest_paid / days_to_pay
            monthly_value = daily_interest_rate * 30
            check_intetest = (monthly_value / check_amount) * 100
            st.write(f"monthly value interest rate: {check_intetest:.2f}%")
            logger.debug(f"monthly value interest rate: {check_intetest:.2f}%")


if __name__ == "__main__":
    main()
