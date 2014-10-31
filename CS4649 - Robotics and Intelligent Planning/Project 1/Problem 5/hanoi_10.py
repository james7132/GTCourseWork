from pyhop import *
import hanoi_domain
import sys
sys.setrecursionlimit(30000)

state = State('hanoi-state')
state.diskLocation = [1 for i in range(0, 10)]

pyhop(state, [('move', 9, 1, 3, 2)], verbose=1)
