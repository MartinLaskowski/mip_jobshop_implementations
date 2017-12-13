##Parameters

param n;		#number of operations
set N := {1..n};		#set of operations
set A within {N,N};		#fabriction sequence
set E within {N,N};		#operations in the same machine
param p{N};		#processing time of the operation i in N
param BM;		#big M

##Variables

var t{N}, >=0;		#starting date of operation i in N
var y{E}, binary;		#1 if operation i starts before opertion j
						#0 otherwiese 
var cmax, >=0;
##Objective function

minimize makespan: cmax;

##Constraints

s.t. c1{(i,j) in A}: t[j] >= t[i] + p[i];	#fabrication sequence
s.t. c2{(i,j) in E}: t[j] >= t[i] + p[i] - BM*(1-y[i,j]);	#same machine operation
s.t. c3{(i,j) in E}: y[i,j] + y[j,i] = 1;	#order of operation in the same machine
s.t. c4{i in N}: cmax >= t[i] + p[i];