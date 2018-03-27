<html>

<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>

<body>
    <div class="p-3 mb-2 bg-dark text-white">
        <div class="container">
            <div class="p-3 mb-2 bg-light text-dark">
                <h2>Simulated Page Allocation Manager</h2>
                <div class="row">
                    <div class="col-md">
                        <div class="form-group">
                            <label>Instructions:</label>
                            <hr>
                            <textarea class="form-control" rows="13" id="instructions" readonly="readonly"></textarea>
                        </div>
                        <label>Input File:</label>
                        <input id="input" type="input" onchange="readTextFile();">


                    </div>
                    <div class="col-md">
                        <label>Memory:</label>
                        <hr>
                        <div class="card" style="width: 18rem;">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item" id="0">Free</li>
                                <li class="list-group-item" id="1">Free</li>
                                <li class="list-group-item" id="2">Free</li>
                                <li class="list-group-item" id="3">Free</li>
                                <li class="list-group-item" id="4">Free</li>
                                <li class="list-group-item" id="5">Free</li>
                                <li class="list-group-item" id="6">Free</li>
                                <li class="list-group-item" id="7">Free</li>

                            </ul>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg">
                        <div class="form-group">
                            <label>Output:</label>
                            <textarea class="form-control" rows="12" id="output" readonly="readonly"></textarea>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <button type="button" class="btn btn-primary btn-lg btn-block" onclick="StepInstruction();">Step Instructions</button>
                </div>
            </div>
        </div>
    </div>
</body>

<script>
    var allText = "";
    var stepCounter = 0;
    var numFrames = 8;
    var InstructionsArray;
    var framesArray;
    var codePageTable = [];
    var dataPageTable = [];

    function readTextFile() {
        file = document.getElementById("input").value;
        var rawFile = new XMLHttpRequest();
        rawFile.open("GET", file, false);
        rawFile.onreadystatechange = function() {
            if (rawFile.readyState === 4) {
                if (rawFile.status === 200 || rawFile.status == 0) {
                    allText = rawFile.responseText;
                    //write input to instructions field
                    document.getElementById("instructions").innerHTML = allText;
                    var TempArray = allText.split("\n");

                    //create 2d array for input
                    InstructionsArray = new Array(TempArray.length);
                    for (var i = 0; i < TempArray.length; i++) {
                        InstructionsArray[i] = TempArray[i].split(" ");
                    }

                    framesArray = new Array(numFrames);
                    for (var i = 0; i < numFrames; i++) {
                        framesArray[i] = "Free"
                    }
                }
            }
        }
        rawFile.send(null);
    }

    function StepInstruction() {
        //check if instructions are done
        if (InstructionsArray[stepCounter] == undefined) {
            document.getElementById("output").innerHTML += "Instructions Completed" + '\n';
        } else {
            //Check for -1 (end of program)
            if (InstructionsArray[stepCounter][1] == -1) {
                document.getElementById("output").innerHTML += "Deleting Process: " + InstructionsArray[stepCounter][0] + '\n';

                //reset data frames
                for (var i = 0; i <= dataPageTable[InstructionsArray[stepCounter][0]].length; i++) {
                    position = dataPageTable[InstructionsArray[stepCounter][0]][i];
                    framesArray[position] = "Free";
                }
                //reset code frames
                for (var i = 0; i <= codePageTable[InstructionsArray[stepCounter][0]].length; i++) {
                    position = codePageTable[InstructionsArray[stepCounter][0]][i];
                    framesArray[position] = "Free";
                }


            }
            //allocate memory frames
            else {
                //instantiate the PageTable arrays
                codePageTable[InstructionsArray[stepCounter][0]] = [];
                dataPageTable[InstructionsArray[stepCounter][0]] = [];

                var codepages = Math.ceil(Number(InstructionsArray[stepCounter][1]) / 512);
                var datapages = Math.ceil(Number(InstructionsArray[stepCounter][2]) / 512);

                document.getElementById("output").innerHTML += "Loading program: " + InstructionsArray[stepCounter][0] + " into RAM: Code=" + InstructionsArray[stepCounter][1] + " ( " + codepages + " pages), Data=" + InstructionsArray[stepCounter][2] + " (" + datapages + " pages)" + '\n';

                //set frames for code
                for (var i = 1; i <= codepages; i++) {
                    position = framesArray.indexOf("Free");
                    framesArray[position] = "Code " + i + " of P" + InstructionsArray[stepCounter][0];

                    codePageTable[InstructionsArray[stepCounter][0]].push(position);
                }
                //set frames for data
                for (var i = 1; i <= datapages; i++) {
                    position = framesArray.indexOf("Free");
                    framesArray[position] = "Data " + i + " of P" + InstructionsArray[stepCounter][0];

                    dataPageTable[InstructionsArray[stepCounter][0]].push(position);
                }

            }
            //increment Instruction Counter    
            stepCounter = stepCounter + 1;
        }
        //update memory diagram
        for (var i = 0; i < numFrames; i++) {
            var temp = i.toString();
            document.getElementById(temp).innerHTML = framesArray[i];
        }
    }

</script>
<footer>
    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</footer>

</html>
