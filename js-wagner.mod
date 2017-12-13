##Parameters

#set of operations
param n;
set N := {1..n};
		
#set of machines
param m;		
set M := {1..m};

#relates the operation i with its machie m(i)=k
set F within {N,M};

#fabriction sequence
set A within {N,N};

#operations in the same machine
set E within {N,N};

#number of operations executed by machine k in M
param nk{M};

#processing time of the operation i in N
param p{N};

#big M
param BM;		

##Varibles

#1 -> if i is the l-est element in the machine m(i)=k/ 
#0 -> otherwise
var y{(i,k) in F, l in 1..nk[k]}, binary;
	  
#starting date of the l-est operation in machine k											
var d{k in M, l in 1..nk[k]}, >=0;

#time between the l-est and the (l+1)-est operations in the machine k
var s{k in M, l in 1..nk[k]}, >=0;

#time until the first operation on machine k in M
var s0{M};

#processing time of the l-est operation in the machine k
var t{k in M, l in 1..nk[k]}, >=0;

#makespan
var cmax,>=0;

##Objective Function
minimize makespan: cmax;

##Constraints
#one operation needs to be on each position of each machines processing order
s.t. c1{k in M, l in 1..nk[k]}: sum{(i,k) in F}y[i,k,l] = 1;

#each operation i must be in only one position of its machine m(i) = k processing order
s.t. c2{(i,k) in F}: sum{l in 1..nk[k]}y[i,k,l] = 1;

#the processing time of the l-est  operation in the machine k is eaqual to the processing time of the operation in this position
s.t. c3{k in M, l in 1..nk[k]}: t[k,l] = sum{i in N:(i,k) in F}y[i,k,l]*p[i];

#the operations must respect the fabrication sequence
s.t. c4{(i,j) in A,(i,k1) in F,(j,k2) in F, l1 in 1..nk[k1], l2 in 1..nk[k2]}: d[k1,l1] + p[i]*y[i,k1,l1] <= d[k2,l2] + BM*(2- y[i,k1,l1] - y[j,k2,l2]);   

#time until the first operation
s.t. c5{k in M}: d[k,1] = s0[k];

#time between operations
s.t. c6{k in M, r in 2..nk[k]}: d[k,r] = s0[k] + sum{l in 1..r-1}(t[k,l] + s[k,l]);

#makespan
s.t. c7{k in M}: cmax >= d[k,nk[k]] + t[k,nk[k]];

