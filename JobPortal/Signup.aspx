<%@ Page Title="" Language="C#" MasterPageFile="~/TrustBank.master" AutoEventWireup="True"
    CodeBehind="Signup.aspx.cs" Inherits="JobPortal.Signup" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="CommonControl.ascx" TagName="CommonControl" TagPrefix="uc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Create Trust Bank Job Portal Account
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:ScriptManager ID="TrustScriptManager" runat="server"
        ScriptMode="Release" EnablePartialRendering="true">
    </asp:ScriptManager>
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
    <uc1:CommonControl ID="CommonControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Panel ID="PanelStatus" runat="server" CssClass="alert alert-success" Visible="false">
                <div class="row">
                    <div class="col-sm-2 text-center">
                        <img src="Images/email-send-icon.png" width="72" height="72" border="0" />
                    </div>
                    <div class="col-sm-10">
                        <asp:Label ID="lblStatus" Style="font-size: 120%" runat="server" Text=""></asp:Label>
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="Panel1" runat="server">
                <div class="row">
                    <div class="col-md-2 text-center">
                        <%-- <img src="Images/service-icon.png" width="128" height="128" />--%>
                    </div>
                    <div class="col-md-10">
                        <div class="text-left courier">
                            Please enter the following information to create your account in Trust Bank Job Portal.<br />
                            <br />
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                Full Name</label>
                            <div class="col-sm-5">
                                <asp:TextBox ID="txtFullName" CssClass="form-control" runat="server"
                                    ToolTip="Full Name" MaxLength="255" placeholder="enter full name"
                                    required></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtFstName" runat="server" ControlToValidate="txtFullName"
                                    ErrorMessage="*" Style="margin: 5px" ForeColor="Red" Font-Size="25px" Font-Bold="true" SetFocusOnError="True" CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                Email Address</label>
                            <div class="col-sm-5">
                                <asp:TextBox ID="txtEmail" CssClass="form-control" TextMode="Email" runat="server"
                                    ToolTip="Email Address" AutoCompleteType="Email" MaxLength="255" placeholder="enter email address"
                                    required></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtEmail"
                                    ErrorMessage="*" Style="margin: 5px" ForeColor="Red" Font-Size="25px" Font-Bold="true" SetFocusOnError="True" CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                Mobile</label>
                            <div class="col-sm-5 has-feedback has-success has-error">
                                <asp:TextBox ID="txtMobile" CssClass="form-control" clientid="txtMobile" runat="server" required></asp:TextBox>
                                <span id="valid-msg" class="hide glyphicon glyphicon-ok form-control-feedback text-right"></span>
                                <span id="error-msg" class="hide glyphicon glyphicon-remove form-control-feedback text-right"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                Password</label>
                            <div class="col-sm-5">
                                <asp:TextBox ID="txtPassword" CssClass="form-control" runat="server" TextMode="Password"
                                    ToolTip="Password" MaxLength="255" placeholder="enter Password" required></asp:TextBox>
                                <asp:PasswordStrength ID="PSfff" runat="server"
                                    TargetControlID="txtPassword"
                                    DisplayPosition="RightSide"
                                    PreferredPasswordLength="6"
                                    StrengthIndicatorType="BarIndicator"
                                    MinimumNumericCharacters="1"
                                    MinimumLowerCaseCharacters="1"
                                    MinimumUpperCaseCharacters="1"
                                    RequiresUpperAndLowerCaseCharacters="true"
                                    StrengthStyles="BarIndicatorweak;BarIndicatoraverage;BarIndicatorgood"
                                    BarBorderCssClass="BarBorder"
                                    CalculationWeightings="25;25;15;35"
                                    HelpStatusLabelID="lblPassHelpID"
                                    BarIndicatorCssClass="barInternal" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator22" runat="server" ControlToValidate="txtPassword"
                                    ErrorMessage="*" Style="margin: 5px" ForeColor="Red" Font-Size="25px" Font-Bold="true" SetFocusOnError="True" CssClass="form-control-feedback"></asp:RequiredFieldValidator>


                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-offset-3">
                                <asp:Label ID="lblPassHelpID" CssClass="PassHelpID" runat="server" Text=""></asp:Label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                Conform Password</label>
                            <div class="col-sm-5">
                                <asp:TextBox ID="txtConformPassword" CssClass="form-control" runat="server" TextMode="Password"
                                    ToolTip="Conform Password" MaxLength="255" placeholder="conform Password" required></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator214" runat="server" ControlToValidate="txtConformPassword"
                                    ErrorMessage="*" Style="margin: 5px" ForeColor="Red" Font-Size="25px" Font-Bold="true" SetFocusOnError="True" CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="CompareValidator1" runat="server"
                                    ControlToValidate="txtConformPassword"
                                    CssClass="ValidationError" ForeColor="Red"
                                    ControlToCompare="txtPassword"
                                    ErrorMessage="Not Match"
                                    ToolTip="Password must be the same" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                            </label>
                            <div class="col-sm-9">
                                <img src='Images/loading1.gif' id="ImgChallenge" alt="Captcha" style="border: 1px solid silver; padding: 2px; border-radius: 4px; cursor: pointer"
                                    width="135" height="35" title="Another Challenge Image" />
                                <img src="Images/reload.png" id="ImgChallengeReload" style="cursor: pointer" title="Another Challenge Image"
                                    alt="Refresh" width="16" height="16" border="0" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                Challenge Key</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="txtCaptcha" CssClass="form-control" runat="server" Width="130px"
                                    MaxLength="5" required placeholder="# # # # #" autocomplete="off" pattern="^\d{5}$"
                                    ToolTip="Enter Challenge Key Numbers"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3">
                            </label>
                            <div class="col-sm-3">
                                <asp:Button ID="cmd" CssClass="btn btn-success btn-block" runat="server" Text="Create Account"
                                    OnClick="cmd_Click" clientid="cmdSubmit" />
                            </div>
                            <div class="col-sm-2">
                                <a href="/" target="_blank">Login</a>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="PanelFacebook" runat="server" CssClass="center" Style="margin: 50px 0"
                Visible="false">
                <asp:Literal ID="FB_iFrame" runat="server"></asp:Literal>
                <%--<div class="form-group" style="margin-top:10px;">
                    
                        <button id="cmdCloseWindow" class="btn btn-success" style="width:120px;" formnovalidate >Close</button>
                    

                    <input type="button" value="Close" onclick="window.close()" class="btn btn-success" style="width:120px;" formnovalidate />
                    
                </div>--%>
            </asp:Panel>
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
