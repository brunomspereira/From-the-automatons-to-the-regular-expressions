# From the automatons to the regular expressions
Consider a deterministic automaton A. More formally, let Σ be an alphabet, Q a set of states, S a non-terminal and F a subset of Q of states (the set of final states) and Rδ a transition relation over Σ and Q. Thus we have A = (Q, Σ, i, F, Rδ).
## **Problem**
Write a program that reads A and that calculates the regular expression r resulting from the application of the MacNaughton-Yamada algorithm exposed in theoretical classes.  
It is expected to apply some rules to simplify the resulting regular expression. At the “skeleton” file of the resolution, you will find a “simplify” function that concretely performs the simplifications expected.
## **Input**
To simplify the format of the input data, we will admit here that the set Q is always of the form {1. . . n} (integer n), Σ is the Portuguese alphabet. 
Thus A = (Q, Σ, i, F, Rδ) can be introduced by:
- a line with the integer *n*, specifying the set S = {1..n};
- a line with the integer *i* that identifies which state of Q is the initial state;
- a line with the number *f* (cardinality of the set F of the final states);
- a line with *f* distinct integers that form the set of final states;
- a line with the number *m* of transitions (the cardinality of Rδ);
- *m* lines where each one introduces a transition in the form **i c j**, where *i* is the integer
representing the starting state of the transition, *c* the character in the transition label and *j* the
integer that represents the arrival state.

## **Output** 
The resulting regular expression, in the form of a string.
## **Sample input**
3  
1   
2  
2 3  
5  
1 a 1  
1 b 2  
2 a 2  
2 b 3  
3 b 3  

## **Sample Output**
((((b + ((1 + a) . (a* . b))) . (a* . b)) + (((b + ((1 + a) . (a* . b))) . (a* . b)) . (b* . (1 + b)))) + ((b + ((1 + a) . (a* . b))) + ((b + ((1 + a) . (a* . b))) . (a* . (1 + a)))))
