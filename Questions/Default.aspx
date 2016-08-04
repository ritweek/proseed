<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Questions._Default" %>

<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
</asp:Content>
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <h2 class="main-header">Guiding the developer to develop software features in a focused manner.</h2>

    <div>
        <h4 style="font-family: cursive; font-size:2.5em;color:#2d728c">SO, WHAT YOU WANT TO DEVELOP TODAY!!!!!</h4>
        <asp:TextBox ID="txtbtn1" value="" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtbtn1" ErrorMessage="*This field is mandatory" ForeColor="#FF3300" Display="Dynamic"></asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtbtn1" Display="Dynamic" ErrorMessage="Not a valid value" ValidationExpression="^[a-z\s+A-Z]*$" ForeColor="#FF3300"></asp:RegularExpressionValidator>
        <br />
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtbtn1" ForeColor="#FF3300" SetFocusOnError="True"></asp:RequiredFieldValidator>
    </div>
    <asp:Button ID="btnsubmit" runat="server" Text="Lets get started" OnClick="btnsubmit_Click"></asp:Button>

</asp:Content>
