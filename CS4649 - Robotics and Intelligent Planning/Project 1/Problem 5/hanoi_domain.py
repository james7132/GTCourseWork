import pyhop

def move_disk(state, disk, peg_source, peg_dest):
	if state.diskLocation[disk] == peg_source:
		state.diskLocation[disk] = peg_dest
		return state
	else:
		return False

pyhop.declare_operators(move_disk)

def move_multiple(state, disk, peg_source, peg_dest, peg_via):
	if disk > 0:
		return [('move', disk - 1, 	peg_source, peg_via, peg_dest), ('move_disk', disk, peg_source, peg_dest), ('move', disk - 1, peg_via, peg_dest, peg_source)]
	else:
		return False
		
def move_single(state, disk , peg_source, peg_dest, peg_via):
	if disk <= 0:
		return [('move_disk', disk, peg_source, peg_dest)]
	else:
		return False
		
pyhop.declare_methods('move', move_single, move_multiple)
