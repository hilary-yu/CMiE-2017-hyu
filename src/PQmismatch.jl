#=
Iteration mismatches.
@author: Hilary Yu
@course: ENERES290A
@date: Spring 2017

Calculates the mismatches for any iteration.

=#

#__precompile__()

#module Iter_mismatches


# function calc_mismatches(itr, Ybus, P, Q, V, ang, Pgen, Pload)
    
    if (itr != 0) 
        P = zeros(size(Ybus, 1),1)
        Q  = zeros(size(Ybus, 1),1)
        for A = 1:size(Ybus, 1)
            for B = 1:size(Ybus, 1)
                P[A] = P[A] +  V[A].*V[B].* (real(Ybus[A,B]).*cos(ang[A]-ang[B]) + imag(Ybus[A,B]).*sin(ang[A] - ang[B]))
                Q[A] = Q[A] +  V[A].*V[B].* (real(Ybus[A,B]).*sin(ang[A]-ang[B]) - imag(Ybus[A,B]).*cos(ang[A] - ang[B]))
            end
            P_mismatch[A] = P[A] - Pgen[A] + Pload[A]
            Q_mismatch[A] = Q[A] - Qgen[A] + Qload[A]
        end
    else
        for A = 1:size(Ybus, 1)
            P_mismatch[A] =  Pgen[A] - Pload[A]
            Q_mismatch[A] =  Qgen[A] - Qload[A]
            for B = 1:size(Ybus, 1)
                P[A] = P[A] + V[A].*V[B].*  real(Ybus[A,B]);
                Q[A] = Q[A]  -   V[A].*V[B].*  imag(Ybus[A,B]);
            end
        end
    end
    
    Pmis_temp = P_mismatch[2:end]
    Qmis_temp = (Q_mismatch[2:end].*PQs[2:end])
    for i in 1:size(P_mismatch,1)
        if findfirst(Pmis_temp,0) != 0
            deleteat!(Pmis_temp, findfirst(Pmis_temp, 0))
        end
    end
    for i in 1:size(Q_mismatch,1)
        if findfirst(Qmis_temp,0) != 0
            deleteat!(Qmis_temp, findfirst(Qmis_temp, 0))
        end
    end
    var = vcat(Pmis_temp,Qmis_temp)
    
    return var

# end

#end # module Iter_mismatches