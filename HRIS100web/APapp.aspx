<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/FI.master" CodeBehind="APapp.aspx.vb" Inherits="AOS100web.APapp" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentOfFinAcctg" runat="server">
	<style type="text/css">
		div {
			z-index: 9999;
		}
	</style>

	<asp:ScriptManager ID="ScriptManager1" runat="server" ></asp:ScriptManager>

	<script type="text/javascript">
		function Confirm() {
			var confirm_value = document.createElement("INPUT");
			confirm_value.type = "hidden";
			confirm_value.name = "confirm_value";
			if (confirm("Are you sure to POST Selected Document?")) {
				confirm_value.value = "Yes";
			} else {
				confirm_value.value = "No";
			}
			document.forms[0].appendChild(confirm_value);
		}
	</script>

	<style>
		.Grid1 {
			margin-left: 1px;
			margin-right: 1px;
			margin-bottom: 2px;
			padding-left: 1px;
			padding-right: 1px;
			border-style: solid;
			border-color: black;
		}
	</style>

	<link href="css/admGen.css" rel="stylesheet" />

	<table style="width: 100%; font-family: 'Segoe UI'; float: left; margin-top: 0px; padding-top: 0px">
		<tr>
			<td style="background-color: #b1bbd7; border-top: solid; border-bottom: solid; border-color: red; border-width: 2px; width: 100%; font-family: 'Segoe UI'; font-size: 10px; text-align: center; min-height: 28px; max-height: 28px; padding-bottom: 1px; padding-top: 1px;"
				colspan="9">
				<asp:LinkButton ID="lbNew" runat="server" OnClick="LbNew_Click" Style="text-decoration: none; background-color: #7fc6f6; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; padding-right: 5px; min-height: 22px;"
					BorderStyle="Solid" ToolTip="Reset Fields" CssClass="StdBottomL">
					<asp:Image runat="server" imageurl="~/images/new_16.png" style="vertical-align: middle"/>&nbsp;New
				</asp:LinkButton>
				<asp:LinkButton ID="lbSave" runat="server" OnClick="OnConfirm" OnClientClick="Confirm()" Style="text-decoration: none; background-color: #7fc6f6; padding-right: 5px; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; min-height: 22px;"
					BorderStyle="Solid" ToolTip="Save" Enabled="false">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle; "/>&nbsp;Post
				</asp:LinkButton>
				<asp:LinkButton ID="lbPrint" runat="server" OnClientClick="target ='_blank';" OnClick="lbPrint_Click" Style="text-decoration: none; background-color: #7fc6f6; padding-right: 5px; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; min-height: 22px;"
					BorderStyle="Solid" ToolTip="Reports" Enabled="false">
					<asp:Image runat="server" imageurl="~/images/report_16.png" style="vertical-align: middle"/>&nbsp;Reports
				</asp:LinkButton>
				<asp:LinkButton ID="lbDelete" runat="server" OnClick="LbDelete_Click" Style="text-decoration: none; background-color: #7fc6f6; padding-right: 5px; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; min-height: 22px;"
					BorderStyle="Solid" ToolTip="Delete" Enabled="false">
					<asp:Image runat="server" imageurl="~/images/delete_16.png" style="vertical-align: middle"/>&nbsp;Delete
				</asp:LinkButton>
				<asp:LinkButton ID="lbClose" runat="server" OnClick="lbClose_Click" Style="text-decoration: none; background-color: #7fc6f6; font-family: Tahoma; font-size: 14px; color: white; min-height: 22px; padding-left: 5px;"
					BorderStyle="Solid" ToolTip="Close" CssClass="StdBottomR">
					<asp:Image runat="server" imageurl="~/images/Exit_16.png" style="vertical-align: middle"/>&nbsp;Close&nbsp;
				</asp:LinkButton>

				<asp:Label ID="lblUser" runat="server" Text="User" Visible="false"></asp:Label>
				<asp:Label ID="lblGrpUser" runat="server" Text="Grp User" Visible="false"></asp:Label>

			</td>

			<td style="border: 1px solid #000000; min-width: 120px; background-color: lightgray; text-align: center; font-family: 'Segoe UI'; font-size: medium;" >TC: &nbsp;
				<asp:Label ID="lblTC" runat="server" Text=""></asp:Label>

			</td>

		</tr>
		<tr>
			<td style="border: 1px solid #000000; width: auto; background-color: lightgray;" colspan="10"></td>
		</tr>

		<tr style="height: 26px; background-color: lightgray">
			<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Document Type:&nbsp;&nbsp; 
			</td>
			<td style="border: 1px solid #000000; width: 250px; background-color: White; text-align: left; font-family: 'Segoe UI'; font-size: small;">

				<asp:LinkButton ID="lbLoadDocType" runat="server" Style="text-decoration: none; background-color: white; float: right; ">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>

				<asp:DropDownList ID="cboDocType" runat="server" AutoPostBack="true" Width="90%"
					Font-Names="Segoe UI" Font-Size="small" Height="22px" BorderStyle="None" BackColor="White">
				</asp:DropDownList>

			</td>

			<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: right;font-family: 'Segoe UI'; font-size: small;">Doc. No.:&nbsp;&nbsp;
			</td>
			<td style="border: 1px solid #000000; width: 150px; background-color: cornsilk; text-align: center; ">&nbsp;&nbsp;
				<asp:Label ID="txtDocNo" runat="server" Text="" ForeColor="Red"></asp:Label>
			</td>

			<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Authorization:&nbsp;&nbsp;
			</td>

			<td style="border: 1px solid #000000; width: 140px; background-color: White; text-align: left; font-family: 'Segoe UI'; font-size: small;">
				<asp:DropDownList ID="CboStat" runat="server" AutoPostBack="false" Width="98%"
					Font-Names="Segoe UI" Font-Size="small" Height="100%" BorderStyle="None" BackColor="White">
				</asp:DropDownList>
			</td>

			<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Posting Date:&nbsp;&nbsp;
			</td>

			<td style="border: 1px solid #000000; width: auto; background-color: lightgray; text-align: left; padding-left: 2px; font-family: 'Segoe UI'; font-size: small;"colspan="2">
				<asp:TextBox ID="dpPostDate" runat="server" TextMode="Date" Width="120px" Height="20px" Font-Names="Segoe UI"
					Font-Size="small" CssClass="DateBox"></asp:TextBox>

			</td>

			<td style="border: 1px solid #000000; min-width: 120px; background-color: lightgray; text-align: right;"rowspan="5"></td>

		</tr>
		<%--row2--%>
		<tr style="height: 26px; background-color: lightgray">
			<td style="border: 1px solid #000000; min-width: 120px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Vendor:&nbsp;&nbsp;
				
			</td>
			<td style="border: 1px solid #000000; min-width: auto; background-color: cornsilk; text-align: left; font-family: 'Segoe UI'; font-size: small;" colspan="5">&nbsp;&nbsp;
				<asp:Label ID="lblVendor" runat="server" Text="Vendor" ForeColor="Red"></asp:Label>
			</td>
			<td style="border: 1px solid #000000; min-width: 80px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Limit:&nbsp;&nbsp;
			</td>

			<td style="border: 1px solid #000000; min-width: auto; background-color: cornsilk; text-align: left; font-family: 'Segoe UI'; font-size: small;" colspan="2">Php
				<asp:Label ID="lblAutoLimitAmt" runat="server" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
				<asp:LinkButton ID="lbLoadLimit" runat="server" Style="text-decoration: none; background-color: cornsilk; float: left; padding-right: 2px; padding-left: 2px;">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/>
				</asp:LinkButton>
			</td>


		</tr>
		<%--row3--%>
		<tr style="height: 26px; background-color: lightgray">
			<td style="border: 1px solid #000000; min-width: 120px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Amount:&nbsp;&nbsp;
			</td>

			<td style="border: 1px solid #000000; min-width: 120px; background-color: cornsilk; text-align: left; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;
				<asp:Label ID="lblDocAmt" runat="server" Text="0.00" ForeColor="Red"></asp:Label>
			</td>

			<td style="border: 1px solid #000000; min-width: 120px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Department:&nbsp;&nbsp;
				
			</td>
			<td style="border: 1px solid #000000; min-width: 120px; background-color: cornsilk; text-align: left; font-family: 'Segoe UI'; font-size: small;" colspan="3">&nbsp;&nbsp;
				<asp:Label ID="lblDept" runat="server" Text="Department" ForeColor="Red"></asp:Label>
			</td>

			<td style="border: 1px solid #000000; min-width: 80px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Date From:&nbsp;&nbsp;
				
			</td>

			<td style="border: 1px solid #000000; width: 300px; background-color: White; text-align: left; font-family: 'Segoe UI'; font-size: small;" colspan="2">
				<asp:TextBox ID="dpTransDate" runat="server" TextMode="Date" Width="120px" Height="20px" Font-Names="Segoe UI"
					Font-Size="small" CssClass="DateBox" BorderStyle="None" BackColor="White"></asp:TextBox>
			</td>

		</tr>

		<%--row4--%>
		<tr style="height: 26px; background-color: lightgray">
			<td style="border: 1px solid #000000; min-width: 120px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Date Prepared:&nbsp;&nbsp;
				
			</td>
			<td style="border: 1px solid #000000; min-width: 120px; background-color: cornsilk; text-align: left; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;
				<asp:Label ID="lblDatePrep" runat="server" Text="yyyy-MM-dd" ForeColor="Red"></asp:Label>
			</td>

			<td style="border: 1px solid #000000; min-width: 120px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;" rowspan="2">Remarks:&nbsp;&nbsp;
				
			</td>
			<td style="border: 1px solid #000000; min-width: 120px; background-color: cornsilk; text-align: left; vertical-align: top; font-family: 'Segoe UI'; font-size: small;" colspan="3" rowspan="2">&nbsp;&nbsp;
				<asp:Label ID="lblRem" runat="server" Text="Remarks" ForeColor="Red"></asp:Label>

			</td>
			<td style="border: 1px solid #000000; min-width: 80px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Date To:&nbsp;&nbsp; 
				
			</td>

			<td style="border: 1px solid #000000; width: 300px; background-color: lightgray; text-align: left; font-family: 'Segoe UI'; font-size: small;" colspan="2">
				<asp:TextBox ID="dpTransDate2" runat="server" TextMode="Date" Width="120px" Height="20px" Font-Names="Segoe UI"
					Font-Size="small" CssClass="DateBox" BorderStyle="None" BackColor="White"></asp:TextBox>
				&nbsp;
				<asp:LinkButton ID="lbGetStat" runat="server" Style="text-decoration: none; background-color: lightgray; float: inherit; padding-right: 2px;">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/></asp:LinkButton>
				&nbsp; 
			</td>

		</tr>

		<%--row5--%>
		<tr style="height: 26px; background-color: lightgray">
			<td style="border: 1px solid #000000; min-width: 120px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Prepared By:&nbsp;&nbsp;
				
			</td>
			<td style="border: 1px solid #000000; min-width: 120px; background-color: cornsilk; text-align: left; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;
				<asp:Label ID="lblPrepBy" runat="server" Text="Prepared" ForeColor="Red"></asp:Label>
			</td>

			<td style="border: 1px solid #000000; min-width: 80px; background-color: lightgray; text-align: right; font-family: 'Segoe UI'; font-size: small;">Status:&nbsp;&nbsp;
				
			</td>

			<td style="border: 1px solid #000000; width: 300px; background-color: lightgray; text-align: left; font-family: 'Segoe UI'; font-size: small; padding-bottom: 2px;" colspan="2">
				<asp:DropDownList ID="cboStatList" runat="server" AutoPostBack="true" Width="124px"
					Font-Names="Segoe UI" Font-Size="small" Height="22px" BorderStyle="None" BackColor="White">
					<asp:ListItem>PARKED</asp:ListItem>
					<asp:ListItem>NOTED</asp:ListItem>
					<asp:ListItem>POSTED</asp:ListItem>
				</asp:DropDownList>
				&nbsp; 
				<%--<asp:CheckBox ID="CheckBox1" runat="server" Text="Include PARK"/> &nbsp;--%>

				<asp:LinkButton ID="lbGetStatList" runat="server" Style="text-decoration: none; background-color: lightgray; float: inherit;">
					<asp:Image runat="server" imageurl="~/images/check_16.png" style="vertical-align: middle"/></asp:LinkButton>
				&nbsp; 
			</td>
		</tr>

		<tr>
			<td style="border: 1px solid #000000; width: auto; height: auto; background-color: lightgray; text-align: center;" colspan="10">
			</td>
		</tr>
			
		<tr>
			<td style="border: 1px solid #000000; width: auto; height: auto; background-color: floralwhite; text-align: left;" colspan="10">
				<%--<asp:ScriptManager ID="ScriptManager1" runat="server" >
				</asp:ScriptManager>--%>
				
				<asp:Panel ID="Panel1" runat="server" Width="100%">
					<asp:GridView ID="DgvReport" runat="server" AutoGenerateColumns="False" OnRowDataBound="DgvReport_RowDataBound"
							OnRowCreated="DgvReport_RowCreated" OnSelectedIndexChanged="DgvReport_SelectedIndexChanged" Font-Names="Segoe UI" Font-Size="small" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" CellPadding="3" ShowHeader="true" GridLines="Vertical">
						<AlternatingRowStyle BackColor="#DCDCDC" />
							<Columns>
								<asp:CommandField ShowSelectButton="true" HeaderText="Post">
									<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="60px"></ItemStyle>
								</asp:CommandField>

								<asp:BoundField DataField="docno" HeaderText="Doc. No.">
									<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
								</asp:BoundField>
								<asp:BoundField DataField="TC" HeaderText="TC">
									<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="50px"></ItemStyle>
								</asp:BoundField>

								<asp:BoundField DataField="transdate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}">
									<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
								</asp:BoundField>

								<asp:BoundField DataField="venno" HeaderText="Vendor No.">
									<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="80px"></ItemStyle>
								</asp:BoundField>

								<asp:BoundField DataField="payee" HeaderText="Vendor Name">
									<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="400" Wrap="true"></ItemStyle>
								</asp:BoundField>

								<asp:BoundField DataField="docamt" HeaderText="Amount" DataFormatString="{0:#,##0.00;(#,##0.00)}">
									<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
								</asp:BoundField>

								<asp:BoundField DataField="remarks" HeaderText="Remarks">
									<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="200px"></ItemStyle>
								</asp:BoundField>

								<asp:BoundField DataField="branch" HeaderText="Department">
									<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="300px"></ItemStyle>
								</asp:BoundField>

							</Columns>

							<FooterStyle BackColor="#CCCCCC" ForeColor="Black" BorderStyle="Solid" />
							<HeaderStyle BackColor="#007acc" Font-Bold="True" ForeColor="White" Height="24px"/>
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
						$('#<%=DgvReport.ClientID %>').Scrollable({
							ScrollHeight: 610,
							IsInPanel: true
						});
					});
				</script>
			
			</td>
		</tr>

	</table>
	

	
</asp:Content>

