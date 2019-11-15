# created by Slametian Dewa Tegar Perkasa

using JuMP, Clp, Printf

m = Model(with_optimizer(Clp.Optimizer))

d = [40 60 70 25] #demand

@variable(m, h[1:5] >= 0)
@variable(m, y[1:4] >= 0)
@variable(m, 0 <= x[1:4] <= 40)
@variable(m, c_p[1:4] >= 0) #c plus
@variable(m, c_m[1:4] >= 0) #c minus

@constraint(m, h[4] >= 10)
@constraint(m, h[1] == 50)
@constraint(m, flow[t in 1:4], h[t]+x[t]+y[t] == d[t]+h[t+1])
@constraint(m, x[1] + y[1] - 50 == c_p[1] - c_m[1])
@constraint(m, x[2] + y[2] - (x[1] + y[1]) == c_p[2] - c_m[2])
@constraint(m, x[3] + y[3] - (x[2] + y[2]) == c_p[3] - c_m[3])
@constraint(m, x[4] + y[4] - (x[3] + y[3]) == c_p[4] - c_m[4])

@objective(m, Min, 400*sum(x) + 450*sum(y) + 20*sum(h) + 400*sum(c_p) + 500*sum(c_m))

optimize!(m)

@printf("inventories: %d %d %d %d\n ", value(h[1]), value(h[2]), value(h[3]), value(h[4]))
@printf("objective cost: \$%.2f\n", objective_value(m))
