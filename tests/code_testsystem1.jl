#=
Test the algorithm on System 1.
@author: Hilary Yu
@course: ENERES290A
@date: Spring 2017

Tests the Newton-Raphson algorithm on System 1.

=#

__precompile__()

module TestSystem1

using ExcelReaders, DataFrames, DataArrays, Plots

import Base.show


#################
## Set-Up
#################

# Import .xlsx files of data using ExcelReaders. 
# Produce dataframes, which is the format used by buildYbus.jl.
# Make sure to keep the headers, or create your own using: 
        # df = readxl(DataFrame, "Filename.xlsx", "Sheet1!A1:C4",
        #    header=false, colnames=[:name1, :name2, :name3])

d_ybus = readxl(DataFrame, "test_system1.xlsx", "Sheet1!A1:F7")
d_power = readxl(DataFrame, "test_system1power.xlsx", "Sheet1!A1:H5")

#########################
## Check the Bus Types
#########################

# Identify the bus types
b_types = d_power[Symbol("Type")]

include("slackID.jl")

# Check that there is a slack bus & check the location of the slack bus
slack = find_slack(b_types)
check = err_slack(slack)

#########################
## Create the Y-Bus Matrix
#########################

include("buildYbus.jl")

# Run the function to create the Y-bus matrix
ind = colnumY(1,2,3,4,5,6)
Ybus = Ybus_mat(d_ybus, ind)

#########################################
## Run the Power Flow Analysis
#########################################

include("NRpowerflow.jl")


end # module TestSystem1