<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeBehind="PasswordChange.aspx.cs" Inherits="JobPortal.PasswordChange" %>

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
            <div class="row">
                <div class="col-lg-3 col-md-2 col-sm-3 hidden-xs">
                    <img src="images/keys.png" class="img-responsive center-block" />
                </div>
                <asp:Panel ID="PasswordChangeSuccess" runat="server" CssClass="col-lg-5 col-md-6 col-sm-8" Visible="false">
                    <div class="panel panel-success">
                        <div class="panel-heading bold">Change Password</div>
                        <div class="panel-body">
                            <div class="row bold center-block">
                                
                                    <asp:Literal ID="litStatus" runat="server" Text=""></asp:Literal>
                                </div></div>
                        </div>
                </asp:Panel>
                <asp:Panel ID="PanelPassword" runat="server" CssClass="col-lg-5 col-md-6 col-sm-8" >
                    
                    <div class="panel panel-success">
                        <div class="panel-heading bold">Change Password</div>
                        <div class="panel-body">
                            <div class="row">
                                <label class="col-sm-5 control-label text-right">
                                    Current Password</label>
                                <div class="col-sm-6 has-feedback">
                                    <asp:TextBox ID="txtOldPassword" CssClass="form-control" runat="server" TextMode="Password"
                                        MaxLength="100" placeholder="current password"
                                        required></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtOldPassword"
                                        ErrorMessage="*" Style="margin: 5px" ForeColor="Red" Font-Size="25px" Font-Bold="true" SetFocusOnError="True" CssClass="form-control-feedback"></asp:RequiredFieldValidator>

                                </div>

                            </div>

                            <div class="row">
                                <label class="col-sm-5 control-label text-right">
                                    New Password</label>
                                <div class="col-sm-6 has-feedback">

                                    <asp:TextBox ID="txtPassword" CssClass="form-control" runat="server" TextMode="Password"
                                         MaxLength="255" placeholder="new password" required></asp:TextBox>
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
                            <div class="row centertext">                
                                <asp:Label ID="lblPassHelpID" CssClass="PassHelpID" runat="server" Text="" ForeColor="Blue"></asp:Label>
                            </div> 
                            <div class="row">
                                <label class="col-sm-5 control-label text-right">
                                    Re-Type</label>
                                <div class="col-sm-6 has-feedback">
                                    <asp:TextBox ID="txtConformPassword" CssClass="form-control" runat="server" TextMode="Password"
                                        MaxLength="255" placeholder="re-type new password" required></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator214" runat="server" ControlToValidate="txtConformPassword"
                                        ErrorMessage="*" Style="margin: 5px" ForeColor="Red" Font-Size="25px" Font-Bold="true" SetFocusOnError="True" CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                                    <div>
                                    <asp:CompareValidator ID="CompareValidator2" runat="server"
                                        ControlToValidate="txtConformPassword"
                                        CssClass="ValidationError form-control-static" ForeColor="Red"
                                        ControlToCompare="txtPassword" Font-Bold="true" Font-Size="85%"
                                        ErrorMessage="Password Not Matched"
                                        ToolTip="Password must be the same" />
                                </div>
                                </div>                                

                            </div>
                           <div class="row">
                            
                            <div class="col-sm-5 col-sm-offset-5">
                                <asp:Button ID="cmd" CssClass="btn form-control" runat="server" Text="Change Password"
                                    OnClick="cmd_Click" clientid="cmdSubmit" />
                            </div>
                        </div>
                        </div>
                    </div>                    
                </asp:Panel>
                <div class="col-lg-4 col-lg-offset-0 col-md-4 col-md-offset-0 col-sm-7 col-sm-offset-4">
                    <div class="panel panel-info">
                        <div class="panel-heading bold">Password Policy</div>
                        <div class="panel-body">
                            <ul style="padding-left: 20px">
                                        <asp:SqlDataSource ID="SqlDataSourcePasswordPolicy" runat="server" ConnectionString="<%$ ConnectionStrings:WebDBConnectionString %>"
                                            SelectCommand="SELECT dbo.PasswordPolicyText() as Policy" EnableCaching="true" CacheDuration="30"></asp:SqlDataSource>
                                        <asp:FormView ID="FormView1" runat="server" DataSourceID="SqlDataSourcePasswordPolicy"
                                            RenderOuterTable="false" EnableViewState="false">
                                            <ItemTemplate>
                                                <%# Eval("Policy")%>
                                            </ItemTemplate>
                                        </asp:FormView>
                                    </ul>
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
