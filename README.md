# Palindrome-array

The following files are used to compute the given palindrome array and display the resulting answer as an array and a bar graph. 

For a better understanding: a palindrome is a string that reads the same from left to right
as from right to left, for example a, aba, deleveled (past tense of delevel  to demote or
be demoted to a lower level).

A prex of a string is a substring starting from the position 0 (python and NASM start
indexing from 0). Thus, for a string abcde, the prexes are a, ab, abc, abcd, and abcde.
A sux of a string is a substring ending at the position n − 1. Thus, for a string abcde, the
suxes are e, de, cde, bcde, and abcde.

Consider a string of length n denoted as x[0..n − 1]. For each i = 0 ... i = n − 1 we can nd
the longest palindrome that starts at the position i. It always exists, as a single letter is a
palindrome. Thus, the longest palindrome at the position i must have a length of at least 1
and at most n − 1 − i.

The palindrome array for a string x[0..n − 1] is an integer array palar[0..n − 1] of length
n, where palar[i] = the length of the longest palindrome starting at position i.


