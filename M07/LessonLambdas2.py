from functools import reduce
from math import sqrt 

## Calculate the standard deviation of the collection of numbers
numbers = range(1,11)
mean = sum(numbers)/len(numbers)
meandiff = map(lambda x: x - mean, numbers)
sqmeandiff = map(lambda x: pow(x, 2), meandiff)
sumsqrs = reduce(lambda x1, x2: x1+x2, sqmeandiff)
sumsqrs2 = sum(list(sqmeandiff))
stdev = sqrt(sumsqrs/(len(numbers)-1))
print(stdev)
print(list(numbers))
print(mean)
print(list(meandiff))
print(list(sqmeandiff))
print(sumsqrs)
print(sumsqrs2)
print(type(numbers))
print(type(sqmeandiff))


class Person:
    """Person class
    This is the docstring of this class"""
    
    def __init__(self, name):
        print('Initializing name')
        self.__name = name
        
    @property
    def name(self):
        print('Getting name')
        return self.__name
    
    @name.setter
    def name(self, new_name):
        print('Setting name')
        self.__name = new_name
    
    @name.deleter
    def name(self):
        print('Deleting name')
        del self.__name
        
    def move(self):
        print('Moving')
        
person1 = Person('Sarah')
person2 = Person('Mike')

print(person2.name)
person2.name = 'Michael'
print(person2.name)

del person2.name

del person1

print(person1.name)
