<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="QandA.aspx.cs" Inherits="DevelopersGuide.QandA" %>

<asp:Content runat="server" ID="headQandA" ContentPlaceHolderID="HeadContent">

    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.0/themes/base/jquery-ui.css" />
    <script src="Scripts/jquery-1.8.2.min.js"></script>
    <script src="Scripts/jquery-ui-1.8.24.min.js"></script>
    <script src="Scripts/Cytoscope/cytoscape.min.js"></script>
    <script src="Scripts/Cytoscope/dagre.min.js"></script>
    <script src="Scripts/Cytoscope/cytoscape-dagre.js"></script>
    <script src="Scripts/ProseedQnAScript.js"></script>
    <link href="Content/ProseedQnAStyle.css" rel="stylesheet" />

    <script type="text/javascript">
        var scenario = '<%= (System.Web.HttpContext.Current.Request["feature"] as string)%>';

        $(document).ready(function () { $('#download-buttons').show(); });

    </script>

</asp:Content>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <div id="cy"></div>

    <div id="divAnswerContainer">
        <textarea id="tbAnswers" rows="5" style="width: 96%"></textarea>
        <input type="button" value="Add more answers" onclick="addAndContinueClick()" style="float: left" />
        <input id="btnProceedQue" type="button" value="Proceed to next question" onclick="addToTreeClick()" style="float: left" />
        <input type="button" value="Delete" onclick="deleteNode()" style="float: left" />

    </div>

    <div id="divTooltip" style="display:none">tooltip</div>
    <div id="divDeleteContainer">
        <input type="button" value="Delete" onclick="deleteNode()" />
    </div>
<%--  <img id="jpg-eg" width="500" height="500"/>--%>
</asp:Content>
