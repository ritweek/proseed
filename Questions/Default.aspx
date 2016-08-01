<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Questions._Default" %>

<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
</asp:Content>
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <h2 >Guiding the developer to develop software features in a focused manner.</h2>

    <div>
        <h4>So, What you want to develop today?</h4>
        <asp:TextBox ID="txtbtn1" value="" runat="server"></asp:TextBox>
        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtbtn1" ErrorMessage=" Please enter only alpha text" ValidationExpression="^[a-z\s+A-Z]*$" ForeColor="#FF3300"></asp:RegularExpressionValidator>
        <br />
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtbtn1" ErrorMessage="Mandatory Field" ForeColor="#FF3300" SetFocusOnError="True"></asp:RequiredFieldValidator>
    </div>
    <asp:Button ID="btnsubmit" runat="server" Text="Lets get started" OnClick="btnsubmit_Click"></asp:Button>

</asp:Content>
