//RoseZHill rzhill@berkeley.edu

//this script was used to quantify number of trigeminal ganglion cells expressing CD45 and peripherin from the IHC experiments in this paper
input = "/path/to/folder/" //keep slash, change folder name
output = "" //extraneous, can implement if you want to save results and such to a separate folder, or save intermediate windows like binary files.
suffix = ".tif" //czi files or tiff
blobsize_cd45 = "200-500" //parameters will change depending upon tissue
blobsize_dapi = "100-500"
blobsize_peripherin = "200-500"
circ = "0.1-1" //circularity value
//also consider changing circularity setting depending upon analysis
setBatchMode(true); //run with batch mode on false on first file to test

processFolder(input);

function processFolder(input) { //give folder as input
	list = getFileList(input); //list files in directory
	for (i = 0; i < list.length; i++) { //for all files in directory, iterate one by one
		if(File.isDirectory(input + list[i])); //if the file is actually a directory, process that subfolder
			processFolder("" + input + list[i]);
		if(endsWith(list[i], "C" + suffix)) //if the file ends with your chosen file extension, do process
			processFileCD45(input, output, list[i]);
			//cd45 processing
		else if(endsWith(list[i], "D" + suffix)) //if the file ends with your chosen file extension, do process
			processFileDAPI(input, output, list[i]);
			//dapi processing
		else if (endsWith(list[i], "P" + suffix)) //if the file ends with your chosen file extension, do process
			processFilePeripherin(input, output, list[i]);
			//peripherin processing
	}
}

function processFileCD45(input, output, file) {
	open(input + file);
	name = File.name(); //give the file a name
	selectWindow(name);//select channel 0
	setMinAndMax(1000, 1600); //replace these with your B&C min and max values
	title = getTitle(); //get the window title for the max intensity proj.
	saveAs("Tiff", input + file + "adjusted_cd45" + ".tif"); //save the projection
	setOption("BlackBackground", false);
	run("Make Binary");
	run("Options...", "iterations=1 count=1 pad do=Outline");
	run("Options...", "iterations=1 count=1 pad do=Dilate");
	run("Options...", "iterations=1 count=1 pad do=[Fill Holes]");
	title = getTitle(); //get bin file title
	saveAs("Tiff", input + file + "adjusted_cd45" + "_binary.tif"); //save bin as tiff
	run("Analyze Particles...", "size=" + blobsize_cd45 + "circularity=" + circ +" show=Overlay display clear include summarize add");
	saveAs("Tiff", input + file + "adjusted_cd45" + "_binary_particles.tif"); //save the particle analysis tiff
	selectWindow("Results");
	saveAs("Measurements", input + file + "_cd45_" + "_Results.csv"); //save region results
	roiManager("deselect"); 
    roiManager("save", input + file + "_cd45_" + "roi.zip"); 
	selectWindow("Summary"); //select the ouput summary window
	saveAs("Text", input + file + "cd45_Summary.txt"); //save as a text file
	print("Processing: " + input + file); // print message to user
	print("Saving to: " + output); //can define a separate output directory above but not necessary
	run("Close All"); // close all open images so the function can iterate over the next file without throwing errors
}

function processFileDAPI(input, output, file) {
	open(input + file);
	name = File.name(); //give the file a name
	selectWindow(name);//select channel 0
	setMinAndMax(500,800); //replace these with your B&C min and max values
	title = getTitle(); //get the window title for the max intensity proj.
	saveAs("Tiff", input + file + "adjusted_dapi" + ".tif"); //save the projection
	setOption("BlackBackground", false);
	run("Make Binary");
	run("Options...", "iterations=1 count=1 pad do=Outline");
	run("Options...", "iterations=1 count=1 pad do=Dilate");
	run("Options...", "iterations=1 count=1 pad do=Dilate");
	run("Options...", "iterations=1 count=1 pad do=[Fill Holes]");
	title = getTitle(); //get bin file title
	saveAs("Tiff", input + file + "adjusted_dapi" + "_binary.tif"); //save bin as tiff
	run("Analyze Particles...", "size=" + blobsize_dapi + "circularity=" + circ +" show=Overlay display clear include summarize add");
	saveAs("Tiff", input + file + "adjusted_dapi" + "_binary_particles.tif"); //save the particle analysis tiff
	selectWindow("Results");
	saveAs("Measurements", input + file + "_dapi_" + "_Results.csv"); //save region results
	roiManager("deselect"); 
    roiManager("save", input + file + "_dapi_" + "roi.zip"); 
	selectWindow("Summary"); //select the ouput summary window
	saveAs("Text", input + file + "dapi_Summary.txt"); //save as a text file
	print("Processing: " + input + file); // print message to user
	print("Saving to: " + output); //can define a separate output directory above but not necessary
	run("Close All"); // close all open images so the function can iterate over the next file without throwing errors
}

function processFilePeripherin(input, output, file) {
	open(input + file);
	name = File.name(); //give the file a name
	selectWindow(name);//select channel 0
	setMinAndMax(600, 1200); //replace these with your B&C min and max values
	title = getTitle(); //get the window title for the max intensity proj.
	saveAs("Tiff", input + file + "adjusted_peripherin" + ".tif"); //save the projection
	setOption("BlackBackground", false);
	run("Make Binary");
	run("Options...", "iterations=1 count=1 pad do=Outline");
	run("Options...", "iterations=1 count=1 pad do=Dilate");
	run("Options...", "iterations=1 count=1 pad do=Dilate");
	run("Options...", "iterations=1 count=1 pad do=[Fill Holes]");
	title = getTitle(); //get bin file title
	saveAs("Tiff", input + file + "adjusted_peripherin" + "_binary.tif"); //save bin as tiff
	run("Analyze Particles...", "size=" + blobsize_peripherin + "circularity=" + circ +" show=Overlay display clear include summarize add");
	saveAs("Tiff", input + file + "adjusted_peripherin" + "_binary_particles.tif"); //save the particle analysis tiff
	selectWindow("Results");
	saveAs("Measurements", input + file + "_peripherin_" + "_Results.csv"); //save region results
	roiManager("deselect"); 
    roiManager("save", input + file + "_peripherin_" + "roi.zip"); 
	selectWindow("Summary"); //select the ouput summary window
	saveAs("Text", input + file + "peripherin_Summary.txt"); //save as a text file
	print("Processing: " + input + file); // print message to user
	print("Saving to: " + output); //can define a separate output directory above but not necessary
	run("Close All"); // close all open images so the function can iterate over the next file without throwing errors
}
