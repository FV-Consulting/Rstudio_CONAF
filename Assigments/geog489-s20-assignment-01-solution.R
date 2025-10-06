#	Chunyuan Diao
#	Assignment #1 Solution and Grading Rubric

# Chunyuan's solution (yours may differ!)

#	1) the function name should be "noRemainderIndices"
#	2) x should have no default, but d should default to 2.
noRemainderIndices <- function(x,d=2)
{
	#	3) the code should stop with a warning if d is anything but a single *numeric* element 
	if(mode(d) != "numeric") { stop("d must be numeric") }
	if(length(d) != 1) { stop("d must have a length of 1") }

	# Calculate remainders
	remainders = x %% d
	# Calculate index
	remainders_index = which(remainders == 0)
	
	#	4) if no indices are found, the code should return NULL
	if(length(remainders_index)==0)
	{
		return(NULL)
	}
	
	return(remainders_index)
		
}

# Initial tests:
noRemainderIndices(x=2:12,d=3)
# [1]  2  5  8 11
noRemainderIndices(x=2:12)
# [1]  1  3  5  7  9 11
noRemainderIndices(x=2:12,d=13)
# NULL
noRemainderIndices(x=2:12,d=1:3)
# Error in noRemainderIndices(x = 2:12, d = 1:3) : 
#		d must have a length of 1
noRemainderIndices(x=2:12,d="abc")

# Rubric:

# 4 points for the core code functionality working:  **(-1 point if code output didn't match test, but still returned proper indices (ex: values printed in reverse))**
	# Tests: 
	noRemainderIndices(x=2:12,d=4)
	# Should return: [1]  3  7 11
	noRemainderIndices(x=2:12,d=5)
	# Should return: [1] 4 9
	# Possible partial credit:
	# -1 for not using a return() statement (e.g. using print() ) **(half-point was awarded for using return at some point (ex: return(NULL), even if print was used later)**
	# -1 for not properly formatting a function call with brackets
# 1 point for naming the function correctly ("noRemainderIndices") and setting the variables to be x and d **(-0.5 if variables are missing or if extra parameters are added)**
	# Test: noRemainderIndices(x=2:12,d=2)
# 1 point for defaulting d to 2 in the function call
	# Note, there are other, albeit less efficient, ways this can be done, e.g. a statement in the body:
	# if(missing(d)) { d = 2 }
	# Test: 
	noRemainderIndices(x=2:12)
	# Should return: [1]  1  3  5  7  9 11
# 1 point for having both warnings (length (d) != 1 and mode(d) != numeric)  (0.5 each)
	# This could be merged into a single if statement with && 
	# Tests: 
	# Length error: 
	noRemainderIndices(x=2:12,d=1:3)
	# Mode error: 
	noRemainderIndices(x=2:12,d="abc")
# 1 point for returning NULL if no matches are found: **(half-point given for printing "NULL" as character class)**
	# Test:
	noRemainderIndices(x=2:12,d=13)
# 1 point for having at least two comments that make sense
# 1 point for naming the file correctly: lastname-firstname-geog489-s20-assignment-01.R
#	AND having the name and assignment number in a comment section at the top of the code.
# Total: 10 points

