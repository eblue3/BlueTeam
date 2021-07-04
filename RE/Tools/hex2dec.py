#!/usr/bin/env python3
from colorama import Fore, Style
print("""
= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
=       Blue3 - Simple Hexadecimal to Decimal Converter     =
= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
Press Enter to exit
Correct Hex input: 0x001122..eeff or 001122...eeff""")
while True:
    myinp = input("---\nInput your Hex: ")
    if myinp:
        myinp = myinp.replace("0x","",1)
        myinp = myinp.replace("h","",1)
        try:
            res = int(myinp, 16)
        except(ValueError):
            print(Style.BRIGHT+Fore.RED+"Wrong Hex Input!"+Style.RESET_ALL)
            print("Correct input: "+Style.BRIGHT+Fore.GREEN+"0x001122..7e7f"+Style.RESET_ALL+" or "+Style.BRIGHT+Fore.GREEN+"001122...7e7f"+Style.RESET_ALL+" or "+Style.BRIGHT+Fore.GREEN+"001122...7e7f\"h\""+Style.RESET_ALL)
        else:
            print("Input Hex  : "+Style.BRIGHT+Fore.YELLOW+myinp+Style.RESET_ALL)
            print("Decimal    : "+Style.BRIGHT+Fore.GREEN+str(res)+Style.RESET_ALL)
    else:
        print("No Input. Exiting.")
        break
