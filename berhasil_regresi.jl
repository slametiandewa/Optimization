x = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
y = [ 0, 2, 4, 6, 2, 0, 1, 3, 1, 5]

using PyPlot
figure(figsize=(8,4))
plot(x,y,"k.", markersize=10)
axis([0,12,-4,10])
grid("on")

# order of polynomial
k = 3

# fit with f(x) = 3x^4 then:
# 3x1^3
# 3x1^2
# 3x1^1
n = length(x)
A = zeros(n,k+1)
for a = 1:n     
    for b = 1:k+1  
        A[a,b] = 3*x[a]^(k+1-b)
        print(A[a,b]," ")
    end
    println()
end

using JuMP, Mosek, MosekTools, Gurobi
m = Model(with_optimizer(Mosek.Optimizer, LOG=0))
@variable(m, u[1:k+1])
@objective(m, Min, sum( (y - A*u).^2 ) )

optimize!(m)
uopt = value.(u)
println(value.(u))
println(objective_value(m))

inv(A'*A)*(A'*y)

A\y

using PyPlot, Plots

npts = 100

xfine = range(0,stop=12.0,length=npts)
yfine2 = range(1,stop=12.0,length=npts)
ffine = ones(npts)
ffine2 = ones(npts)
for j = 1:k
    ffine = [ffine.*xfine ones(npts)]
end

for j = 1:k
    ffine2 = [ffine2.*yfine2 ones(npts)]
end

yfine = ffine * uopt
yfine2 = ffine2 * (uopt * 2)

println(yfine)
figure(figsize=(8,4))

plot(x, y, "k.", markersize=10)
plot(xfine, yfine, "b-")
plot(xfine, yfine2, "r-")

axis([0,12,-4,10])
grid()
