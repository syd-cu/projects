# -*- coding: utf-8 -*-
"""
   Author:  [Siyu Duan]
    Email:  [sduan@ncsu.edu]
 Unity ID:  [sduan]
    Class:  CSC111 Fall 2018
 Semester:  [Fall 2018]
      Lab:  [202]

  Program:  [Project 2 part 2]
 Due Date:  [Due 10/19 by 11:45 pm]

  Purpose:  [Implement simulation program]

   "Bugs":  [ "None"]

#== WORKLOG ==================================================================
  Date   | Time |   Computer name |  Location  |   Notes
08/08/18 | 1016 | CSC-A9OS2ALNGA8 | 3250 EB2   | Revision of header for fall 
         |      |                 |            |  2018 semester (DRW)
10/02/18 | 0952 | Personal laptop | Library    | Initial version 
10/05/18 | 2215 | Personal laptop | Home       | Completed version 
#=============================================================================

#== AKNOWLEDGEMENTS ==========================================================
Note any and all help you received on this program module, including class
notes, Piazza, etc.

p2p2 documentaion
Lab slides 6 
#=============================================================================

"""

#=============================================================================
# IMPORT STATEMENTS
#=============================================================================
import p2p2_random as rand 
import p2p2_const as con
import csc111_input as inp




#=============================================================================
# MODULE-LEVEL VARIABLES
# module_level_variable2 = 98765
# """int: var  Module level variable documented inline."""
#=============================================================================







#=============================================================================
# FUNCTIONS/METHODS
# def func(param1, param2):
#     """This function does something with the parameters.
#     Args:
#         param1 (int): The first parameter.
#         param2 (str): The second parameter.
#     Returns:
#         bool:  The return value. True for success, False otherwise.
#         If function does not return a computed value, indicate 
#         "no return value" or "None"
#    """
#    function body statements
#=============================================================================
def calc_waiting(arrive, depart, curr_wait):
    """This function calculates and returns the new number of items in a queue.
    Args:
        arrive(int): The number of items arriving at the queue.
        depart(int): The number of items departing at the queue.
        curr_wait(int): The number of items that are already in the queue. 
    Returns:
        int: New numbers of items in a queue based on the info in the argument.
    """
    new_waiting = arrive + curr_wait - depart
    return max(new_waiting,0)
   

def print_welcome():
    """ This function neatly prints a welcome message.
    Args: 
        None.
    Returns: 
        None.
    """
    print "Welcome to Siyu Duan's Toll Booth Simulator."
    print "Unity ID: sduan  Lab: 202"
    
    print "This program simulates the effects of toll booths on a highway by"
    print "computing how many vechicles arrive and depart from the toll booth"
    print "side. The simulation continues until any backup that occurs is"
    print "cleared and traffic flow returns to its normal rate."
 
def print_goodbye():
    """ This function neatly prints a goodbye message.
    Args: 
        None.
    Returns: 
        None.
    """
    print "Thank you for using my toll booth simulation program."
   
def sim_line(time, arrive, booth_rate, curr_wait):
    """This function generates the formatted output.
    Args:
        time(int): The time at that point.
        arrive(int): The number of items arriving at the queue.
        booth_rate(int): The number of items departing at the queue.
        curr_wait(int): The number of items waiting at the queue.
    Returns: 
        str: A string representation of the line.
    """
    return '{0:^12d}{1:^12d}{2:^12d}{3:^12d}'.format(time, arrive, booth_rate, curr_wait)
   
def run_sim(lanes, booths_1, booths_2, first_time, booth_rate, rnd_gen):
    """This function executes the simulation, calculating the minute by mimute 
    volumes of vehicles arriving, departing, and waiting in the backup.
    Args:
        lanes(int): The total number of lanes.
        booths_1(int): The number of booths in the first interval.
        booths_2(int): The number of booths in the second interval.
        first_time(int): The duration of the first interval in mimutes.
        booth_rate(int): The number of vehicles processed per mimute by a booth.
        rnd_gen(Arrivals): The number of vehicles arriving at each minute of the simulaiton. 
    Returns:
        None. 
    """
    print "-"*48
    print '{0:^12s}{1:^12s}{2:^12s}{3:^12s}'.format("Minute", "Arrivals", "Departures", "Waiting")
    print "-"*48
    time = 1
    arr_rate = rnd_gen.get_arrivals()  
    curr_wait = calc_waiting (arr_rate*lanes, booth_rate*booths_1, 0)   
    print sim_line(time, arr_rate*lanes, booth_rate*booths_1, curr_wait)
    while curr_wait > 0:
        time = time + 1       
        if time <= first_time:
            arr_rate = rnd_gen.get_arrivals()
            arrive = arr_rate * lanes
            curr_wait = calc_waiting(arrive, booth_rate*booths_1, curr_wait)
            print sim_line(time, arrive, booth_rate * booths_1, curr_wait)
        else:
            arr_rate = rnd_gen.get_arrivals()
            arrive = arr_rate * lanes
            curr_wait = calc_waiting(arrive, booth_rate*booths_2, curr_wait)
            print sim_line(time, arrive, booth_rate * booths_2, curr_wait)
    print "-"*48 


#=============================================================================
# MAIN FUNCTION & TESTING AREA
#
# Optional test functions:
# def test_xxx(...)
#     """xxx is the name of the function you are testing
#        document any arguments and return values as normal functions
#     """
#=============================================================================

def main():
    """Excute simulation"""
    print_welcome()
    #Prompt users to get the value
    lanes = inp.get_int("Enter the number of lanes in the highway:", con.MIN_LANES, con.MAX_LANES)
    max_rate = inp.get_int("Enter the maximum vehicle capacity per lane per minute:", 1, con.MAX_CAPACITY)
    avg_rate = inp.get_int("Enter the average normal arrival rate in vehicles/lane/minute:", 1, max_rate)
    booth_rate = inp.get_int("Enter the average toll booth processing rate:", 1, con.MAX_CAPACITY)
    booths_1 = inp.get_int("Enter the number of toll booths in the first time interval:", 1, con.MAX_BOOTHS)
    booths_2 = inp.get_int("Enter the number of toll booths in the second time interval:", booths_1, con.MAX_BOOTHS)
    first_time = inp.get_int("Enter the duration of the first time interval:", 0, con.MAX_DURATION)                                                                                                          
    #Initiate random generator
    rnd_gen = rand.Arrivals(avg_rate, max_rate)
    run_sim(lanes, booths_1, booths_2, first_time, booth_rate, rnd_gen)
    
    #Ask user if run another simulation
    message = raw_input("Run another simulation(y/n)?")
    while message.lower()=="y":
        lanes = inp.get_int("Enter the number of lanes in the highway:", con.MIN_LANES, con.MAX_LANES)
        max_rate = inp.get_int("Enter the maximum vehicle capacity per lane per minute:", 1, con.MAX_CAPACITY)
        avg_rate = inp.get_int("Enter the average normal arrival rate in vehicles/lane/minute:", 1, max_rate)
        booth_rate = inp.get_int("Enter the average toll booth processing rate:", 1, con.MAX_CAPACITY)
        booths_1 = inp.get_int("Enter the number of toll booths in the first time interval:", 1, con.MAX_BOOTHS)
        booths_2 = inp.get_int("Enter the number of toll booths in the second time interval:", booths_1, con.MAX_BOOTHS)
        first_time = inp.get_int("Enter the duration of the first time interval:", 0, con.MAX_DURATION)                                                                                                          
        rnd_gen = rand.Arrivals(avg_rate, max_rate)
        run_sim(lanes, booths_1, booths_2, first_time, booth_rate, rnd_gen) 
        message = raw_input("Run another simulation(y/n)?")   
    print_goodbye()

if __name__ == '__main__':
    main()
    
    
    
    

