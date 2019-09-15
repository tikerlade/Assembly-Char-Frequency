# Computer-Architecture-Course-Work
<i>Coursework for "Computer Architecture" course at Saint-Petersburg Polytechnic University of Peter the Great</i>
<br>
<br>

**Problem**<br>
Create a program for constructing a diagram of the repeatability of letters in the text. The format is arbitrary.
<br>
<br>

**Solution**\
<i>Programs are written in “GUI Turbo Assembler x64 Version 3.0.1”</i><br>
![github-medium](https://github.com/tikerlade/Computer-Architecture-Course-Work/blob/master/Screenshot.PNG)

The first line displays a welcome message to the user with a proposal to enter the number of lines to be entered (maximum number of lines = 6). After the user has entered the number of lines, the algorithm will read character-by-character lines with a size of no more than 80 characters. When you enter the next character, if the character is a Latin letter, then in the array the counter value for this character will increase by one. It will also be established whether the symbol is uppercase or lowercase, and the corresponding counter will be increased depending on this. However, if the entered character turns out to be a symbol for switching to a new line, the algorithm will finish reading on this line and switch to a new one.
