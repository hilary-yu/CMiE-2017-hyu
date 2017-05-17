#=
Y-bus Admittance Matrix.
@author: Hilary Yu
@course: ENERES290A
@date: Spring 2017

Creates the Y-bus admittance matrix. Make sure input data is in a dataframe.

=#

#__precompile__()

#module YBusMatBuilder

# using ExcelReaders, DataFrames, DataArrays

# import Base.show

##################################################################
## Build the Y-Bus Admittance Matrix
##################################################################

#############
## TYPES
#############

# colnumY: A type that holds the column numbers for the data series from which the Y-bus matrix is created.
# Helps to organize indexing when creating the Y-bus matrix.
### Fields
# FROMnode::Int64 
#    The number of the column corresponding to the data for the 'from' node.
# TOnode::Int64
#    The number of the column corresponding to the data for the 'to' node.
# R::Int64
#    The number of the column corresponding to the data for resistance (R).
# X::Int64
#    The number of the column corresponding to the data for reactance (X).
# halfY::Int64
#   The number of the column corresponding to the data for the admittance of line-charging capacitors.
# Y::Int64
#   The number of the column corresponding where the admittance data would be stored.

type colnumY
    FROMnode::Int64
    TOnode::Int64
    R::Int64
    X::Int64
    halfY::Int64
    Y::Int64
end


#################
## FUNCTIONS
#################

# dp_solve: A function that creates the Y-bus admittance matrix.
### Arguments
# d_ybus
#    The dataframe that stores the relevant data. 
# ind::colnumY
#    An instance of colnumY that stores the column numbers of the data for the Y-bus matrix.

function Ybus_mat(d_ybus, ind::colnumY)
    # find the number of nodes in the system
    max, index_max = findmax(d_ybus[:,1])
    nodes = convert(Int64, max)

    # preallocate an empty Y-bus matrix
    Ybus = zeros(nodes, nodes)
    Ybus = complex(Ybus)
    
    for k = 1:length(d_ybus[:,1])
        # calculate the total admittance for each row of data in the dataframe
        linek = d_ybus[k, ind.R] + 1.0im* d_ybus[k, ind.X]
        if (linek == 0.)
            line = 0.
        else
            line = 1.0/linek
        end
        
        val = line + 1.0im* d_ybus[k, ind.halfY] + 1.0im*d_ybus[k, ind.Y]
        
        # create a way to index the Y-bus matrix by nodes
        tempFROM = d_ybus[k, ind.FROMnode]
        tempTO = d_ybus[k, ind.TOnode]
        FROM = convert(Int64, tempFROM)
        TO = convert(Int64, tempTO)
        
        # update the diagonal of the Y-bus matrix (which is the total admittance connected to bus k)    
        Ybus[FROM, FROM] += val
        
        #if the TO node != 0, add the calculated value to the diagonal for the FROM node (to get total admittance
        # connected to bus k)
        # also update with the line impedances (via TO and FROM)
        
        if (d_ybus[k, ind.TOnode] != 0.)
            Ybus[TO,TO] += val
            Ybus[TO,FROM] += -1*line
            Ybus[FROM,TO] += -1*line
        end
    end
    return Ybus
end


#end # module YBusMatBuilder