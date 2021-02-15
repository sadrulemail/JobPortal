<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EMP.ascx.cs" Inherits="EMP" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<link href="CSS/EMP.css" rel="stylesheet" type="text/css" />
<asp:Label ID="lblPrefix" runat="server" CssClass="UserLabel"></asp:Label>
<asp:Label ID="lblUserID" runat="server" Text="" CssClass="UserLabel"></asp:Label>
<asp:HoverMenuExtender runat="server" ID="HoverMenuExtenderlblUserID" DynamicControlID="UserInfo"
    DynamicServiceMethod="getUserInfo" DynamicServicePath="userServices.asmx" TargetControlID="lblUserID"
    PopupControlID="UserInfo" CacheDynamicResults="true" HoverDelay="500">
</asp:HoverMenuExtender>
<asp:Panel runat="server" ID="UserInfo" CssClass="UserName">
</asp:Panel>