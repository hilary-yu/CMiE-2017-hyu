# Computational Methods in Economics 2017
*Computational Methods in Economics, Spring 2017:* Term Project Repository

*Project Title:* Solving the Power Flow Equations

*Author:* Hilary Yu

Power flow analysis involves describing the operating state of a power system - the network of generators, transmission lines, and loads representing a certain service area, which could range from a municipality to an area several states large. Starting with certain known quantities throughout the network, such as generation and load values, the analysis facilitates a determination as to how power flows to its destination.

The power flow problem for alternating current systems is nonlinear; hence, before the age of computers, systems were primarily approximated using d.c. models, which implement a number of assumptions to linearize the problem. Today, however, advancements in computational power facilitate the use of iterative, numerical methods for solving the a.c. power flow equations. These methods include the Newton-Raphson and Gauss-Seidel methods, which find solutions via convergence, within an accepted tolerance. 

The objective of this project is to code the numerical solutions for the a.c. power flow equations, validating the functions against given system test cases.
