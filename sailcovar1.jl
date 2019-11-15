# created by Slametian Dewa Tegar Perkasa

using JuMP, Clp, Printf

m = Model(with_optimizer(Clp.Optimizer));

f_d = [40, 60, 75, 25, 36] #forecast demand

@variable(m, h[1:6] >= 0)
@variable(m, y[1:5] >= 0)
@variable(m, 0 <= x[1:5] <= 40)

@constraint(m, h[1] == 15)
@constraint(m, h[5] >= 10)
@constraint(m, flow[t in 2:5], h[t] == h[t-1]+x[t]+y[t]-f_d[t])

@objective(m, Min, 400*sum(x) + 450*sum(y) + 20*sum(h))

optimize!(m)

@printf("inventories: %d %d %d %d %d\n", value(h[1]), value(h[2]), value(h[3]), value(h[4]), value(h[5]))
@printf("objective costs: \$%.2f\n", objective_value(m))
