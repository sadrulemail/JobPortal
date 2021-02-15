<%@ Page Title="" Language="C#" MasterPageFile="~/TrustBank.master" AutoEventWireup="true" Inherits="JobPortal.Email_Verify" Codebehind="Email_Verify.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register src="CommonControl.ascx" tagname="CommonControl" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Trust Bank Job Portal
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:ScriptManager ID="TrustScriptManager" runat="server" ScriptMode="Release"
        EnablePartialRendering="true">
    </asp:ScriptManager>
    <uc1:CommonControl ID="CommonControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="margin: 0 auto;" align="center">
                <asp:Panel ID="PanelError" runat="server" Visible="false">
                    <div class="row">
                        <div class="col-md-2 col-md-offset-2">
                            <img src="Images/sad-icon.png" width="128" height="128" />
                        </div>
                        <div class="col-md-8 text-left" style="margin-bottom:20px">
                            <div style="margin-bottom:20px">
                                <asp:Label ID="lblError" runat="server" Text="" Font-Bold="true" Font-Size="Medium"></asp:Label>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <asp:HyperLink ID="lnkErrorGo" CssClass="btn btn-success btn-block" runat="server">Try Again</asp:HyperLink>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="PanelEmailVarified" runat="server" Visible="false">
                    <div class="row">
                        <div class="col-md-2 col-md-offset-2">
                            <img src="Images/mail-check-icon.png" width="128" height="128" />
                        </div>
                        <div class="col-md-8 text-left">
                            <asp:Label ID="lblVarified" runat="server" Font-Bold="true" Font-Size="Medium" Text="Your email address verified."></asp:Label>
                            <br />
                            <span class="courier">Please click Login to proceed.</span>
                            <br />
                            <br />
                            <div class="col-md-3">
                                <asp:Button ID="cmdStartInsert" runat="server" CssClass="btn btn-success btn-block"
                                    Text="Login" OnClick="cmdStartInsert_Click" />
                            </div>
                            <asp:HiddenField ID="hidReturnKeycode" runat="server" />
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-3">
                        </div>
                    </div>
                </asp:Panel>
            </div>
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
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
