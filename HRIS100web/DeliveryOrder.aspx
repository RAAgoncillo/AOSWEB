<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MM.master" CodeBehind="DeliveryOrder.aspx.vb" Inherits="AOS100web.DeliveryOrder" %>

<%@ Register Assembly="EditableDropDownList" Namespace="EditableControls" TagPrefix="editable" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentOfMM" runat="server">
	<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
	<style>
		.Grid1 {
			margin-left: 2px;
			margin-right: auto;
			padding-left: 1px;
			padding-right: 1px;
			border-style: solid;
			border-color: black;
		}
	</style>

	<script type="text/javascript">
		function Confirm() {
			var confirm_value = document.createElement("INPUT");
			confirm_value.type = "hidden";
			confirm_value.name = "confirm_value";
			if (confirm("Do you sure to RESET Fields?")) {
				confirm_value.value = "Yes";
			} else {
				confirm_value.value = "No";
			}
			document.forms[0].appendChild(confirm_value);
		}

		function Confirm2() {
			var confirm_value = document.createElement("INPUT");
			confirm_value.type = "hidden";
			confirm_value.name = "confirm_value";
			if (confirm_value("Are you sure to VOID DO?")) {
				confirm_value.value = "Yes";
			} else {
				confirm_value.value = "No";
			}
			document.forms[0].appendChild(confirm_value);
		}

		function Confirm3() {
			var confirm_value = document.createElement("INPUT");
			confirm_value.type = "hidden";
			confirm_value.name = "confirm_value";
			if (confirm_value("Are you sure to REMOVE selected Line Item?")) {
				confirm_value.value = "Yes";
			} else {
				confirm_value.value = "No";
			}
			document.forms[0].appendChild(confirm_value);
		}

		function Confirm4() {
			var confirm_value = document.createElement("INPUT");
			confirm_value.type = "hidden";
			confirm_value.name = "confirm_value";
			if (confirm_value("DO Save, do you want to Print Now?")) {
				confirm_value.value = "Yes";
			} else {
				confirm_value.value = "No";
			}
			document.forms[0].appendChild(confirm_value);
		}

	</script>

	<link href="css/admGen.css" rel="stylesheet" />

	<table style="width: 100%; font-family: 'Segoe UI'; float: left; margin-top: -2px; padding-top: 0px">
		<tr>
			<td style="background-color: #b1bbd7; border-top: solid; border-bottom: solid; border-color: red; border-width: 2px; width: 100%; font-family: 'Segoe UI'; font-size: 10px; text-align: center; min-height: 28px; max-height: 28px; padding-bottom: 1px;"
				colspan="4">
				<asp:LinkButton ID="lbNew" runat="server" OnClick="OnConfirm" OnClientClick="Confirm()" Style="text-decoration: none; background-color: #7fc6f6; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; padding-right: 5px; min-height: 22px;"
					BorderStyle="Solid" ToolTip="Reset Fields" CssClass="StdBottomL">
					<asp:Image runat="server" imageurl="~/images/new_16.png" style="vertical-align: middle"/>&nbsp;New
				</asp:LinkButton>
				<asp:LinkButton ID="lbSave" runat="server" OnClick="lbSave_Click" Style="text-decoration: none; background-color: #7fc6f6; padding-right: 5px; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; min-height: 22px;"
					BorderStyle="Solid" ToolTip="Save">
					<asp:Image runat="server" imageurl="~/images/save_orange_16.png" style="vertical-align: middle"/>&nbsp;Save
				</asp:LinkButton>
				<asp:LinkButton ID="lbPrint" runat="server" OnClientClick="target ='_blank';" OnClick="lbPrint_Click" Style="text-decoration: none; background-color: #7fc6f6; padding-right: 5px; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; min-height: 22px;"
					BorderStyle="Solid" ToolTip="Print" Enabled="false">
					<asp:Image runat="server" imageurl="~/images/Print_16.png" style="vertical-align: middle"/>&nbsp;Print
				</asp:LinkButton>
				<asp:LinkButton ID="lbDelete" runat="server" OnClick="OnConfirm2" OnClientClick="Confirm2()" Style="text-decoration: none; background-color: #7fc6f6; padding-right: 5px; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; min-height: 22px;"
					BorderStyle="Solid" ToolTip="Void" Enabled="false">
					<asp:Image runat="server" imageurl="~/images/delete_16.png" style="vertical-align: middle"/>&nbsp;Void
				</asp:LinkButton>
				<asp:LinkButton ID="lbClose" runat="server" OnClick="lbClose_Click" Style="text-decoration: none; background-color: #7fc6f6; font-family: Tahoma; font-size: 14px; color: white; min-height: 22px; padding-left: 5px;"
					BorderStyle="Solid" ToolTip="Close" CssClass="StdBottomR">
					<asp:Image runat="server" imageurl="~/images/Exit_16.png" style="vertical-align: middle"/>&nbsp;Close&nbsp;
				</asp:LinkButton>

				<asp:Label ID="lblUser" runat="server" Text="User" Visible="false"></asp:Label>
				<asp:Label ID="lblGrpUser" runat="server" Text="Grp User" Visible="false"></asp:Label>

			</td>

			<td style="border: 1px solid #000000; min-width: 123px; background-color: lightgray; text-align: center; font-family: 'Segoe UI'; font-size: medium;">TC: &nbsp;
				<asp:Label ID="lblTC" runat="server" Text="30"></asp:Label>

			</td>

		</tr>
		<tr>
			<td style="border: 1px solid #000000; width: auto; background-color: lightgray;" colspan="5"></td>
		</tr>

	</table>

	<table style="width: 100%; font-family: sans-serif; font-size: small; float: left; background-color: lightgrey; border-spacing: 1px; margin-left: 2px; padding-left: 0px; padding-right: 0px;">

		<%--line1--%>
		<tr style="height: 26px; background-color: lightgray">

			<%--R1C1--%>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">DO No.:&nbsp;&nbsp;
			</td>

			<%--R1C2--%>
			<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<%--<asp:LinkButton ID="lbReLoadDoc" runat="server" Style="text-decoration: none; background-color: lightgray; float: left; padding-right: 2px;">&nbsp;
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>&nbsp;--%>

				<asp:TextBox ID="txtDONo" runat="server" Font-Names="Segoe UI" Font-Size="small" ReadOnly="true" AutoPostBack="true" MaxLength="8" CssClass="txtBoxC" BackColor="White" BorderStyle="None" ></asp:TextBox>

			</td>

			<%--R1C3--%>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Plant:&nbsp;&nbsp;
			</td>

			<%--R1C4--%>
			<td style="border: 1px solid #000000; width: 200px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<asp:DropDownList ID="cboPlnt" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" Width="92%" BackColor="White" BorderStyle="None">
				</asp:DropDownList>
				<asp:LinkButton ID="lbPlant" runat="server" Style="text-decoration: none; background-color: lightgray; float: right; padding-right: 2px;">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>&nbsp;
				<%--<editable:EditableDropDownList ID="cboPlnt" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" > 

				</editable:EditableDropDownList> --%>
			</td>

			<%--R1C5--%>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Salesman:&nbsp;&nbsp;
			</td>

			<%--R1C6to7--%>
			<td style="border: 1px solid #000000; width: 250px; background-color:white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<asp:DropDownList ID="cboSmnName" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox" BackColor="White" BorderStyle="None">
				</asp:DropDownList>
			</td>

			<%--R1C8--%>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Date:&nbsp;&nbsp;
			</td>

			<%--R1C9--%>
			<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<asp:TextBox ID="dpTransDate" runat="server" TextMode="Date" Width="120px" Height="99%" Font-Names="Segoe UI"
					Font-Size="small" CssClass="DateBox" BackColor="White" BorderStyle="None"></asp:TextBox>
			</td>

			<%--R1C10--%>
			<td style="width: 300px; background-color: lightgray; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<asp:LinkButton ID="btnUpdate" runat="server" Style="text-decoration: none; background-color: white; float: left; padding-right: 2px;">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>&nbsp;
			</td>

			<%--R1C11--%>
			<%--<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;"  > 
				
			</td>--%>
		</tr>

		<%--line2--%>
		<tr style="height: 26px; background-color: lightgray">
			<%--L2C1--%>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<asp:CheckBox ID="CheckBox5" runat="server" />&nbsp;
				SO No:&nbsp;&nbsp;

			</td>

			<%--L2C2--%>
			<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<%--<asp:LinkButton ID="lbSONo" runat="server" Style="text-decoration: none; background-color: lightgray; float: left; padding-right: 2px;">&nbsp;
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>&nbsp;--%>
				<asp:TextBox ID="txtSONo" runat="server" Font-Names="Segoe UI" Font-Size="small" AutoPostBack="true" CssClass="txtBoxC" BackColor="White" BorderStyle="None"></asp:TextBox>
			</td>

			<%--L2C3--%>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Movement:&nbsp;&nbsp;
			</td>

			<%--L2C4-7--%>
			<td style="border: 1px solid #000000; width: 350px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="3">
				<asp:DropDownList ID="cboMovType" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox3" BackColor="White" BorderStyle="None">
				</asp:DropDownList>

				<asp:LinkButton ID="lbMovType" runat="server" Style="text-decoration: none; background-color: white; float: right; padding-right: 2px;">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>&nbsp;
			</td>

			<%--L2C8--%>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">PO No.:&nbsp;&nbsp;
			</td>

			<%--L2C9-10--%>
			<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<asp:TextBox ID="txtPOno" runat="server" Font-Names="Segoe UI" Font-Size="small" AutoPostBack="true" CssClass="TxtBox" BackColor="White" BorderStyle="None"></asp:TextBox>

			</td>

			<%--L2C11--%>
			<%--<td style="border: 1px solid #000000;width: 300px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" ></td>--%>

			<%--<td style="border: 1px solid #000000; width:100px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small; ">
				 
			</td>--%>
		</tr>

		<%--line3--%>
		<tr style="height: 26px; background-color: lightgray">
			<%--L3C1--%>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Sold To:&nbsp;&nbsp;
			</td>

			<%--L3C2to4--%>
			<td style="border: 1px solid #000000; width: 430px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="3">
				<asp:DropDownList ID="cboCustName" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox3" BackColor="White" BorderStyle="None">
				</asp:DropDownList>
				<asp:LinkButton ID="lbCustName" runat="server" Style="text-decoration: none; background-color: lightgray; float: right; padding-right: 2px;">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>&nbsp;
			</td>

			<%--L3C5--%>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">PC:&nbsp;&nbsp;
				
			</td>

			<%--L3C6--%>
			<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">

				<asp:DropDownList ID="cboPClass" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox2" BackColor="White" BorderStyle="None">
				</asp:DropDownList>
				<asp:LinkButton ID="lbPClass" runat="server" Style="text-decoration: none; background-color: white; float: right; padding-right: 2px;">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>&nbsp;
			</td>

			<%--<td style="width: auto; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="2" rowspan="3"></td>--%>

			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">MM Grp:&nbsp;&nbsp;
				
			</td>

			<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="2">
				<asp:DropDownList ID="cboFGmmGrp" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" Width="93%" BackColor="White" BorderStyle="None">
				</asp:DropDownList>
				<asp:LinkButton ID="lbFGmmGrp" runat="server" Style="text-decoration: none; background-color: white; float: right; padding-right: 0px;">&nbsp;
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>
			</td>

		</tr>
		<%--line4--%>
		<tr style="height: 26px; background-color: lightgray">
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Ship To:&nbsp;&nbsp;
			</td>
			<td style="border: 1px solid #000000; width: 430px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="3">
				<asp:DropDownList ID="cboShipTo" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox3" BackColor="White" BorderStyle="None">
				</asp:DropDownList>
				<asp:LinkButton ID="lbShipTo" runat="server" Style="text-decoration: none; background-color: white; float: right; padding-right: 2px;">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>&nbsp;
			</td>

			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">New Plant:&nbsp;&nbsp;
				
			</td>

			<td style="border: 1px solid #000000; width: 250px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<asp:DropDownList ID="cboPlnt2" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox2" BackColor="White" BorderStyle="None">
				</asp:DropDownList>
				<asp:LinkButton ID="lbPlnt2" runat="server" Style="text-decoration: none; background-color: white; float: right; padding-right: 2px;">&nbsp;
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>

			</td>

			<td style="border: 1px solid #000000; background-color: deepskyblue; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: medium;" colspan="3" rowspan="2">Error Message: <
				<asp:Label ID="tssErrorMsg" runat="server" Text="Okay" ForeColor="White" Font-Size="Medium"></asp:Label> >
			</td>

			<%--<td style=" width: 120px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				
			</td>--%>

		</tr>
		<%--line5--%>
		<tr style="height: 26px; background-color: lightgray">
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Ref No:&nbsp;&nbsp;
			</td>
			<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" BackColor="White" BorderStyle="None">
				<asp:TextBox ID="txtRefNo" runat="server" Font-Names="Segoe UI" Font-Size="small" AutoPostBack="true" CssClass="TxtBox" BackColor="White" BorderStyle="None"></asp:TextBox>
			</td>

			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Driver:&nbsp;&nbsp;
				
			</td>
			<td style="border: 1px solid #000000; width: auto; background-color: white; text-align: left; padding-left: 1px; padding-right: 2px; font-family: 'Segoe UI'; font-size: small;">
				<asp:TextBox ID="txtDriver" runat="server" Font-Names="Segoe UI" Font-Size="small" CssClass="txtBoxL" BackColor="White" BorderStyle="None"></asp:TextBox>
			</td>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Plate No.:&nbsp;&nbsp;
			</td>

			<td style="border: 1px solid #000000; width: 250px; background-color: white; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" >
				<asp:TextBox ID="txtPlNo" runat="server" Font-Names="Segoe UI" Font-Size="small" Width="96%" CssClass="txtBoxC" BackColor="White" BorderStyle="None"></asp:TextBox>
			</td>

			<%--<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">New Plant:&nbsp;&nbsp;
				
			</td>--%>

			<%--<td style="border: 1px solid #000000; width: 250px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" >
				
			</td>--%>

			<%--<td style=" width: 100px; background-color: lightgray; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				
			</td>--%>

			

		</tr>

		<%--line6--%>
		<tr style="height: 26px; background-color: lightgray">
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Remarks:&nbsp;&nbsp;
			</td>
			<td style="border: 1px solid #000000; width: 650px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="3">
				<asp:TextBox ID="txtRemarks" runat="server" Font-Names="Segoe UI" Font-Size="small" CssClass="txtBoxL" BackColor="White" BorderStyle="None"></asp:TextBox>
			</td>

			<td style="border: 1px solid #000000; width: auto; background-color: lightgray; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<asp:CheckBox ID="CheckBox3" runat="server" Text="Packing" />
			</td>

			<td style="border: 1px solid #000000; width: 120px; height: 26px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small; vertical-align:middle;">
				<%--<asp:CheckBox ID="CheckBox4" runat="server" ToolTip="Check If DR Only" AutoPostBack="true" />--%>&nbsp;
				<%--<asp:Label ID="lblChkBox4" runat="server" Text="With SI"></asp:Label>&nbsp;&nbsp;--%>
			</td>

			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">SI Date:&nbsp;&nbsp;
			</td>

			<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<asp:TextBox ID="dpSIdate" runat="server" TextMode="Date" Width="120px" Height="99%" Font-Names="Segoe UI"
					Font-Size="small" CssClass="DateBox" BackColor="White" BorderStyle="None"></asp:TextBox>
			</td>

			<td style="width: 250px; background-color: lightgray; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<asp:LinkButton ID="btnSIdateUpdate" runat="server" Style="text-decoration: none; background-color: lightgray; float: left; padding-right: 2px;">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>&nbsp;
			</td>

		</tr>

		<tr>
			<%--red line--%>
			<td style="border: 1px solid #000000; width: auto; height: auto; background-color: red;" colspan="12"></td>
		</tr>
	</table>

	<%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>

	<%--Tab--%>

	<ajaxToolkit:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" Style="width: 100%; margin-left: 3px; height: auto; background-color: ghostwhite;">
		<ajaxToolkit:TabPanel ID="TabPanel1" runat="server" HeaderText="DR Processing" CssClass="TabPanel1" Height="573px">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: lightgrey; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<tr style="height: 26px; background-color: lightgray">
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" rowspan="2">Select
						</td>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Item No.
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Code No.
						</td>
						<td style="border: 1px solid #000000; width: 450px; background-color: lightgray; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="3">&nbsp;
							Description &nbsp;&nbsp;
							<%--<asp:TextBox ID="txtAddDesc" runat="server" Font-Names="Segoe UI" Font-Size="Small" Width="78%" AutoPostBack="true" BackColor="White" BorderStyle="None" ></asp:TextBox>--%>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;
							<asp:Label ID="lblQtPk" runat="server" Text="0" ForeColor="Red"></asp:Label>
							Qty
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Wt/Vol
							<asp:DropDownList ID="cboAdmDig" runat="server" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small">
							</asp:DropDownList>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<%--<asp:Label ID="lblChkBox7" runat="server" Text="SP/UC"></asp:Label>--%>
							<asp:CheckBox ID="CheckBox7" runat="server" AutoPostBack="true" Text="SP/UC"/>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Amount
							<asp:TextBox ID="txtUMmatl" Width="40px" runat="server" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" ></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:DropDownList ID="cboSLoc" runat="server" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" CssClass="cboBox"></asp:DropDownList>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Lot No.&nbsp;&nbsp;
							<asp:CheckBox ID="CheckBox1" runat="server" />
						</td>
						<td style="border: 1px solid #000000; width: 25px; background-color: lightgray; text-align: center; vertical-align: middle; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" rowspan="2">
							<asp:Label ID="lblBillRef" runat="server" Text="Wt" ForeColor="Red"></asp:Label>
						</td>
					</tr>
					<tr style="height: 26px; background-color: lightgray">
						<td style="border: 1px solid #000000; width: 80px; background-color: white; text-align: center; padding-left: 1px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtItm" runat="server" Font-Names="Segoe UI" Font-Size="Small" Text="1" AutoPostBack="true" CssClass="TxtBox" BackColor="White" BorderStyle="None"></asp:TextBox>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 1px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtCodeNo" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="Small" CssClass="TxtBox" BackColor="White" BorderStyle="None"></asp:TextBox>
						</td>

						<td style="border: 1px solid #000000; width: 450px; background-color: white; text-align: center; font-family: 'Segoe UI'; font-size: small;" colspan="3">
							<asp:DropDownList ID="cboMMdesc" runat="server" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" CssClass="cboBox" BackColor="White" BorderStyle="None"></asp:DropDownList>

							<%--<editable:EditableDropDownList ID="cboMMdesc" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" > 

							</editable:EditableDropDownList> --%>

						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtQty" runat="server" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="txtAmtBox" BackColor="White" BorderStyle="None"></asp:TextBox>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtWt" runat="server" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="txtAmtBox" BackColor="White" BorderStyle="None"></asp:TextBox>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtSP" runat="server" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="txtAmtBox" BackColor="White" BorderStyle="None"></asp:TextBox>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblAmt" runat="server" Text="0.00" CssClass="lblLabelAmt"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblSLoc" runat="server" Text=""></asp:Label>
						</td>
						
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:DropDownList ID="cboLotNo" runat="server" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" CssClass="cboBox" BackColor="White" BorderStyle="None"></asp:DropDownList>
						</td>
					</tr>
					<tr style="height: auto; background-color: lightgray">
						<td style="border: 1px solid #000000; height: 463px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small; vertical-align: top; margin-left: 0px" colspan="12">

							<asp:Panel ID="Panel1" runat="server" ScrollBars="Auto" CssClass="PanelStd">

								<asp:GridView ID="DgvDOdet" runat="server" AutoGenerateColumns="False" OnRowDataBound="DgvDOdet_RowDataBound"
									OnRowCreated="DgvDOdet_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="False" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:CommandField ShowSelectButton="True">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="72px"></ItemStyle>
										</asp:CommandField>

										<asp:BoundField DataField="itmno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="codeno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="119px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="mmdesc">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="480px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="qty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="118px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="wt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="118px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="sp" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="118px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="itmamt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="118px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="sloc" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="left" VerticalAlign="Middle" Width="118px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="lotno" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="118px">
											</ItemStyle>
										</asp:BoundField>

									</Columns>

									<FooterStyle BackColor="#CCCCCC" ForeColor="Black" BorderStyle="Solid" />
									<HeaderStyle BackColor="#007ACC" Font-Bold="True" ForeColor="White" BorderColor="Black" />
									<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
									<RowStyle BackColor="#EEEEEE" ForeColor="Black" />
									<SelectedRowStyle BackColor="Orange" Font-Bold="True" ForeColor="White" />
									<SortedAscendingCellStyle BackColor="#F1F1F1" />
									<SortedAscendingHeaderStyle BackColor="#0000A9" />
									<SortedDescendingCellStyle BackColor="#CAC9C9" />
									<SortedDescendingHeaderStyle BackColor="#000065" />

								</asp:GridView>

							</asp:Panel>

						</td>

						<td style="border: 1px solid #000000; width: 25px; background-color: beige; text-align: center; vertical-align: text-top; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:ImageButton ID="btnReset" runat="server" ImageUrl="~/images/reset_16.png" CssClass="ImgBtn" />
							<asp:ImageButton ID="btnAdd" runat="server" ImageUrl="~/images/check_16.png" CssClass="ImgBtn" />
							<asp:ImageButton ID="btnDel" runat="server" OnClick="OnConfirm3" OnClientClick="Confirm3()" ImageUrl="~/images/delete_16.png" />
						</td>

					</tr>

					<tr style="height: 26px; background-color: lightgray">
						<td style="border: 1px solid #000000; width: auto; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;" colspan="5">Check By:&nbsp;
							<asp:DropDownList ID="cboCheckBy" runat="server" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" Width="153px"></asp:DropDownList>
						</td>

						<td style="border: 1px solid #000000; width: auto; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Total &nbsp;&nbsp;
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotQty" runat="server" Text="0" ForeColor="Red" CssClass="lblLabelAmt"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotWt" runat="server" Text="0.00" ForeColor="Red" CssClass="lblLabelAmt"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotAmt" runat="server" Text="0.00" ForeColor="Red" CssClass="lblLabelAmt"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 240px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="2"></td>

						<%--<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							
						</td>--%>

						<td style="border: 1px solid #000000; width: 25px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

					</tr>

					<tr style="height: auto; background-color: lightgray">
						<td style="border: 1px solid #000000; height: 20px; background-color: lightgray; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="13">&nbsp;&nbsp; 
							Add New Signatory:&nbsp;&nbsp;
							<asp:TextBox ID="txtNewSign" runat="server" Font-Names="Segoe UI" Font-Size="Small" Width="146px"></asp:TextBox>
							<asp:ImageButton ID="btnNewSign" runat="server" ImageUrl="~/images/check_16.png" />
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							Save/Upload Status: &nbsp;&nbsp;
							<asp:Label ID="tsSaveStat" runat="server" Text="Not yet Saved" ForeColor="Red"></asp:Label>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<asp:Label ID="tssDocStat" runat="server" Text="New" ForeColor="Red"></asp:Label>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<asp:Label ID="tssDSRstat" runat="server" Text="Not Yet Served" ForeColor="Red"></asp:Label>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
							Doc No.:&nbsp;&nbsp;
							<asp:Label ID="tsDocNoEdit" runat="server" Text=" " ForeColor="Red"></asp:Label>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
							SI No.:&nbsp;&nbsp;
							<asp:Label ID="tssInvNo" runat="server" Text="00000000" ForeColor="Red"></asp:Label>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
							Error Msg:&nbsp;&nbsp;
							
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
							DR Print Opt:&nbsp;&nbsp;
							<asp:Label ID="tssDRprtOpt" runat="server" Text="No BIR" ForeColor="Red"></asp:Label>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
							Line Item:&nbsp;&nbsp;
							<asp:Label ID="lblLineItm" runat="server" Text="New" ForeColor="Red"></asp:Label>

						</td>
					</tr>

				</table>

			</ContentTemplate>

		</ajaxToolkit:TabPanel>

		<%--SO List--%>
		<ajaxToolkit:TabPanel ID="TabPanel2" runat="server" HeaderText="Open SO" Height="573px">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: lightgrey; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<tr style="height: 26px; background-color: lightgray">
						<td style="border: 1px solid #000000; width: 200px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"colspan="2">Customers:&nbsp;&nbsp;
						</td>
						<td style="border: 1px solid #000000; width: 650px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:DropDownList ID="CboCustList" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox3">
							</asp:DropDownList>
							<asp:LinkButton ID="LbCustList" runat="server" Style="text-decoration: none; background-color: lightgray; float: right; padding-right: 2px;">
							<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
							</asp:LinkButton>&nbsp;
						</td>
						<td style="border: 1px solid #000000; width: auto; background-color: lightgray; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="5"></td>

					</tr>

					<tr style="background-color: lightgray">
						<td style="border: 1px solid #000000; height: 361px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small; vertical-align: top; margin-left: 0px" colspan="8">

							<asp:Panel ID="Panel2" runat="server" Width="100%" Height="360px">
								<asp:GridView ID="DgvSOList" runat="server" AutoGenerateColumns="False" OnRowDataBound="DgvSOList_RowDataBound"
									OnRowCreated="DgvSOList_RowCreated" Font-Names="Segoe UI" Font-Size="small" BackColor="White" BorderColor="#999999" BorderStyle="Solid" AllowSorting="true" BorderWidth="1px" CellPadding="3" GridLines="Vertical" HeaderStyle-BorderColor="Black" ShowHeader="true">
									<AlternatingRowStyle BackColor="#DCDCDC" />
									<Columns>
										<asp:CommandField HeaderText="Select" ShowSelectButton="true">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="72px"></ItemStyle>
										</asp:CommandField>

										<asp:BoundField DataField="sono" HeaderText="SO No.">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="110px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField HeaderText="Date" DataField="transdate" DataFormatString="{0:yyyy-MM-dd}">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="custno" HeaderText="Customer">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="500px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="status" HeaderText="Status">
											<ItemStyle HorizontalAlign="left" VerticalAlign="Middle" Width="200px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="pono" HeaderText="PO No.">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="100px"></ItemStyle>
										</asp:BoundField>

									</Columns>

									<FooterStyle BackColor="#CCCCCC" ForeColor="Black" BorderStyle="Solid" />
									<HeaderStyle BackColor="#007acc" Font-Bold="True" ForeColor="White" Height="22px"/>
									<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
									<RowStyle BackColor="#EEEEEE" ForeColor="Black" />
									<SelectedRowStyle BackColor="Orange" Font-Bold="True" ForeColor="White" />
									<SortedAscendingCellStyle BackColor="#F1F1F1" />
									<SortedAscendingHeaderStyle BackColor="#0000A9" />
									<SortedDescendingCellStyle BackColor="#CAC9C9" />
									<SortedDescendingHeaderStyle BackColor="#000065" />

								</asp:GridView>

							</asp:Panel>

							<script src="Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
							<script src="Scripts/ScrollableGridViewPlugin_ASP.NetAJAXmin.js" type="text/javascript"></script>
							<script type="text/javascript">
								$(document).ready(function () {
									$('#<%=DgvSOList.ClientID %>').Scrollable({
										ScrollHeight: 333,
										IsInPanel: true
									});
								});
							</script>
						</td>
					</tr>
					<tr style="background-color: lightgray">
						<td style="background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="8">
						</td>
					</tr>
					<tr style="background-color: lightgray">
						<td style="border: 1px solid #000000; height: 155px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small; vertical-align: top; margin-left: 0px" colspan="8">
							<asp:Panel ID="Panel3" runat="server" Width="100%" Height="153px">
								<asp:GridView ID="DgvSOdetList" runat="server" AutoGenerateColumns="False" OnRowDataBound="DgvSOdetList_RowDataBound" OnRowCreated="DgvSOdetList_RowCreated" Font-Names="Segoe UI" Font-Size="small" BackColor="White" BorderColor="#999999" BorderStyle="Solid" AllowSorting="true" BorderWidth="1px" CellPadding="3" GridLines="Vertical" HeaderStyle-BorderColor="Black" ShowHeader="true">
									<AlternatingRowStyle BackColor="#DCDCDC" />
									<Columns>
										<asp:BoundField DataField="itmno" HeaderText="Itm No.">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80px"></ItemStyle>
										</asp:BoundField>
										
										<asp:BoundField DataField="codeno" HeaderText="Code No.">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="mmdesc" HeaderText="Product Description">
											<ItemStyle HorizontalAlign="left" VerticalAlign="Middle" Width="653px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="qty" HeaderText="Bal Qty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="113px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="wt" HeaderText="Bal Wt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="111px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="sp" HeaderText="SP" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="111px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="itmamt" HeaderText="Amount" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="111px"></ItemStyle>
										</asp:BoundField>

									</Columns>

									<FooterStyle BackColor="#CCCCCC" ForeColor="Black" BorderStyle="Solid" />
									<HeaderStyle BackColor="#007acc" Font-Bold="True" ForeColor="White" Height="22px" />
									<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
									<RowStyle BackColor="#EEEEEE" ForeColor="Black" />
									<SelectedRowStyle BackColor="Orange" Font-Bold="True" ForeColor="White" />
									<SortedAscendingCellStyle BackColor="#F1F1F1" />
									<SortedAscendingHeaderStyle BackColor="#0000A9" />
									<SortedDescendingCellStyle BackColor="#CAC9C9" />
									<SortedDescendingHeaderStyle BackColor="#000065" />
									
								</asp:GridView>

							</asp:Panel>

							<script src="Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
							<script src="Scripts/ScrollableGridViewPlugin_ASP.NetAJAXmin.js" type="text/javascript"></script>
							<script type="text/javascript">
								$(document).ready(function () {
									$('#<%=DgvSOdetList.ClientID %>').Scrollable({
										ScrollHeight: 128,
										IsInPanel: true
									});
								});
							</script>
						</td>
					</tr>
					<tr style="height: 22px; background-color: lightgray">
						<td style="border: 1px solid #000000; width: 850px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="3">Total&nbsp;&nbsp;
						</td>
						<td style="border: 1px solid #000000; width: 117px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotQtyT2" runat="server" Text="0" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>
						<td style="border: 1px solid #000000; width: 117px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotWtT2" runat="server" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>
						<td style="border: 1px solid #000000; width: 117px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
						</td>
						<td style="border: 1px solid #000000; width: 117px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotAmtT2" runat="server" Text="0.00" ForeColor="Red"></asp:Label>
							&nbsp;&nbsp;
						</td>
						<td style="border: 1px solid #000000; width: 180px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
						</td>
					</tr>


				</table>


			</ContentTemplate>

		</ajaxToolkit:TabPanel>

		<%--SO Monitoring--%>
		<ajaxToolkit:TabPanel ID="TabPanel3" runat="server" HeaderText="DR List" Height="573px">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: lightgrey; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<tr style="height: 26px; background-color: lightgray">
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Date From:&nbsp;&nbsp;
						</td>

						<td style="border: 1px solid #000000; width: 150px; background-color: lightgray; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="dpDateFrT3" runat="server" TextMode="Date" Width="120px" Height="99%" Font-Names="Segoe UI"
					                     Font-Size="small" AutoPostBack="true" CssClass="DateBox"></asp:TextBox>
						</td>

						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Date To:&nbsp;&nbsp;
						</td>

						<td style="border: 1px solid #000000; width: 150px; background-color: lightgray; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="dpDateToT3" runat="server" TextMode="Date" Width="120px" Height="99%" Font-Names="Segoe UI"
					                     Font-Size="small" AutoPostBack="true" CssClass="DateBox"></asp:TextBox>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Status:&nbsp;&nbsp;
						</td>

						<td style="border: 1px solid #000000; width: 150px; background-color: lightgray; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:DropDownList ID="cboDOstatus" runat="server" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox3">
							</asp:DropDownList>
							
						</td>

						<td style="border: 1px solid #000000;width: auto; background-color: lightgray; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:LinkButton ID="lbDOstatus" runat="server" Style="text-decoration: none; background-color: lightgray; float: left; padding-right: 2px;">
							<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
							</asp:LinkButton>&nbsp;
						</td>

					</tr>
					<tr style="background-color: lightgray">
						<td style="border: 1px solid #000000; height: 543px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small; vertical-align: top; margin-left: 0px" colspan="7">
							<asp:Panel ID="Panel4" runat="server" Width="100%" Height="541px">
								<asp:GridView ID="DgvDOsumList" runat="server" AutoGenerateColumns="False" OnRowDataBound="DgvDOsumList_RowDataBound" OnRowCreated="DgvDOsumList_RowCreated" Font-Names="Segoe UI" Font-Size="small" BackColor="White" BorderColor="#999999" BorderStyle="Solid" AllowSorting="true" BorderWidth="1px" CellPadding="3" GridLines="Vertical" HeaderStyle-BorderColor="Black" ShowHeader="true">
									<AlternatingRowStyle BackColor="#DCDCDC" />
									<Columns>
										<asp:CommandField HeaderText="Select" ShowSelectButton="true">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="72px"></ItemStyle>
										</asp:CommandField>

										<asp:BoundField DataField="dono" HeaderText="DO No.">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="110px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="transdate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="custno" HeaderText="Sold To">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="400px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="mov" HeaderText="Movement Type">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="300px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="plntno" HeaderText="Source Plant">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="200px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="status" HeaderText="Status">
											<ItemStyle HorizontalAlign="left" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="dsrstat" HeaderText="Del Status">
											<ItemStyle HorizontalAlign="left" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
																				
									</Columns>

									<FooterStyle BackColor="#CCCCCC" ForeColor="Black" BorderStyle="Solid" />
									<HeaderStyle BackColor="#007acc" Font-Bold="True" ForeColor="White" Height="22px" />
									<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
									<RowStyle BackColor="#EEEEEE" ForeColor="Black" />
									<SelectedRowStyle BackColor="Orange" Font-Bold="True" ForeColor="White" />
									<SortedAscendingCellStyle BackColor="#F1F1F1" />
									<SortedAscendingHeaderStyle BackColor="#0000A9" />
									<SortedDescendingCellStyle BackColor="#CAC9C9" />
									<SortedDescendingHeaderStyle BackColor="#000065" />
									
								</asp:GridView>



							</asp:Panel>

							<script src="Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
							<script src="Scripts/ScrollableGridViewPlugin_ASP.NetAJAXmin.js" type="text/javascript"></script>
							<script type="text/javascript">
								$(document).ready(function () {
									$('#<%=DgvDOsumList.ClientID %>').Scrollable({
										ScrollHeight: 517,
										IsInPanel: true
									});
								});
							</script>
						</td>

					</tr>

					

				</table>

			</ContentTemplate>

		</ajaxToolkit:TabPanel>

		<ajaxToolkit:TabPanel ID="TabPanel4" runat="server" HeaderText="DR Monitoring" Height="573px">
			<ContentTemplate>


			</ContentTemplate>

		</ajaxToolkit:TabPanel>

	</ajaxToolkit:TabContainer>


</asp:Content>
