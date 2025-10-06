#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Assignment 4
#### Due Tuesday, March 24, 2020 at midnight.

# Your goal is to:
#	1) Read a CSV file from the working directory given a filename
#	2) Create a multi-page PDF file that contains plots of all combinations 
#		of the input data's columns given specific formatting requirements, 
#		as well as plotting a line generated from a linear regression through
#		the points.
#	3) Write a CSV file (with a header) LINE BY LINE, one line for each plot,
#		containing the x and y column names and the correlation between those
#		two columns.

# Requirements:
#	1) The function should be named "plotTableFromDisk" and have the following
#		parameters:
#		dataFile : the filename of the input CSV file
#		outpdf : the filename used for the output PDF, 
#			and should default to "mypdf.pdf"
#		outcor : the filename used for the output CSV,
#			and should default to "mycor.csv"
#	2) All combinations of the input columns should be plotted and
#		have their correlations calculated/stored, but you don't
#		have to do symmetrical plotting, e.g. for two columns A and B,
#		plot only A vs. B, not B vs. A.
#		Hint: ?combn
#	3) Each plot should be formatted as follows:
#		- The axes should range between the minimum to the maximum of 
#		ALL VALUES in the input dataFile -- e.g. the ranges of x and y
#		will be the same, and the axes will be constant across all
#		plots.
#		- The x- and y-axis labels should be the column names.
#		- The title of the plot should be "[x-column name] vs. [y-column name]"
#		- The points should be "triangle point-up" (see ?points), have
#		a red outline, and be 1.5 times the normal size.
#		- The line should be derived from a linear regression (?lm), and should
#		be blue.
#	4) The output CSV should have a header which, in a text editor, would look like:
#		xcol,ycol,correlation
#	5) The CSV must be written line-by-line, not all at once.
#	6) The PDF and the CSV file must be properly closed.
#	7) The function should return a NULL.
#	8) Comment your code in at least 3 places.
#	9) The code should be submitted to Compass 2g as a single function with the filename:
#		LastName-FirstName-geog489-s20-assignment-04.R
#	and should have at the top:
#	[Your name]
#	Assignment #4


# Tests:
plotTableFromDisk(dataFile="geneData.csv",outpdf="mypdf.pdf",outcor="mycor.csv")
# NULL
# Check mypdf.pdf and mycor.csv
