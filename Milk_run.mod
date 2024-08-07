int numMarket = 3; //Number of plant
int numTruck = 5; // Number of Vehicle
float Capacity = 100; //Capacity per Vehicle, unit: ton

range Node = 0..numMarket; //Index of markets + Depot at 0
range Position = 0..numMarket; //Index of position
range Vehicle = 1..numTruck; //Index of the vehicle

float d[Node]=...; //Supplying of Market
float distPlant[Node][Node]=...; //Distance matrix between market i and j

dvar boolean x[Node][Node][Vehicle][Position]; //Equal 1 if arc (i, j) is traversed by vehicle k, and 0 otherwise
dvar boolean z[Vehicle]; //Equal 1 if vehicle k is used, and 0 otherwise
dvar float+ q[Node];

minimize sum(i in Node, j in Node, v in Vehicle,k in Position) distPlant[i][j]*x[i][j][v][k]*d[i]*166;

subject to {
  
	forall (i in Node) 
	q[i]==d[i];
	
Constraint_1: //Ensure that vehicles are used in ascending numerical order
	forall(v in Vehicle : v <= numTruck-1)
	  z[v] >= z[v+1];

Constraint_2: //The first node in any route is the depot (node 0)
	forall(v in Vehicle)
	  sum(j in Node : j != 0) x[0][j][v][0] == z[v];

Constraint_3: //Each non-depot node is entered once, deliveries cannot be split
	forall(j in Node : j!= 0)
	  sum(v in Vehicle, k in Position, i in Node : i != j) x[i][j][v][k] == 1;

Constraint_4: //Each non-depot node is exited once
	forall(j in Node : j != 0)
	  sum(v in Vehicle, k in Position, i in Node : i != j) x[j][i][v][k] == 1;
	  
Constraint_5: //Only one edge is traversed in each position of each route
	forall(v in Vehicle, k in Position)	
		  sum(i in Node, j in Node) x[i][j][v][k] <= z[v]; 

Constraint_6: //No routes involve a vehicle visiting the same non-depot node consecutively
	forall(v in Vehicle, k in Position)
	  sum(i in Node : i != 0) x[i][i][v][k] == 0;
	   
Constraint_7: //Entered non-depot nodes are immediately exited in the next edge traversal
	forall(v in Vehicle, k in Position : k <= numMarket - 1, j in Node : j != 0)
	  sum(i in Node) x[i][j][v][k] - sum(n in Node) x[j][n][v][k+1] == 0;
	  
Constraint_8: //Each vehicle’s capacity is not exceeded by the demands of the markets assigned to their route
	forall(v in Vehicle, l in Position)
	  sum(i in Node, j in Node : i != j, k in Position : k <= l) x[i][j][v][k] * d[j] <= Capacity;
}
