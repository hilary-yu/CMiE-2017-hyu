#=
Power flow analysis.
@author: Hilary Yu
@course: ENERES290A
@date: Spring 2017

Conducts a power flow analysis using the Newton-Raphson method.
Requires that the dataframe for the power system information be named: d_power

=#

#__precompile__()

#module NR_powerflow

using Plots
import Base.show

include("buildYbus.jl")
include("slackID.jl")

##################################################################
## Power Flow Analysis via Newton-Raphson
##################################################################

#############################
## Set-up/Data Clean-up
#############################


# Identify the PQ buses
### Arguments
# b_types
#    An object containing the bus types in the system. 

PQs = zeros(length(b_types))
for i = 1:length(b_types)
    if b_types[i] =="PQ"
        PQs[i]= 1
    end
end

# Create an index of the PQ buses
indexPQ = find(PQs.==1)

# Exclude the slack bus
Ynoslack = Ybus[2:end,2:end]

# Pre-allocate the arrays for the mismatch data
P = zeros(size(Ybus, 1))
Q  = zeros(size(Ybus, 1))
P_mismatch = zeros(size(Ybus, 1))
Q_mismatch  = zeros(size(Ybus, 1))

function igNaN(object)
    for i in 1:length(object)
        if object[i] == "NaN"
            object[i] = 0.0
        end
    end
    return object
end

# Replace NaNs in the data with 0.0s
Pgen = igNaN(d_power[Symbol("Pgen (pu)")])
Qgen = igNaN(d_power[Symbol("Qgen (pu)")])
Pload = igNaN(d_power[Symbol("Pload (pu)")])
Qload = igNaN(d_power[Symbol("Qload(pu)")])
V_temp = d_power[Symbol("Voltage (pu)")]
ang_temp = d_power[Symbol("Angle (rad)")]

# Set up the flat start
# Set unknown Voltages and Angles to 1 V and 0 degrees
function flat_start(V_temp, ang_temp)
    V = V_temp
    ang = ang_temp
    for i in 1:length(V_temp)
        if V_temp[i] == "NaN"
            V[i] = 1.0
        end
        if ang_temp[i] == "NaN"
            ang[i] = 0.0
        end
    end
    return V, ang
end

# Store the initial voltage magnitudes and voltage phase angles
V, ang = flat_start(V_temp, ang_temp)



#############################
## Newton-Raphson
#############################

# Set the parameters for the Newton-Raphson iteration
deltax = 1.0
itr = 0.0
tol = 1e-4

include("PQmismatch.jl")
include("jacobian.jl")

# Run for n iterations until covergence
mag_temp = V.*PQs
for i in 1:(size(Ybus,1))
    if findfirst(mag_temp,0) != 0
        deleteat!(mag_temp, findfirst(mag_temp, 0))
    end
end
magnitude = vcat(ang[2:end],mag_temp)
println("Y Bus: ")
println(Ybus)
println("")
while (maximum(abs(deltax)) > tol) 
    itr = itr+1
    deltax = -inv(Jacmat)*var
    magnitude = magnitude + deltax
    println("Max delx: ", maximum(abs(deltax)))
    println("")
    println("Jacobian")
    println(Jacmat)
    println("")
    println("Voltage: ")
    println("\t$V")
    println("")
    println("Phase Angle (in radians):")
    println("\t$ang")
    
    ang[2:end]  =  magnitude[1:length(ang)-1]
    V[indexPQ] = magnitude[length(ang):end]

    include("PQmismatch.jl")
    include("jacobian.jl")

end

angplot = scatter(ang, xlab = "Bus", ylab="Phase Angle (rad)", title="Newton-Raphson Results for Phase Angles",
    label="angle", ms=15)
vplot = bar(V, xlab = "Bus", ylab="Voltage (p.u.)", title="Newton-Raphson Results for Voltage Magnitudes", label="magnitude")
plot(angplot, vplot)
gui()

#end # module NR_powerflow
