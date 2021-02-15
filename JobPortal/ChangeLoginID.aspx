<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeBehind="ChangeLoginID.aspx.cs" Inherits="JobPortal.ChangeLoginID" %>

<%@ Register Src="UserControl.ascx" TagName="UserControl" TagPrefix="uc1" %>
<%@ Register Src="CommonControl.ascx" TagName="CommonControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CpTitle" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CpBody" runat="server">
    <style type="text/css">
        .BarIndicatorweak {
            color: Red;
            background-color: Red;
            height: 13px !important;
        }

        .BarIndicatoraverage {
            color: Blue;
            background-color: Blue;
            height: 13px !important;
        }

        .BarIndicatorgood {
            color: Green;
            background-color: Green;
            height: 13px !important;
        }

        .BarBorder {
            border-style: solid;
            border-width: 1px;
            border-color: silver;
            padding: 0px;
            width: 100px;
            height: 15px !important;
            vertical-align: middle;
        }

        .barInternal {
            background: Red;
        }

        .PassHelpID {
            font-size: 85%;
        }
    </style>
    <asp:ScriptManager ID="TrustScriptManager" runat="server"
        ScriptMode="Release" EnablePartialRendering="true">
    </asp:ScriptManager>
    <uc1:CommonControl ID="CommonControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <uc1:UserControl ID="UserControl1" runat="server" />           
           

        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="10">
        <ProgressTemplate>
            <div class="TransparentGrayBackground">
            </div>
            <asp:Image ID="Image1" runat="server" alt="" ImageUrl="~/Images/processing.gif" CssClass="LoadingImage"
                Width="214" Height="138" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:AlwaysVisibleControlExtender ID="UpdateProgress1_AlwaysVisibleControlExtender"
        runat="server" Enabled="True" HorizontalSide="Center" TargetControlID="Image1"
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
