# -*- coding: utf-8 -*-
"""
   Author:  David Wright, Siyu Duan
    Email:  david_wright@ncsu.edu, sduan@ncsu.edu
 Unity ID:  drwrigh3, sduan
    Class:  CSC111, Fall 2018
      Lab:  N/A

  Program:  Project 2 Part 2

  Purpose:  Class for generating random arrivals for the toll booth
            simulation.  Uses numpy.random.poisson distribution 

   "Bugs":  [A list of remaining problems/omissions, or "None"]

#== WORKLOG ==================================================================
  Date   | Time |    Computer name    |  Location  |   Notes
09/19/17 | 0950 |  CSC-A9OS2ALNGA8    | 3250 EB2   | Initial version
09/24/18 | 1526 |  CSC-A9OS2ALNGA8    | 3250 EB2   | revised for toll booth sim

#=============================================================================

#== AKNOWLEDGEMENTS ==========================================================
Note any and all help you received on this program module, including class
notes, Piazza, etc.

#=============================================================================

"""

#=============================================================================
# IMPORT STATEMENTS
#=============================================================================
import numpy.random as rnd

#=============================================================================
# FUNCTIONS/METHODS
# def func(param1, param2):
#     """This function does something with the parameters.
#     Args:
#         param1 (int): The first parameter.
#         param2 (str): The second parameter.
#     Returns:
#         bool:  The return value. True for success, False otherwise.
#    """
#    function body statements
#=============================================================================

class Arrivals:
    """ Class for generating random arrivals for the toll booth simulation."""
    def __init__(self, avg_rate, max_rate):
        """ Create an instance of the class.
            Args:
                avg_rate (int):  The average arrival rate.  Used as lambda in
                                 creating the Poisson distribution.
                max_rate (int):  The maximum arrival rate.  The array of values
                                 in the distribution is filtered to remove any
                                 that are greater than this value.
        """
        self.average = avg_rate
        self.maximum = max_rate
        
    def get_arrivals(self):
        """ Returns the next value in the random distribution of arrivals.
            Return:
                int:  the next value in the distribution
        """
        arr = rnd.poisson(self.average)
        while arr > self.maximum:
            arr = rnd.poisson(self.average)
        return arr
         

#=============================================================================
# MAIN METHOD & TESTING AREA
#=============================================================================

def main():
    """simple test of the class"""
    arrs = Arrivals(27, 37, 1)
    s = 0.0
    for i in range(50):
        n = arrs.get_arrivals()
        s += n
        print 'Arrival {}: {}'.format(i, n)
    print 'Average arrivals: {}'.format(s / 50.0)
    



if __name__ == '__main__':
    main()
    
    
    
    
