
var clickedNodeX;
var clickedNodeY;
var currentAddedNodeY;
var cy;
var masterParentID = 'Scenario';
var parentId;
var questionIndex = 0;
var animation;
var xPositionIncrement = 0;
var yPositionIncrement = 200;
var questions = [" What’s the minimum thing that needs to be done?",
    "What are the prerequisites?",
    "What are the dependencies?",
    "What are the inputs we need?",
    "How should we trust the inputs?",
    "What authentication needs to be present?",
    "What authorization needs to be present?",
    "What about performance requirements?",
    " What exception scenarios need to be handled?",
    "What connections should be opened and released?",
    "What boundary conditions we need to focus on?"];

$(function () {
    $('#divAnswerContainer').dialog({
        autoOpen: false,
        width: 500,
        modal: true,
        resizable: false,
        title: 'Action'
    });

    $('#divDeleteContainer').dialog({
        autoOpen: false,
        width: 400,
        modal: true
    });

    cy = cytoscape({
        container: $('#cy')[0],
        boxSelectionEnabled: false,
        autounselectify: true,
        style: cytoscape.stylesheet()
          .selector('node')
            .css({
                'content': 'data(name)',
                'text-valign': 'center',
                'color': 'black',
                'background-color': 'lightblue',
                'text-wrap': 'wrap',
                'text-max-width': '175px',
                'text-outline-width': 0,
                'font-size': 22,
                'word-break': 'break-all'

            })
            .selector('edge')
            .css({
                'target-arrow-shape': 'triangle',
                'line-color': '#9dbaea',
                'target-arrow-color': '#9dbaea'
            })
          .selector(':selected')
            .css({
                'background-color': 'black',
                'line-color': 'black',
                'target-arrow-color': 'black',
                'source-arrow-color': 'black',
                'text-outline-color': 'black'
            }),

        zoom: 1.5,
        zoom: 1,
        pan: { x: 0, y: 0 },

        // interaction options:
        minZoom: 1e-50,
        maxZoom: 1e50,
        zoomingEnabled: true,
        userZoomingEnabled: true,
        layout: {
            name: 'dagre',
            padding: 10
        }
    });
    cy.add([
        {
            group: "nodes", data: { id: 'Scenario', sno: 1, name: scenario, nodeType: 'Scenario', parentId: '', questionIndex: 0 },
            renderedPosition: { x: 950, y: 70 },
            style: {
                shape: 'oval',
                width: 300,
                height: 50
            }
        }
    ]);

    cy.on('click', 'node', function (evt) {
        parentId = this.data('id');

        if (!parentId.includes('Answer')) {

            var newId = parentId.slice(-1);

            questionIndex = cy.filter("node[nodeType='Question']").select().length; // to pick next question from array

            clickedNodeX = this.renderedPosition().x;
            clickedNodeY = this.renderedPosition().y;
            if (this.data('nodeType') == 'Question') {

                $("#divAnswerContainer").dialog('open');

                if (cy.filter("node[nodeType='Question']").select().length == questions.length) {
                    btnProceedQue.style.display = 'none';
                }
                else {
                    btnProceedQue.style.display = 'block';
                }

            } else if (this.data('nodeType') == 'Scenario') {
                addQuestion(300 + xPositionIncrement, yPositionIncrement, questionIndex, masterParentID);
                xPositionIncrement = xPositionIncrement + 300;
            }
            else if (this.data('nodeType') == 'Answer') {
                addQuestion(clickedNodeX, clickedNodeY+200, newId, masterParentID);
            }
        }

        else {
            $("#divDeleteContainer").dialog('open');
        }
    });

    animation = cy.animation({
        style: {
            'background-color': 'red',
            'width': 75
        },
        duration: 1000
    });

    //cy.on('mouseover', 'node', function (evt) {

    //    if (this.data('id').includes('Answer') && this.data('tooltipText').length > 15) {

    //        var ans = this.data('tooltipText');
    //        $("#divTooltip").text(ans);
    //        $('#divTooltip').css('top', evt.originalEvent.clientY +"px");
    //        $('#divTooltip').css('left', evt.originalEvent.clientX + "px");
    //        $('#divTooltip').css('position', 'absolute');
    //        $("#divTooltip").show();
    //    }
    //});

    //cy.on('mouseout', 'node', function (evt) {

    //    if (this.data('id').includes('Answer')) {

    //        var ans = this.data('tooltipText');
    //        $("#divTooltip").hide();
    //    }
    //});
});

function rearrangeNodes() {

    cy.$('node').each(function () {
        var nodeY = this.renderedPosition('y');
        if (nodeY > currentAddedNodeY)
            this.renderedPosition('y', nodeY + 100);
    });
}

function addToTreeClick() {

    var answer = $("#tbAnswers").val();
    if (answer.length > 0) {
        addAnswer();

        var questionNodeLength = cy.filter("node[parentId='" + masterParentID + "']").filter("node[nodeType='Question']").select().length;

        addQuestion(300 +xPositionIncrement, yPositionIncrement, questionIndex, masterParentID);

        $("#tbAnswers").val('');
        $("#divAnswerContainer").dialog('close');
    }
    else
    {
        addQuestion(300 +xPositionIncrement, yPositionIncrement, questionIndex, masterParentID);
        $("#tbAnswers").val('');
        $("#divAnswerContainer").dialog('close');
    }
}

function addAndContinueClick() {

    var answer = $("#tbAnswers").val();

    if (answer.length > 330) {
        alert('Only 330 characters are allowed.');
        return false;
    }

    if (answer.length <= 0) {
        alert('Please enter your answer.');
        return false;
    }
    addAnswer();
    $("#tbAnswers").val('');
}

function addQuestion(positionX, positionY, questionIndex, masterParentID) {

    // Work in PROGRESS
    // Do not generate new question, when there are questions un-answered on canvas
    ////var numQues = cy.filter("node[nodeType='Question']").select().length;
    ////for (var i = 0; i < numQues; i++) {
    ////    var node = cy.filter("node[nodeType='Question']").select()[i];
    ////    if (node.filter("node[nodeType='Answer']").select().length == 0) {
    ////        // Alert user to answer existing question first, before adding new question
    ////        return;
    ////    }
    ////}

    var questionNodeLength = cy.filter("node[nodeType='Question']").select().length;
    var answerNodeLength = cy.filter("node[nodeType='Answer']").select().length;
    var questionId = "Question" + (questionNodeLength + 1);
    var flag = 0;

    var childNodeLength = cy.filter("node[parentId='" + masterParentID + "']").filter("node[nodeType='Question']").select().length;
    if (questions[questionIndex] != undefined) {
        parentId = masterParentID;

        cy.add([{

            group: "nodes", data: { id: questionId, parentId: parentId, sno: questionNodeLength + 1, questionIndex: questionIndex, nodeType: 'Question', name: questions[questionIndex] }, renderedPosition: { x: positionX, y: positionY }, style: {
                shape: 'diamond',
                'background-color': '#FFA500',
                'font-size': 15,
                width: 225,
                height: 90
            }
        },
        { group: "edges", data: { id: 'QuestionQuestionEdge' + (questionNodeLength + answerNodeLength), source: parentId, target: questionId } }
        ]);
    }
    currentAddedNodeY = positionY;
}

function addAnswer() {

    var answer = $("#tbAnswers").val();
    var answerLength = $("#tbAnswers").val().length;
    var questionNodeLength = cy.filter("node[nodeType='Question']").select().length;
    var answerNodeLength = cy.filter("node[nodeType='Answer']").select().length;
    var answerId = "Answer" + (answerNodeLength + 1);
    var childNodeLength = cy.filter("node[parentId='" + parentId + "']").select().length;
    var positionY = clickedNodeY + (childNodeLength > 0 ? 100 * childNodeLength : 0);
    var dummyAnswer = '';
    if (answerLength > 15) {

        for(var i=0; i< answerLength / 15; i++)
        {
            var j= i*15;
            dummyAnswer = dummyAnswer + answer.substring(j,j+15) + "\n";
            
        }
        //dummyAnswer = answer.substring(0, 15) + "\n" + answer.substring(16);
    }
    else
        dummyAnswer = answer;

    cy.add([
    {
        group: "nodes", data: {
            id: answerId,
            sno: answerNodeLength + 1,
            parentId: parentId,
            nodeType: 'Answer',
            name: dummyAnswer,
            tooltipText: answer
        },
        renderedPosition: { x: clickedNodeX, y: positionY + 150 }, style: {
            shape: 'roundrectangle',
            'background-color': 'pink',
            'font-size': 15,
            width: 175,
            height: 50*(answerLength/30) +5,
            'word-break': 'break-all'
        }
    },
    { group: "edges", data: { id: 'QuestionAnswerEdge' + (questionNodeLength + answerNodeLength), source: parentId, target: answerId } }]);
    currentAddedNodeY = positionY;
}

function deleteNode() {

    if (parentId.includes('Question')) {
        var numAnswers = cy.filter("node[parentId='" + parentId + "']").filter("node[nodeType='Answer']").select().length;
        positionIncrement = positionIncrement - 200;
        for (var i = 0; i < numAnswers; i++) {
            cy.remove(cy.filter("node[parentId='" + parentId + "']").filter("node[nodeType='Answer']").select()[0]);
        }
    }

    var deleteNode = cy.$("#" + parentId);
    cy.remove(deleteNode);
    $("#divDeleteContainer").dialog('close');
    $("#divAnswerContainer").dialog('close');
}

function saveAsJPEG() {
    debugger
    var jpg64 = cy.jpg({ full: true });
    //$('<a id="testAnchor" href="' + jpg64 + ' download"></a>');
    //$('#testAnchor').attr('href', jpg64);
    //$('#testAnchor').click();
    var url = jpg64.replace('data:image/jpeg', 'data:application/octet-stream;filename=file.png');
    window.open(url);
}

function saveAsPNG() {
    var png64 = cy.png({ full: true });
    //var url = png64.replace(/^data:image\/[^;]/, 'data:application/octet-stream');
    window.open(png64);
}