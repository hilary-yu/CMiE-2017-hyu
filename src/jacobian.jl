#=
Jacobian Matrix.
@author: Hilary Yu
@course: ENERES290A
@date: Spring 2017

Creates a Jacobian matrix from the Y-bus admittance matrix.

=#

#__precompile__()

#module JacobianMatrix

import Base.show

# function create_Jacobian(Ybus, indexPQ, P, Q, V, ang)
    
    ## Preallocate the arrays for the voltage phase angles
    # Voltage phase angles for the PV buses
    Pjm_ang = zeros(size(Ybus,1), size(Ybus,1))
    # Voltage phase angles for the PQ buses
    Qjm_ang = zeros(length(indexPQ), size(Ybus,1))
    
    # Preallocate the arrays for the voltage magnitudes
    # Voltage magnitudes for the PV buses
    Pjm_V = zeros(size(Ybus,1), length(indexPQ))
    # Voltage magnitudes for the PQ buses
    Qjm_V = zeros(length(indexPQ), length(indexPQ))
    
    
    # calculate PV bus voltage phase angles
    for i = 1:(size(Ybus,1))
        for j = 1:(size(Ybus,1))
            if (i == j)
                Pjm_ang[i, j] = -Q[i] - imag(Ybus[i,j]) .* (V[i].^2)
            else           
                Pjm_ang[i, j] = V[i].*V[j].* (real(Ybus[i,j]).*sin(ang[i]-ang[j]) - imag(Ybus[i,j]).*cos(ang[i] - ang[j]))
            end
        end
    end
    
    # calculate PQ bus voltage phase angles
    for i = indexPQ[1]:indexPQ[end]
        for j = 1:(size(Ybus,1))
            if (i == j)
                Qjm_ang[find(indexPQ -> indexPQ == i, indexPQ), j] = P[i] - real(Ybus[i,j]) .* (V[i].^2)
            else                       
                Qjm_ang[find(indexPQ -> indexPQ == i, indexPQ), j] = -V[i].*V[j].* (real(Ybus[i,j]).*cos(ang[i]-ang[j]) + imag(Ybus[i,j]).*sin(ang[i] - ang[j]))  
            end          
        end
    end
    
    # calculate PV bus voltage magnitudes
    for i = 1:(size(Ybus,1))
        for j = indexPQ[1]:indexPQ[end]
            if (i == j)
                Pjm_V[i, find(indexPQ -> indexPQ == j, indexPQ)] = P[i]/V[i] + real(Ybus[i,j]) .* V[i]
            else
                Pjm_V[i, find(indexPQ -> indexPQ == j, indexPQ)] = V[i].* (real(Ybus[i,j]).*cos(ang[i]-ang[j]) + imag(Ybus[i,j]).*sin(ang[i] - ang[j]))
            end
        end
    end
    
    # calculate PQ bus voltage magnitudes
    for i = indexPQ[1]:indexPQ[end]
        for j = indexPQ[1]:indexPQ[end]
            if (i == j)
                Qjm_V[find(indexPQ -> indexPQ == i, indexPQ), find(indexPQ -> indexPQ == j, indexPQ)] = Q[i]/V[i]- imag(Ybus[i,j]) .* V[i];
            else
                Qjm_V[find(indexPQ -> indexPQ == i, indexPQ), find(indexPQ -> indexPQ == j, indexPQ)] = V[i].* (real(Ybus[i,j]).*sin(ang[i]-ang[j]) - imag(Ybus[i,j]).*cos(ang[i] - ang[j]))   
            end          
        end
    end
    
    # concatenate to create the Jacobian matrix
    Jacmat_top = hcat(Pjm_ang[2:end,2:end],Pjm_V[2:end,:])
    Jacmat_bot = hcat(Qjm_ang[:,2:end],Qjm_V)
    Jacmat = vcat(Jacmat_top, Jacmat_bot)
    
    return Jacmat

#end

#end # module JacobianMatrix