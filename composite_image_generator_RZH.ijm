//RoseZHill rzhill@berkeley.edu
//this script was used to generate composite images of the IHC data in this paper using FIJI
// lets you choose your folder
inputDir = getDirectory("Choose your input folder");
// makes a sub directory into your chosen folder
outputDir = inputDir + "results";
if(!File.exists(outputDir)) File.makeDirectory(outputDir);
// the highest number you expect
max = getNumber("How many images do you expect?", 10); //replace this with actual number of composites to generate
// lets you choose the naming of your files
cd45Name = getString("Whats the suffix of your CD45 images?", "C");
dapiName = getString("Whats the suffix of your DAPI images?", "D");
peripherinName = getString("Whats the suffix of your Peripherin images?", "P");
// a loop through your images... (1 ... max)
list = getFileList(inputDir);
for(i=0; i<list.length; i++){
	if(endsWith(list[i*3],"C.tif"));
		cd45 = list[i*3];
	if(endsWith(list[((i*3)+1)],"D.tif"));
		dapi = list[((i*3)+1)];
	if(endsWith(list[((i*3)+2)],"P.tif"));
		peripherin = list[((i*3)+2)];
	if(File.exists(inputDir + cd45) && File.exists(inputDir + dapi) && File.exists(inputDir + peripherin));

// only proceeds if both files are there
// opens the images and gives them temporary names
//adjust the min and max for the images
		open(inputDir + cd45);
		selectWindow(cd45);
		setMinAndMax(800,2000); //set the min and max
		rename("cd45");
		open(inputDir + dapi);
		selectWindow(dapi);
		setMinAndMax(500,800); //set the min and max
		rename("dapi");
		open(inputDir + peripherin);
		selectWindow(peripherin);
		setMinAndMax(300,1200); //set the min and max
		rename("peripherin");
// the next lines merge
		run("Merge Channels...", "c1=*None* c2=[peripherin] c3=[dapi] c4=*None* c5=*None* c6=[cd45] c7=*None* create keep" ); 
		rename(cd45+"_external"); 
		selectWindow(cd45 + "_external");
		run("Scale Bar...", "width=70 height=4 font=12 color=White background=None location=[Lower Right] bold hide overlay"); //adds 100 micron scale bar for 10x objective
		selectWindow(cd45 + "_external");
		run("RGB Color"); 
// saves the image
		saveAs("tiff", outputDir + "composite" + cd45);
		run("Close All");

}