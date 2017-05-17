#=
Check for slack bus.
@author: Hilary Yu
@course: ENERES290A
@date: Spring 2017

Checks to make sure there is a slack bus and if yes, how many slack buses there are.
Returns an error message if there is no slack bus and/or if there is more than one.

=#

#__precompile__()

#module SlackBusID

#import Base.show

##################################################################
## Check Bus Types
##################################################################

#################
## FUNCTIONS
#################

# Requires identification of the bus types (from the imported data)
    # e.g. b_types = d_power[:, 2]

# find_slack: A function that finds the slack bus(es)
### Arguments
# b_types
#    An object containing the bus types in the system. 

function find_slack(b_types)
    slack = zeros(length(b_types))
    for i in 1:length(b_types)
        if b_types[i]=="Slack"
            slack[i] = i
        end
    end
    return slack
end


# err_slack: A function that produces an error message if there is no slack bus in the system or if there is more than one
### Arguments
# slack
#    An object containing the indices of the slack bus. 

function err_slack(slack)
    for i in 1:length(slack)
        if slack[i] != 1
            return "Error: Slack not at Bus 1"
        end
        if sum(slack) != 1
            return "Error: Possibly than one slack bus in the system. Check sum with slack index"
        end
    end
end

#end # module SlackBusID