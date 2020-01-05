#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan  3 15:22:21 2020

@author: Arulprakasam
"""

"""
Bite 1. Sum n numbers

    Write a function that can sum up numbers:

        It should receive a list of n numbers.
        If no argument is provided, return sum of numbers 1..100.
        Look closely to the type of the function's default argument ...
        
"""

import sys



if len(sys.argv) == 1:
    n=100
else:
    n=int(sys.argv[1])


def lstgen(n):
    lst=[]
    for e in range(1,n+1):
        lst.append(e)
    return lst
lst=lstgen(n)

def sumnum(l):
    sumn=0
    for el in l:
        sumn=sumn+el
    return sumn

value=sumnum(lst)

print("Sum of {0} number is {1}".format(n,value))

