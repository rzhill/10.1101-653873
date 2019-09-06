//RoseZHill-rzhill@berkeley.edu
//This script is used in FIJI to quantify % area innervated in whole mount skin samples from confocal z-stacks.
input = "/directory/" //keep slash, change folder name
output = "" //extraneous, can implement if you want to save results and such to a separate folder, or save intermediate windows like binary files.
suffix = ".czi" //czi files
blobsize = "5-Infinity"
//also consider changing circularity setting depending upon analysis
setBatchMode(true); //run with batch mode on false on first file to test

processFolder(input);

function processFolder(input) { //give folder as input
	list = getFileList(input); //list files in directory
	for (i = 0; i < list.length; i++) { //for all files in directory, iterate one by one
		if(File.isDirectory(input + list[i])); //if the file is actually a directory, process that subfolder
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix)) //if the file ends with your chosen file extension, do process
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	run("Bio-Formats Importer", "open=" + input+ file + " autoscale color_mode=Default rois_import=[ROI manager] split_channels view=[Standard ImageJ] stack_order=Default"); //open the confocal file
	name = File.name(); //give the file a name
	betatubulin = name + " - C=0"; //name channel 0
	selectWindow(betatubulin);//select channel 0
	run("Despeckle", "stack"); //Despeckle
	run("Z Project...", "projection=[Max Intensity]"); //make a max intensity z project
	title = getTitle(); //get the window title for the max intensity proj.
	saveAs("Tiff", input + file + "betatubulin" + "_MAX.tif"); //save the projection
	run("Find Edges"); //find neurites
	setOption("BlackBackground", false);
	run("Make Binary"); //convert edges to bin file
	title = getTitle(); //get bin file title
	saveAs("Tiff", input + file + "betatubulin" + "_MAX_binary.tif"); //save bin as tiff
	run("Analyze Particles...", "size=" + blobsize + " show=Outlines display clear summarize"); //analyze the bin file (make sure to set the particle size above)
	saveAs("Tiff", input + file + "betatubulin" + "_MAX_binary_particles.tif"); //save the particle analysis tiff
	selectWindow("Results");
	saveAs("Measurements", input + file + "betatubulin" + "_Results.csv"); //save region results
	selectWindow("Results");
	saveAs("Measurements", input + file + "nefH" + "_Results.csv");
	selectWindow("Summary"); //select the ouput summary window
	saveAs("Text", input + file + "_Summary.txt"); //save as a text file
	print("Processing: " + input + file); // print message to user
	print("Saving to: " + output); //can define a separate output directory above but not necessary
	run("Close All"); // close all open images so the function can iterate over the next file without throwing errors
}

