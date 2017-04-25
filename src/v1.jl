# read in data
# function create_Ybus_matrix

# convert to per unit notation
function per_unit(V, P, I, Z, V_base, P_base)
    V_pu = V/V_base
    P_pu = P/P_base
    # Q_base = P_base
    # S_base = P_base
    I_base = S_base/V_base
    I_pu = I/I_base
    Z_base = V_base/I_base
    Z_pu = Z/Z_base
    return(V_pu, P_pu, I_pu, Z_pu)
end

# build the y-bus admittance matrix

# dc approximation

# newton-raphson

# gauss-seidel

