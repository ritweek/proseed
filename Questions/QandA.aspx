<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="QandA.aspx.cs" Inherits="Questions.QandA" %>


<asp:Content runat="server" ID="headQandA" ContentPlaceHolderID="HeadContent">

    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.0/themes/base/jquery-ui.css" />
    <script src="Scripts/jquery-1.8.2.min.js"></script>
    <script src="Scripts/jquery-ui-1.8.24.min.js"></script>
    <script src="Scripts/Cytoscope/cytoscape.min.js"></script>
    <script src="Scripts/Cytoscope/dagre.min.js"></script>
    <script src="Scripts/Cytoscope/cytoscape-dagre.js"></script>

    <style>
        body {
            font-family: helvetica;
            font-size: 14px;
        }

        #cy {
            width: 100%;
            height: 100%;
            position: absolute;
            left: 0;
            top: 0;
            z-index: 999;
        }

        h1 {
            opacity: 0.5;
            font-size: 1em;
        }
    </style>
    <script type="text/javascript">
        var clickedNodeX;
        var clickedNodeY;
        var currentAddedNodeY;
        var cy;
        var masterParentID = 'Scenario';
        var parentId;
        var questionIndex = 0;
        var animation;
        var positionIncrement = 0;
        var questions = ["List all the pre-requisites and dependencies",
            "What are all the input variables?",
            "What are the exceptions you want to handle?",
            "How do you plan to exit?"];

        var scenario = '<%= (System.Web.HttpContext.Current.Request["feature"] as string)%>';

        $(function () {
            $('#divAnswerContainer').dialog({
                autoOpen: false,
                width: 400,
                modal: true,
                resizable: false,
                title: 'Action'
            });

            $('#divDeleteContainer').dialog({
                autoOpen: false,
                width: 400,
                modal: true
            });

            $('#divTooltip').dialog({
                autoOpen: false,
                width: 400,
                modal: false,
                resizable: false
                //closeButton: flase
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
                        'background-color': '#ffcccc',
                        'text-wrap': 'wrap',
                        'text-max-width': '175px',
                        'text-outline-width': 0,
                        'font-size': 12,
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
                    renderedPosition: { x: 950, y: 175 },
                    style: {
                        shape: 'roundrectangle',
                        width: 300,
                        height: 50
                    }
                }
            ]);


            cy.on('click', 'node', function (evt) {
                parentId = this.data('id');

                if (!parentId.includes('Answer')) {

                    var newId = parentId.slice(-1);

                    //*han commented to avoid adding same first question everytime root is clicked. 
                    ////questionIndex = this.data('questionIndex');

                    questionIndex = cy.filter("node[nodeType='Question']").select().length; // to pick next question from array

                    clickedNodeX = this.renderedPosition().x;
                    clickedNodeY = this.renderedPosition().y;
                    if (this.data('nodeType') == 'Question') {

                        $("#divAnswerContainer").dialog('open');

                        if (cy.filter("node[nodeType='Question']").select().length == questions.length) {
                            debugger;
                            btnProceedQue.style.display = 'none';
                        }
                        else {
                            btnProceedQue.style.display = 'block';
                        }

                    } else if (this.data('nodeType') == 'Scenario') {
                        //addQuestion(200, 200, 0, masterParentID);
                        addQuestion(200 + positionIncrement, 200 + positionIncrement, questionIndex, masterParentID);
                        positionIncrement = positionIncrement + 200;
                    }
                    else if (this.data('nodeType') == 'Answer') {
                        addQuestion(clickedNodeX + 300, clickedNodeY, newId, masterParentID);
                    }
                }

                else {
                    $("#divTooltip").dialog('close');
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


            cy.on('mouseover', 'node', function (evt) {
                // debugger;

                if (this.data('id').includes('Answer') && this.data('tooltipText').length>20) {

                    var ans = this.data('tooltipText');
                    $("#divTooltip").dialog('open');
                    $("#divTooltip").text(ans);

                    // auto disappear after some time
                    setTimeout(closeOriginalAns, 5000);

                }

            });

            cy.on('mouseout', 'node', function (evt) {
                //debugger;

                if (this.data('id').includes('Answer')) {

                    var ans = this.data('tooltipText');
                    $("#divTooltip").dialog('close');

                }

            });
        });

        //var e = jQuery.Event("click");
        //alert(e.cyTarget);
        // trigger an artificial click event
        //cy.on('click', 'node', function (evt) {
        //    console.log('clicked ' + this.id());
        //});

        function closeOriginalAns() {
            $("#divTooltip").dialog('close');

        }

        function rearrangeNodes() {

            cy.$('node').each(function () {
                var nodeY = this.renderedPosition('y');
                if (nodeY > currentAddedNodeY)
                    this.renderedPosition('y', nodeY + 100);
            });
        }
        function addToTreeClick() {

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

            ////var questionNodeLength = cy.filter("node[parentId='" + parentId + "']").filter("node[nodeType='Question']").select().length;
            // *han added fix to relate all new questions to root instead of recent questions 
            var questionNodeLength = cy.filter("node[parentId='" + masterParentID + "']").filter("node[nodeType='Question']").select().length;

            //addQuestion(clickedNodeX, clickedNodeY + 100, questionIndex + 1, masterParentID);
            addQuestion(clickedNodeX, clickedNodeY + 100, questionIndex, masterParentID);

            $("#tbAnswers").val('');
            $("#divAnswerContainer").dialog('close');
            rearrangeNodes();
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
            rearrangeNodes();
        }

        function addQuestion(positionX, positionY, questionIndex, masterParentID) {

            debugger;
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

            //cy.filter("node[parentId='" + masterParentID + "']").filter("node[nodeType='Question']").select().length

            var questionNodeLength = cy.filter("node[nodeType='Question']").select().length;
            var answerNodeLength = cy.filter("node[nodeType='Answer']").select().length;
            var questionId = "Question" + (questionNodeLength + 1);
            //var childNodeLength = cy.filter("node[parentId='" + parentId + "']").filter("node[nodeType='Question']").select().length;

            //* han
            var childNodeLength = cy.filter("node[parentId='" + masterParentID + "']").filter("node[nodeType='Question']").select().length;
            //if (childNodeLength == 0 && questions[questionIndex] != undefined) {

            // han added
            if (questions[questionIndex] != undefined) {
                parentId = masterParentID;

                cy.add([{
                    //group: "nodes", data: { id: questionId, parentId: parentId, sno: questionNodeLength + 1, questionIndex: questionIndex, nodeType: 'Question', name: questions[questionIndex] }, renderedPosition: { x: positionX, y: positionY }, style: {

                    //*han added
                    group: "nodes", data: { id: questionId, parentId: parentId, sno: questionNodeLength + 1, questionIndex: questionIndex, nodeType: 'Question', name: questions[questionIndex] }, renderedPosition: { x: positionX, y: positionY }, style: {
                        shape: 'roundrectangle',
                        'background-color': '#FFA500',
                        width: 175,
                        height: 50
                    }
                },
                { group: "edges", data: { id: 'QuestionQuestionEdge' + (questionNodeLength + answerNodeLength), source: parentId, target: questionId } }
                ]);
            }
            currentAddedNodeY = positionY;
        }

        function addAnswer() {
            //debugger
            var answer = $("#tbAnswers").val();
            var answerLength = $("#tbAnswers").val().length;
            var questionNodeLength = cy.filter("node[nodeType='Question']").select().length;
            var answerNodeLength = cy.filter("node[nodeType='Answer']").select().length;
            var answerId = "Answer" + (answerNodeLength + 1);
            var childNodeLength = cy.filter("node[parentId='" + parentId + "']").select().length;
            var positionY = clickedNodeY + (childNodeLength > 0 ? 100 * childNodeLength : 0);
            var dummyAnswer = '';
            if (answerLength > 20) {
                //    alert('answer should have atleast one space');
                //    return false;
                dummyAnswer = answer.substring(0, 20) + "...";
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
                renderedPosition: { x: clickedNodeX + 300, y: positionY }, style: {
                    shape: 'roundrectangle',
                    'background-color': '#D3D3D3',
                    width: 175,
                    height: 50,
                    'word-break': 'break-all'


                }
            },
            { group: "edges", data: { id: 'QuestionAnswerEdge' + (questionNodeLength + answerNodeLength), source: parentId, target: answerId } }]);
            currentAddedNodeY = positionY;
        }


        ////function redrawClick() {
        ////    var layout = cy.makeLayout({ name: 'cose' });
        ////    layout.run();
        ////}

        function deleteNode() {
            //debugger;

            if (parentId.includes('Question')) {
                var numAnswers = cy.filter("node[parentId='" + parentId + "']").filter("node[nodeType='Answer']").select().length;
                for (var i = 0; i < numAnswers; i++) {
                    cy.remove(cy.filter("node[parentId='" + parentId + "']").filter("node[nodeType='Answer']").select()[0]);
                }
            }

            var deleteNode = cy.$("#" + parentId);
            cy.remove(deleteNode);
            $("#divDeleteContainer").dialog('close');
            $("#divAnswerContainer").dialog('close');

        }
    </script>

</asp:Content>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <div id="cy" style="width: 100%; height: 80%"></div>

    <div id="divAnswerContainer">
        <textarea id="tbAnswers" rows="5" style="width: 96%"></textarea>
        <input id="btnProceedQue" type="button" value="Proceed to next question" onclick="addToTreeClick()" />
        <input type="button" value="Add more answers" onclick="addAndContinueClick()" />
        <input type="button" value="Delete" onclick="deleteNode()" />
        <%--<input type="button" value="Restructure the Tree" onclick="redrawClick()" />--%>
    </div>
    <div id="divTooltip">
    </div>


    <div id="divDeleteContainer">
        <input type="button" value="Delete" onclick="deleteNode()" />
    </div>



</asp:Content>
