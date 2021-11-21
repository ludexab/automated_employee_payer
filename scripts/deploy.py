from brownie import EmployeePayer, accounts
from web3 import Web3


def deploy_employee_payer():
    account = accounts[0]
    account2 = accounts[1]

    print("[i]>> Deploying contract...")
    employeePayer = EmployeePayer.deploy({"from": account, "value":Web3.toWei(50, "ether")})
    print(f"[i]>> Contract deployed... at {employeePayer.address}")

    setEmp = employeePayer.setEmployeeWage(account2, 230000000, {"from": account})
    setEmp.wait(1)

    checkEmp = employeePayer.checkEmployee(0)
    print(checkEmp)

    checkEmpBal = employeePayer.checkEmployeeBalance(account2)
    print(f"Employee balance is {checkEmpBal}")

    checkEmpSal = employeePayer.checkEmployeeSalary(account2)
    print(f"Employee salary is {checkEmpSal}")

    print("[i]>> Initiating payout...")
    payout = employeePayer.ensurePayday({"from": account})
    payout.wait(1)
    print("[i]>> All employee have been paid!")

    checkEmpBal1 = employeePayer.checkEmployeeBalance(account2)
    print(f"Employee balance is {checkEmpBal1}")


def main():
    deploy_employee_payer()
