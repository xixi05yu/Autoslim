# Compiler and flags

CXX = g++

CXXFLAGS = -I/usr/include

LDFLAGS = -ltinyxml2 -lmlpack -larmadillo -fopenmp
 
# Targets

all: new2_xml_csv_degree gen_xml_multiple_files4

genFolder:
	mkdir 1E_xmlFiles 1E_csvFiles 1E_prunedResults 1E_prunedCSV 1E_prunedMIF 1E_MIFFile 
	mkdir 1A_xmlFiles 1A_csvFiles 1A_prunedResults 1A_prunedCSV 1A_prunedMIF 1A_MIFFile
	mkdir 2E_xmlFiles 2E_csvFiles 2E_prunedResults 2E_prunedCSV 2E_prunedMIF 2E_MIFFile 
	mkdir 2A_xmlFiles 2A_csvFiles 2A_prunedResults 2A_prunedCSV 2A_prunedMIF 2A_MIFFile
	mkdir 4E_xmlFiles 4E_csvFiles 4E_prunedResults 4E_prunedCSV 4E_prunedMIF 4E_MIFFile 
	mkdir 4A_xmlFiles 4A_csvFiles 4A_prunedResults 4A_prunedCSV 4A_prunedMIF 4A_MIFFile
	mkdir 8E_xmlFiles 8E_csvFiles 8E_prunedResults 8E_prunedCSV 8E_prunedMIF 8E_MIFFile 
	mkdir 8A_xmlFiles 8A_csvFiles 8A_prunedResults 8A_prunedCSV 8A_prunedMIF 8A_MIFFile
	mkdir 16E_xmlFiles 16E_csvFiles 16E_prunedResults 16E_prunedCSV 16E_prunedMIF 16E_MIFFile 	
	mkdir 16A_xmlFiles 16A_csvFiles 16A_prunedResults 16A_prunedCSV 16A_prunedMIF 16A_MIFFile
	mkdir 32E_xmlFiles 32E_csvFiles 32E_prunedResults 32E_prunedCSV 32E_prunedMIF 32E_MIFFile 
	mkdir 32A_xmlFiles 32A_csvFiles 32A_prunedResults 32A_prunedCSV 32A_prunedMIF 32A_MIFFile
	mkdir 64E_xmlFiles 64E_csvFiles 64E_prunedResults 64E_prunedCSV 64E_prunedMIF 64E_MIFFile 
	mkdir 64A_xmlFiles 64A_csvFiles 64A_prunedResults 64A_prunedCSV 64A_prunedMIF 64A_MIFFile

#Run rule
#./gen_xml_multiple_files4 <numStates> <maxTransitionsPerState> <numFiles> <outputFolder>
#./generate_csv_multiple <startFileNum> <endFileNum> <inputFolder> <outputFolder> <CSVOutputFolder>
#python3 pruning_multiple.py [-h] [--threshold THRESHOLD] startFileNum endFileNum inputFolder
run:
	#1k Set 975 Estimated Fan out and 500 Actual Fan out
	./gen_xml_multiple_files4 1000 975 10 1E_xmlFiles
	./generate_csv_multiple 1 10 1E_xmlFiles 1E_csvFiles
	python3 pruning_multiple.py 1 10 1E_csvFiles 1E_prunedResults 1E_prunedCSV

	./gen_xml_multiple_files4 1000 500 10 1A_xmlFiles
	./generate_csv_multiple 1 10 1A_xmlFiles 1A_csvFiles
	python3 pruning_multiple.py 1 10 1A_csvFiles 1A_prunedResults 1A_prunedCSV

	#2k Set 487 Estimated Fan out and 248 Actual Fan out
	./gen_xml_multiple_files4 2000 487 10 2E_xmlFiles
	./generate_csv_multiple 1 10 2E_xmlFiles 2E_csvFiles
	python3 pruning_multiple.py 1 10 2E_csvFiles 2E_prunedResults 2E_prunedCSV

	./gen_xml_multiple_files4 2000 248 10 2A_xmlFiles
	./generate_csv_multiple 1 10 2A_xmlFiles 2A_csvFiles
	python3 pruning_multiple.py 1 10 2A_csvFiles 2A_prunedResults 2A_prunedCSV

	#4k set 243 Estimated Fan out and 123 Actual Fan out
	./gen_xml_multiple_files4 4000 243 10 4E_xmlFiles
	./generate_csv_multiple 1 10 4E_xmlFiles 4E_csvFiles
	python3 pruning_multiple.py 1 10 4E_csvFiles 4E_prunedResults 4E_prunedCSV

	./gen_xml_multiple_files4 4000 123 10 4A_xmlFiles
	./generate_csv_multiple 1 10 4A_xmlFiles 4A_csvFiles
	python3 pruning_multiple.py 1 10 4A_csvFiles 4A_prunedResults 4A_prunedCSV

	#8k set 121 Estimated Fan out and 61 Actual Fan out
	./gen_xml_multiple_files4 8000 121 10 8E_xmlFiles
	./generate_csv_multiple 1 10 8E_xmlFiles 8E_csvFiles
	python3 pruning_multiple.py 1 10 8E_csvFiles 8E_prunedResults 8E_prunedCSV

	./gen_xml_multiple_files4 8000 61 10 8A_xmlFiles
	./generate_csv_multiple 1 10 8A_xmlFiles 8A_csvFiles
	python3 pruning_multiple.py 1 10 8A_csvFiles 8A_prunedResults 8A_prunedCSV

	#16k set 60 Estimated Fan out and 30 Actual Fan out
	./gen_xml_multiple_files4 16000 60 10 16E_xmlFiles
	./generate_csv_multiple 1 10 16E_xmlFiles 16E_csvFiles
	python3 pruning_multiple.py 1 10 16E_csvFiles 16E_prunedResults 16E_prunedCSV

	./gen_xml_multiple_files4 16000 30 10 16A_xmlFiles
	./generate_csv_multiple 1 10 16A_xmlFiles 16A_csvFiles
	python3 pruning_multiple.py 1 10 16A_csvFiles 16A_prunedResults 16A_prunedCSV

	#32k set 29 Estimated Fan out and 14 Actual Fan out
	./gen_xml_multiple_files4 32000 29 10 32E_xmlFiles
	./generate_csv_multiple 1 10 32E_xmlFiles 32E_csvFiles
	python3 pruning_multiple.py 1 10 32E_csvFiles 32E_prunedResults 32E_prunedCSV

	./gen_xml_multiple_files4 32000 14 10 32A_xmlFiles
	./generate_csv_multiple 1 10 32A_xmlFiles 32A_csvFiles
	python3 pruning_multiple.py 1 10 32A_csvFiles 32A_prunedResults 32A_prunedCSV

	#64k set 14 Estimated Fan out and 7 Actual Fan out
	./gen_xml_multiple_files4 64000 14 10 64E_xmlFiles
	./generate_csv_multiple 1 10 64E_xmlFiles 64E_csvFiles
	python3 pruning_multiple.py 1 10 64E_csvFiles 64E_prunedResults 64E_prunedCSV

	./gen_xml_multiple_files4 64000 7 10 64A_xmlFiles
	./generate_csv_multiple 1 10 64A_xmlFiles 64A_csvFiles
	python3 pruning_multiple.py 1 10 64A_csvFiles 64A_prunedResults 64A_prunedCSV

prunedmif:
	python3 gen_mif_multiple_files.py 1 10 1E_prunedCSV 1E_prunedMIF
	python3 gen_mif_multiple_files.py 1 10 1A_prunedCSV 1A_prunedMIF
	
	python3 gen_mif_multiple_files.py 1 10 2E_prunedCSV 2E_prunedMIF
	python3 gen_mif_multiple_files.py 1 10 2A_prunedCSV 2A_prunedMIF
	
	python3 gen_mif_multiple_files.py 1 10 4E_prunedCSV 4E_prunedMIF
	python3 gen_mif_multiple_files.py 1 10 4A_prunedCSV 4A_prunedMIF
	
	python3 gen_mif_multiple_files.py 1 10 8E_prunedCSV 8E_prunedMIF
	python3 gen_mif_multiple_files.py 1 10 8A_prunedCSV 8A_prunedMIF
	
	python3 gen_mif_multiple_files.py 1 10 16E_prunedCSV 16E_prunedMIF
	python3 gen_mif_multiple_files.py 1 10 16A_prunedCSV 16A_prunedMIF
	
	python3 gen_mif_multiple_files.py 1 10 32E_prunedCSV 32E_prunedMIF
	python3 gen_mif_multiple_files.py 1 10 32A_prunedCSV 32A_prunedMIF
	
	python3 gen_mif_multiple_files.py 1 10 64E_prunedCSV 64E_prunedMIF
	python3 gen_mif_multiple_files.py 1 10 64A_prunedCSV 64A_prunedMIF

beforemif:
	python3 gen_mif_multiple_files.py 1 10 1E_csvFiles 1E_MIFFile
	python3 gen_mif_multiple_files.py 1 10 1A_csvFiles 1A_MIFFile
	
	python3 gen_mif_multiple_files.py 1 10 2E_csvFiles 2E_MIFFile
	python3 gen_mif_multiple_files.py 1 10 2A_csvFiles 2A_MIFFile
	
	python3 gen_mif_multiple_files.py 1 10 4E_csvFiles 4E_MIFFile
	python3 gen_mif_multiple_files.py 1 10 4A_csvFiles 4A_MIFFile
	
	python3 gen_mif_multiple_files.py 1 10 8E_csvFiles 8E_MIFFile
	python3 gen_mif_multiple_files.py 1 10 8A_csvFiles 8A_MIFFile
	
	python3 gen_mif_multiple_files.py 1 10 16E_csvFiles 16E_MIFFile
	python3 gen_mif_multiple_files.py 1 10 16A_csvFiles 16A_MIFFile
	
	python3 gen_mif_multiple_files.py 1 10 32E_csvFiles 32E_MIFFile
	python3 gen_mif_multiple_files.py 1 10 32A_csvFiles 32A_MIFFile
	
	python3 gen_mif_multiple_files.py 1 10 64E_csvFiles 64E_MIFFile
	python3 gen_mif_multiple_files.py 1 10 64A_csvFiles 64A_MIFFile

# Rule for new2_xml_csv_degree

new2_xml_csv_degree: new2_xml_csv_degree.cpp

	g++ -std=c++11 new2_xml_csv_degree.cpp -o generate_csv_multiple -ltinyxml2
 
# Rule for gen_xml_multiple_files4
	
gen_xml_multiple_files4: gen_xml_multiple_files4.cpp

	$(CXX) -o gen_xml_multiple_files4 gen_xml_multiple_files4.cpp -I/usr/include/tinyxml2 -ltinyxml2 -lstdc++fs -std=c++17

# Clean rule

clean:

	rm -f gen_xml_multiple_files4 generate_csv_multiple 

# 1k sets
	rm -r 1E_xmlFiles 1E_csvFiles 1E_prunedResults 1E_prunedCSV 1E_prunedMIF 1E_MIFFile 1A_xmlFiles 1A_csvFiles 1A_prunedResults 1A_prunedCSV 1A_prunedMIF 1A_MIFFile

# 2k sets
	rm -r 2E_xmlFiles 2E_csvFiles 2E_prunedResults 2E_prunedCSV 2E_prunedMIF 2E_MIFFile 2A_xmlFiles 2A_csvFiles 2A_prunedResults 2A_prunedCSV 2A_prunedMIF 2A_MIFFile

# 4k sets
	rm -r 4E_xmlFiles 4E_csvFiles 4E_prunedResults 4E_prunedCSV 4E_prunedMIF 4E_MIFFile 4A_xmlFiles 4A_csvFiles 4A_prunedResults 4A_prunedCSV 4A_prunedMIF 4A_MIFFile

# 8k sets
	rm -r 8E_xmlFiles 8E_csvFiles 8E_prunedResults 8E_prunedCSV 8E_prunedMIF 8E_MIFFile 8A_xmlFiles 8A_csvFiles 8A_prunedResults 8A_prunedCSV 8A_prunedMIF 8A_MIFFile

# 16k sets
	rm -r 16E_xmlFiles 16E_csvFiles 16E_prunedResults 16E_prunedCSV 16E_prunedMIF 16E_MIFFile 16A_xmlFiles 16A_csvFiles 16A_prunedResults 16A_prunedCSV 16A_prunedMIF 16A_MIFFile

# 32k sets
	rm -r 32E_xmlFiles 32E_csvFiles 32E_prunedResults 32E_prunedCSV 32E_prunedMIF 32E_MIFFile 32A_xmlFiles 32A_csvFiles 32A_prunedResults 32A_prunedCSV 32A_prunedMIF 32A_MIFFile

# 64k sets
	rm -r 64E_xmlFiles 64E_csvFiles 64E_prunedResults 64E_prunedCSV 64E_prunedMIF 64E_MIFFile 64A_xmlFiles 64A_csvFiles 64A_prunedResults 64A_prunedCSV 64A_prunedMIF 64A_MIFFile
