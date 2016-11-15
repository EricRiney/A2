#! python 3
import glob
import os
import csv

# find all csv files in current working directory
first = True
csvRows = []
sex = ""
posture = ""
participantID = ""

for counter, csvFilename in enumerate(glob.glob("[!bigData]*.csv")):
	# TODO: grab sex, posture, and participant ID from csvFilename
	csvFilenameNoExt = csvFilename.split(".")[0].lower()
	participantParameters = csvFilenameNoExt.split("_")	
	# print(participantParameters)
	csvFileObj = open(csvFilename)
	readerObj = csv.reader(csvFileObj)
	for row in readerObj:
		if readerObj.line_num - 7 < 1 and readerObj.line_num != 2 :
			# skip the first row, we don't want the credit link or practice runs
			continue
		if readerObj.line_num == 2:
			# grab csv after first line
			if first == False:
				# we only want the header from the first csv file
				continue
			else:
				# add extra header parameters
				row.insert(0, "Posture")
				row.insert(0, "Sex")
				row.insert(0, "ParticipantID")
				first = False
				csvRows.append(row)
				continue
		# add the extra participant parameters (sex, posture, and id)
		if participantParameters[2] == "sit" or participantParameters[2] == "sitting":
			row.insert(0, "Sitting")
		else:
			row.insert(0, "Standing")
		row.insert(0, participantParameters[1].upper())
		row.insert(0, participantParameters[0])
		csvRows.append(row)
		# print("test")
	csvFileObj.close()

# write out the big csv file
csvFileObj = open("bigData.csv", 'w')
csvWriter = csv.writer(csvFileObj)
for row in csvRows:
	csvWriter.writerow(row)
csvFileObj.close()