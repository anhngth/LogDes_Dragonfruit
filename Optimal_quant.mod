int numSupplier= ...;
int numMarket= ...;

range Supplier = 1..numSupplier;
range Market = 1..numMarket;

float T[Supplier][Market]= ...; //Cost suppliers transported to market
float c[Supplier]= ...; //Capacity of the supplier
float d[Market]=...; //Demand of the market

dvar int+ q[Supplier][Market]; //Transported quantity from the supppliers to market

minimize sum(i in Supplier, j in Market) (T[i][j] * q[i][j]);

subject to {

Constraint_1: //Total supplied quantity must equal the demand of the market
  forall(j in Market)
    sum(i in Supplier) q[i][j] == d[j];
    
Constraint_2: //Total supplied quantity of each supplier must be less than or equal the capacity of that one
  forall(i in Supplier)
    sum(j in Market) q[i][j] <= c[i];
}