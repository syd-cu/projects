# -*- coding: utf-8 -*-
"""
   Author:  David Wright, Siyu Duan 
    Email:  david_wright@ncsu.edu, sduan@ncsu.edu
 Unity ID:  drwrigh3, sduan
    Class:  CSC111, Fall 2018
      Lab:  N/A, 202

  Program:  Project 2 Part 2
 Due Date:  Due 10/19 at 11:45 p.m.

  Purpose:  Student testing script

   "Bugs":  ["None"]

#== WORKLOG ==================================================================
  Date   | Time |    Computer name    |  Location  |   Notes
09/13/17 | 1346 |  CSC-A9OS2ALNGA8    | 3250 EB2   | Initial version
09/25/18 | 1028 |  CSC-A9OS2ALNGA8    | 3250 EB2   | revised for fall 2018
10/06/18 | 2351 |  Personal laptop    | Home       | Initial version for additional test cases
10/06/18 | 2358 |  Personal laptop    | Home       | Completed version for additional test cases
10/11/18 | 1636 |  Personal laptop    | Library    | Revision 
#=============================================================================

#== AKNOWLEDGEMENTS ==========================================================
Note any and all help you received on this program module, including class
notes, Piazza, etc.

Project 2 part 1 quiz 
p2p2 documentation 
#=============================================================================

"""

#=============================================================================
# IMPORT STATEMENTS
#=============================================================================

import p2p2_sim as sim
import p2p2_random as rand

#=============================================================================
# MODULE-LEVEL VARIABLES
#=============================================================================


#=============================================================================
# FUNCTIONS/METHODS
#=============================================================================

def test_calc_waiting():
    """A very simple test case for the calc_waiting function using one 
       increment set of values from the example given in the project text.
    """
    print '\nTesting calc_waiting'
    expected = 142
    actual = sim.calc_waiting(106, 35, 71)
    if expected == actual:
        print 'calc_waiting(106, 35, 71) test passed.'
    else:
        print 'calc_waiting(106, 35, 71) test failed.'
        print 'expected: ', expected, '  actual: ', actual
        print ''


def test_calc_waiting_1():
    """A very simple test case for the calc_waiting function using one 
       increment set of values from the example given in the project text.
    """
    print '\nTesting calc_waiting_1'
    expected = 14
    actual = sim.calc_waiting(26, 32, 20)
    if expected == actual:
        print 'calc_waiting(26, 32, 20) test passed.'
    else:
        print 'calc_waiting(26, 32, 20) test failed.'
        print 'expected: ', expected, '  actual: ', actual
        print ''
        
def test_calc_waiting_2():
    """A very simple test case for the calc_waiting function using one 
       increment set of values from the example given in the project text.
    """
    print '\nTesting calc_waiting_2'
    expected = 0
    actual = sim.calc_waiting(7, 31, 22) #Arithmetically compute to a negative value -2
    if expected == actual:
        print 'calc_waiting(7, 31, 22) test passed.'
    else:
        print 'calc_waiting(7, 31, 22) test failed.'
        print 'expected: ', expected, '  actual: ', actual
        print ''
        
def test_calc_waiting_3():
    """A very simple test case for the calc_waiting function using one 
       increment set of values from the example given in the project text.
    """
    print '\nTesting calc_waiting_3'
    expected = 0
    actual = sim.calc_waiting(9, 34, 25) #Arithmetically compute to a 0 value
    if expected == actual:
        print 'calc_waiting(9, 34, 25) test passed.'
    else:
        print 'calc_waiting(9, 34, 25) test failed.'
        print 'expected: ', expected, '  actual: ', actual
        print ''
        
def test_run_sim():
    """ A very simple test harness for the 2 simulation functions for this
        part of the project.  Using the example given in the assignment, the
        output from this test should look something like this:
------------------------------------------------
   Minute     Arrivals   Departures   Waiting   
------------------------------------------------
     1           58          24          34     
     2           72          24          82     
     3           52          24         110     
     4           50          24         136     
     5           56          72         120     
     6           50          72          98     
     7           80          72         106     
     8           56          72          90     
     9           64          72          82     
     10          74          72          84     
     11          66          72          78     
     12          68          72          74     
     13          58          72          60     
     14          56          72          44     
     15          62          72          34     
     16          46          72          8      
     17          66          72          2      
     18          50          52          0      
------------------------------------------------    

        Note that because the number of arrivals at each minute is a random
        number, the exact details of the output will vary from run to run.  
        Howewver, the number of departures should change from 24 to 72 after
        minute 4 as the number of toll booths changes from 1 to 3.
    """
    rnd = rand.Arrivals(31, 40)
    sim.run_sim(2, 1, 3, 4, 24, rnd)
    
def test_run_sim_1():
    """ A very simple test harness for the 2 simulation functions for this
        part of the project.  Using the example given in the assignment, the
        output from this test should look something like this:
------------------------------------------------
   Minute     Arrivals   Departures   Waiting   
------------------------------------------------
     1           93          44          49     
     2          111          44         116     
     3          108          44         180     
     4          117          44         253     
     5           96          44         305     
     6          108          44         369     
     7          120         110         379     
     8          102         110         371     
     9          117         110         378     
     10          99         110         367     
     11         123         110         380     
     12         120         110         390     
     13          81         110         361     
     14         108         110         359     
     15         108         110         357     
     16          93         110         340     
     17          78         110         308     
     18          90         110         288     
     19         120         110         298     
     20         123         110         311     
     21         120         110         321     
     22         105         110         316     
     23          87         110         293     
     24          90         110         273     
     25         114         110         277     
     26          96         110         263     
     27         102         110         255     
     28          90         110         235     
     29          90         110         215     
     30         120         110         225     
     31          93         110         208     
     32         102         110         200     
     33          81         110         171     
     34         111         110         172     
     35         108         110         170     
     36          78         110         138     
     37         114         110         142     
     38         120         110         152     
     39         102         110         144     
     40         114         110         148     
     41         114         110         152     
     42         108         110         150     
     43          96         110         136     
     44         120         110         146     
     45          96         110         132     
     46         108         110         130     
     47         117         110         137     
     48          66         110          93     
     49          99         110          82     
     50          93         110          65     
     51          87         110          42     
     52         102         110          34     
     53         114         110          38     
     54         123         110          51     
     55         105         110          46     
     56         123         110          59     
     57         120         110          69     
     58          90         110          49     
     59          87         110          26     
     60          81         110          0      
------------------------------------------------

        Note that because the number of arrivals at each minute is a random
        number, the exact details of the output will vary from run to run.  
        Howewver, the number of departures should change from 44 to 110 after
        minute 6 as the number of toll booths changes from 2 to 5.
    """
    rnd = rand.Arrivals(36, 41)
    sim.run_sim(3, 2, 5, 6, 22, rnd)


#=============================================================================
# MAIN METHOD & TESTING AREA
#=============================================================================

def main():
    test_calc_waiting()
    test_calc_waiting_1()
    test_calc_waiting_2()
    test_calc_waiting_3()
    test_run_sim()
    test_run_sim_1()



if __name__ == '__main__':
    main()
    
    
    
    