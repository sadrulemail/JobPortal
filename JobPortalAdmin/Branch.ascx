<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Branch.ascx.cs" Inherits="Branch" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<link href="CSS/EMP.css" rel="stylesheet" type="text/css" />
<asp:Label ID="lblBranchID" runat="server" Text="" CssClass="UserLabel"></asp:Label>
<asp:HoverMenuExtender runat="server" ID="HoverMenuExtenderlblBranchID" DynamicControlID="BranchInfo"
    DynamicServiceMethod="getBranchInfo" DynamicServicePath="userServices.asmx" TargetControlID="lblBranchID"
    PopupControlID="BranchInfo" CacheDynamicResults="true" HoverDelay="500">
</asp:HoverMenuExtender>
<asp:Panel runat="server" ID="BranchInfo" CssClass="UserName">
</asp:Panel>