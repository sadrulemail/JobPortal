<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="JobPortal.Home" %>
<%@ Register src="UserControl.ascx" tagname="UserControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CpTitle" runat="server">
    Welcome to Trust Bank Job Portal
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CpBody" runat="server">
    <uc1:UserControl ID="UserControl1" runat="server" />
    <div class="row"><div class="text-center">Welcome to Trust Bank Job Portal.</div></div>
</asp:Content>
