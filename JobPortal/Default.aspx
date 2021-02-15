<%@ Page Title="" Language="C#" MasterPageFile="~/TrustBank.master" AutoEventWireup="True"
    CodeBehind="Default.aspx.cs" Inherits="JobPortal.DefaultPage" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="CommonControl.ascx" TagName="CommonControl" TagPrefix="uc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Trust Bank Job Portal
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:ScriptManager ID="TrustScriptManager" runat="server"
        ScriptMode="Release" EnablePartialRendering="true">
    </asp:ScriptManager>
    <style type="text/css">
        .row-pad-top {
            padding-top: 10px;
        }
    </style>
    <uc1:CommonControl ID="CommonControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="row">
                <div class="col-sm-5" style="max-width: 320px">
                    <div class="panel panel-info" style="background:#f3f3f3">                        
                        <div class="panel-body" style="padding: 0 25px">
                            <div class="row bold row-pad-top">
                                Login ID
                            </div>
                            <div class="form-group has-feedback">
                                <asp:TextBox ID="txtLoginId" CssClass="form-control" runat="server" TextMode="Email"
                                    MaxLength="255" AutoCompleteType="Email" placeholder="email address"
                                    required></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtLoginId" runat="server" ControlToValidate="txtLoginId"
                                    ErrorMessage="*" Style="margin: 5px" ForeColor="Red" Font-Size="25px" Font-Bold="true" SetFocusOnError="True" CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                            </div>
                            <div class="row bold">
                                Password
                            </div>
                            <div class="form-group has-feedback">
                                <asp:TextBox ID="txtPassword" TextMode="Password" CssClass="form-control" runat="server"
                                    MaxLength="255" placeholder="password"
                                    required></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPassword"
                                    ErrorMessage="*" Style="margin: 5px" ForeColor="Red" Font-Size="25px" Font-Bold="true" SetFocusOnError="True" CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                            </div>

                            <div class="row bold">
                                Challenge Key
                            </div>
                            <div class="row">
                                <div class="col-xs-4" style="padding: 0; margin-right: 10px">
                                    <asp:TextBox ID="txtCaptcha" CssClass="form-control" runat="server"
                                        MaxLength="5" required placeholder="#####" autocomplete="off" pattern="^\d{5}$"
                                        ToolTip="Enter Challenge Key Numbers"></asp:TextBox>
                                </div>
                                <div style="padding: 0">
                                    <img src='Images/loading1.gif' id="ImgChallenge" alt="Captcha" style="border: 1px solid silver; padding: 2px; border-radius: 4px; cursor: pointer"
                                        width="130" height="35" title="Another Challenge Image" />

                                    <img src="Images/reload.png" id="ImgChallengeReload" style="cursor: pointer" title="Another Challenge Image"
                                        alt="Refresh" width="16" height="16" border="0" />
                                </div>
                            </div>

                            <div class="row" style="padding-top: 20px">
                                <div class="col-sm-5 col-md-6" style="padding: 0">
                                    <asp:Button ID="cmd" CssClass="btn btn-success btn-block" runat="server" Text="Login"
                                        OnClick="cmd_Click" clientid="cmdSubmit" />
                                </div>
                                <div class="col-sm-7 col-md-6" style="padding-top: 10px">
                                    <a class="bold" href="../webuser/ForgetPassword.aspx?appid=3003" target="_blank" style="font-size: 85%">Forget Password?</a>
                                </div>
                            </div>
                            <div class="row" style="padding-top: 30px; padding-bottom: 15px; font-size: 95%">
                                Please enter your Trust Bank Web User ID and Password to log in. 
                                If you do not have Trust Bank Web User account, please click on
                                <a class="bold" href="../webuser/Signup.aspx?appid=3003" target="_blank">Create Now</a>

                            </div>
                        </div>
                    </div>
                </div>
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
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
