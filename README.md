                                   MATLAB PARSER USING FLES AND BISON

A MATLAB parser is designed using the Flex and Bison tools.
matlab.l file accepts a simple MATLAB code and generates valid tokens. These tokens are then verified
against the grammar rules defined in matlab.y to find if there exists any syntax error in the MATLAB code.
