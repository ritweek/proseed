<%@ Page Language="" AutoEventWireup="false" CodeBehind="CytoscopeSample.aspx.vb" Inherits="App.CytoscopeSample" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <link  rel="stylesheet" href="//code.jquery.com/ui/1.12.0/themes/base/jquery-ui.css" />
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
            font-size: 0.5em;
        }
        #oval {
	width: 200px;
	height: 100px;
	background: red;
	-moz-border-radius: 100px / 50px;
	 -webkit-border-radius: 100px / 50px;
	  border-radius: 100px / 50px;
      }

    </style>    <script type="text/javascript">
        var cy;
        $(function () {
            $('#divAnswerContainer').dialog({
                autoOpen: false,
                width: 400,
                modal: true
            });
            debugger;
            cy = window.cy = cytoscape({
                container: document.getElementById('cy'),

                boxSelectionEnabled: false,
                autounselectify: true,

                layout: {
                    name: 'preset'
                },

                position: { // the model position of the node (optional on init, mandatory after)
                    x: 100,
                    y: 100
                },

                style: [
                    {
                        selector: 'node',
                        style: {
                            'content': 'data(id)',
                            'text-opacity': 0.5,
                            'text-valign': 'center',
                            'text-halign': 'center',
                            'background-color': '#ffcccc',
                            'compoundSize': 'auto',
                            'label' : 'flksjdflksjdflj',
                            'continuousMapper': {
                                attrName: "tbAnswers",
                                minValue: 12,
                                maxValue: 36
                            },
                            shape: 'rectangle'
                        }
                    },

                    {
                        selector: 'edge',
                        style: {
                            
                            'target-arrow-shape': 'triangle',
                            'line-color': '#9dbaea',
                            'target-arrow-color': '#9dbaea',
                            'compoundSize': 'auto',
                            shape: 'rectangle'
                        }
                    }
                ],

                elements: {
                    nodes: [
                        {
                            data: { id: 'Node1' }, renderedPosition: { x: 100, y: 100 }, continuousMapper: {
                                attrName: "tbAnswers",
                            minValue: 12, 
                            maxValue: 36 }, compoundSize: 'auto' ,tooltipText: "<b>${label}</b>: ${tbAnswers}", }

                    ]

                },
            });

            cy.on('click', 'node', function (evt) {
                debugger;
                $("#divAnswerContainer").dialog('open');
            });
        });

        //var e = jQuery.Event("click");
        //alert(e.cyTarget);
        // trigger an artificial click event
        //cy.on('click', 'node', function (evt) {
        //    console.log('clicked ' + this.id());
        //});        function addButtonClick() {
            var answer = $("#tbAnswers").val();
            cy.add([
            { group: "nodes", data: { id: answer }, renderedPosition: { x: 500, y: 200 } },
            { group: "edges", data: { id: answer + 'Node1', source: 'parentId', target: answer } }]);
            $("#tbAnswers").val('');
            $("#divAnswerContainer").dialog('close');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="cy"></div>        <div id="divAnswerContainer">
            <textarea id="tbAnswers" rows="5" cols="100" ></textarea>
            <input type="button" value="Click to Add to Tree" onclick="addButtonClick()" />
        </div>
    </form>
</body>
</html>
