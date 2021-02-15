<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Login.aspx.cs" Inherits="Login" Title="Log In" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="CSS/StyleSheet.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" language="javascript">
        function FocusPasswordButton() {
            if (event.keyCode != 13) {
                return;
            }
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Log In
    <asp:ScriptManager ID="ToolkitScriptManager1" runat="server">
    </asp:ScriptManager>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <div  runat="server">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>
                
                <div  style="padding-top:30px;padding-left:50px">
                <table style="width: 400px;" class="Panel1">
                    <tr>
                        <td colspan="2" >
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td align="left" style="padding-left: 50px; font-size: small; font-weight: bolder;
                            width: 100px">
                            Login ID
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtEmpID" runat="server" Width="120px" TextMode="Password" CssClass="TextBoxBig"
                                onfocus="select()"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtEmpID"
                                Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" style="padding-left: 50px; font-size: small; font-weight: bolder">
                            Password
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="120px" CssClass="TextBoxBig"
                                onfocus="select()"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPassword"
                                Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="left">
                            <asp:CheckBox ID="chkRemember" runat="server" Style="font-size: small" Text="Remember my password"
                                ForeColor="#333333" />
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="left">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="left">
                            <asp:Button ID="cmdLogin" runat="server" OnClick="cmdLogin_Click" Text="Login" Width="100px" />
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="left">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <div style="padding-top: 30px">
            <a href="../Default.aspx">
                <img src="Images/Home.jpg" style="border: none" alt="Home" />
            </a>
        </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="cmdLogin" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
        <cc1:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender2" runat="server"
            TargetControlID="UpdatePanel2">
            <Animations>
    <OnUpdating>
                    <Sequence>
                        <%-- Store the original height of the panel --%>
                        <ScriptAction Script="var b = $find('animation'); b._originalHeight = b._element.offsetHeight;" />
                        
                        <%-- Disable all the controls --%>
                        <Parallel duration="0">                            
                            <EnableAction AnimationTarget="UpdatePanel2" Enabled="false" />                            
                        </Parallel>
                        <StyleAction Attribute="overflow" Value="hidden" />
                        
                        <%-- Do each of the selected effects --%>
                        <Parallel duration=".25" Fps="30">
                                <FadeOut AnimationTarget="UpdatePanel2" minimumOpacity=".2" />
                        </Parallel>
                    </Sequence>
                </OnUpdating>
                <OnUpdated>
                    <Sequence>
                        <%-- Do each of the selected effects --%>
                        <Parallel duration=".25" Fps="30">
                                <FadeIn AnimationTarget="UpdatePanel2" minimumOpacity=".2" />                            
                        </Parallel>
                        
                        <%-- Enable all the controls --%>
                        <Parallel duration="0">
                            <EnableAction AnimationTarget="UpdatePanel2" Enabled="true" />
                        </Parallel>                            
                    </Sequence>
                </OnUpdated> 
            </Animations>
        </cc1:UpdatePanelAnimationExtender>
        
    </div>
</asp:Content>
