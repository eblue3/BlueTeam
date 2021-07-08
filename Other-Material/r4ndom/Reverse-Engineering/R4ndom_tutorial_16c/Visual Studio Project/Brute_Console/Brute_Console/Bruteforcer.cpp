#include <iostream>
using namespace std;

void brute( void )
{
    char finalAsciiSerial[11] = "";
    int    i, varA, varB, varC, tempVar, currentSerial[10];

    // we know the first number is '7'
    for (currentSerial[0] = 7; currentSerial[0] <= 7; currentSerial[0]++)
    {
     // and we know the second number is '9'
     for (currentSerial[1] = 9; currentSerial[1] <= 9; currentSerial[1]++)
     {
      for (currentSerial[2] = 1; currentSerial[2] <= 15; currentSerial[2]++)
      {
       for (currentSerial[3] = 1; currentSerial[3] <= 15; currentSerial[3]++)
       {
        for (currentSerial[4] = 1; currentSerial[4] <= 15; currentSerial[4]++)
        {
         cout << ".";    // Update display
         for (currentSerial[5] = 1; currentSerial[5] <= 15; currentSerial[5]++)
         {
          for (currentSerial[6] = 1; currentSerial[6] <= 15; currentSerial[6]++)
          {
           for (currentSerial[7] = 1; currentSerial[7] <= 15; currentSerial[7]++)
           {
            for (currentSerial[8] = 1; currentSerial[8] <= 15; currentSerial[8]++)
            {
             for (currentSerial[9] = 1; currentSerial[9] <= 15; currentSerial[9]++)
             {
                // Reset variables
                varA = 0xDEAD;
                varB = 0xDEAD;
                varC = 0x42424242;

                // Apply each digit
                for (i = 0; i < 10; i++)
                {
                    switch (currentSerial[i])
                    {
                    case 1:
                        varC += 0x54B;
                        varB *= varA;
                        varA ^= varC;
                        break;

                    case 2:
                        varC = varC - 0x233 + varA;
                        varB = (varB * 0x14) & varA;
                        break;

                    case 3:
                        varA += 0x582;
                        varC *= 0x16;
                        varB ^= varA;
                        break;

                    case 4:
                        varA &= varB;
                        varB -= 0x111222;
                        varC ^= varA;
                        break;

                    case 5:
                        if (varC != 0)        // Watch divide by zero!
                        {
                            varB -= (varA % varC);
                            varA /= varC;
                            varA += varC;
                        }
                        break;

                    case 6:
                        varA ^= varC;
                        varB &= varA;
                        varC += 0x546879;
                        break;

                    case 7:
                        varC -= 0x25FF5;
                        varB ^= varC;
                        varA += 0x401000;
                        break;

                    case 8:
                        varA ^= varC;
                        varB *= 0x14;
                        varC += 0x12589;
                        break;

                    case 9:
                        varA -= 0x542187;
                        varB -= varA;
                        varC ^= varA;
                        break;

                    case 10:
                        if (varB != 0)        // Watch divide by zero!
                        {
                            tempVar = varA % varB;
                            varA /= varB;
                            varB += tempVar;
                            varA *= tempVar;
                            varC ^= tempVar;
                        }
                        break;

                    case 11:
                        varB += 0x1234FE;
                        varC += 0x2345DE;
                        varA += 0x9CA4439B;
                        break;

                    case 12:
                        varA ^= varB;
                        varB -= varC;
                        varC *= 0x12;
                        break;

                    case 13:
                        varA &= 0x12345678;
                        varC -= 0x65875;
                        varB *= varC;
                        break;

                    case 14:
                        varA ^= 0x55555;
                        varB -= 0x587351;
                        break;

                    case 15:
                        varA += varB;
                        varB += varC;
                        varC += varA;
                        break;
                    }
                }

                // stop if serial equals proper values
                if ((varA == 0x9CC5B4B9) && (varB == 0xD1EB13FB) && (varC == 0x837D424E))
                {
                    // Convert to ASCII
                    for (i = 0; i < 10; i++)
                    {
                        if (currentSerial[i] <= 9)
                        {
                            finalAsciiSerial[i] = currentSerial[i] + 0x30;
                        }
                        else
                        {
                            finalAsciiSerial[i] = currentSerial[i] + 0x37;
                        }
                    }
                    cout << "\n\n*****  Bruteforced serial: " << finalAsciiSerial << "\n";\
                    return;
    }}}}}}}}}}}
}

int main()
{
    cout << "Bruteforcer by R4ndom\n\n";

    brute();

    cout << "\nBruteforcing done...\n";

    return 0;
}