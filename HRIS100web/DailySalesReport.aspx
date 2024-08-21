<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/FI.master" CodeBehind="DailySalesReport.aspx.vb" Inherits="AOS100web.DailySalesReport" %>

<%@ Register Assembly="EditableDropDownList" Namespace="EditableControls" TagPrefix="editable" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentOfFinAcctg" runat="server">
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
			confirm_value.name = "confirm_value2";
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
			confirm_value.name = "confirm_value3";
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
			confirm_value.name = "confirm_value4";
			if (confirm_value("Are you SURE to UNLOAD DSR?")) {
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
			<td style="background-color: #b1bbd7; border-top: solid; border-bottom: solid; border-color: red; border-width: 2px; width: 100%; font-family: 'Segoe UI'; font-size: 10px; text-align: center; min-height: 28px; max-height: 28px; padding-bottom: 1px;" colspan="6">
				<asp:LinkButton ID="lbNew" runat="server" OnClick="lbNew_Click" Style="text-decoration: none; background-color: #7fc6f6; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; padding-right: 5px; min-height: 22px;" BorderStyle="Solid" ToolTip="Reset Fields" CssClass="StdBottomL">
					<asp:Image runat="server" imageurl="~/images/new_16.png" style="vertical-align: middle"/>&nbsp;New
				</asp:LinkButton>
				<asp:LinkButton ID="lbSave" runat="server" Style="text-decoration: none; background-color: #7fc6f6; padding-right: 5px; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; min-height: 22px;" BorderStyle="Solid" ToolTip="Save" Enabled="false">
					<asp:Image runat="server" imageurl="~/images/save_orange_16.png" style="vertical-align: middle"/>&nbsp;Save
				</asp:LinkButton>
				<asp:LinkButton ID="lbPrint" runat="server" Style="text-decoration: none; background-color: #7fc6f6; padding-right: 5px; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; min-height: 22px;"
					BorderStyle="Solid" ToolTip="Print" Enabled="false">
					<asp:Image runat="server" imageurl="~/images/Print_16.png" style="vertical-align: middle"/>&nbsp;Print
				</asp:LinkButton>
				<asp:LinkButton ID="lbDelete" runat="server" Style="text-decoration: none; background-color: #7fc6f6; padding-right: 5px; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; min-height: 22px;" BorderStyle="Solid" ToolTip="Void" Enabled="false">
					<asp:Image runat="server" imageurl="~/images/delete_16.png" style="vertical-align: middle"/>&nbsp;Void
				</asp:LinkButton>
				<asp:LinkButton ID="lbClose" runat="server" OnClick="OnConfirm4"  OnClientClick="Confirm4()" Style="text-decoration: none; background-color: #7fc6f6; font-family: Tahoma; font-size: 14px; color: white; min-height: 22px; padding-left: 5px;"
					BorderStyle="Solid" ToolTip="Close" CssClass="StdBottomR">
					<asp:Image runat="server" imageurl="~/images/Exit_16.png" style="vertical-align: middle"/>&nbsp;Close&nbsp;
				</asp:LinkButton>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<asp:Label ID="lblUser" runat="server" Text="User" Visible="false"></asp:Label>
				<asp:Label ID="lblGrpUser" runat="server" Text="Grp User" Visible="false"></asp:Label>

			</td>
		</tr>
		<tr>
			<td style="border: 1px solid #000000; width: auto; background-color: lightgray;" colspan="6"></td>
		</tr>

		<%--<tr>
			<td style="border: 1px solid #000000; width: 500px; height: 30px; background-color: lightgray;" colspan="3">&nbsp;&nbsp;
				<asp:Label ID="lblTitle" runat="server" Text="Reports" Font-Size="Larger" Font-Italic="true" ForeColor="Red"></asp:Label>
			</td>
			<td style="border: 1px solid #000000; width: 600px; height: 30px; background-color: lightgray;" colspan="3">&nbsp;&nbsp;
				<asp:Label ID="lblMsg" runat="server" Text="Message Box" Font-Size="Medium" Font-Italic="true" ForeColor="Red"></asp:Label>
			</td>
		</tr>--%>
	</table>

	<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: whitesmoke; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
		<tr style="height: 26px; background-color: whitesmoke;">
			<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Salesman:&nbsp;&nbsp;
			</td>
			<td style="border: 1px solid #000000; width: 180px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
				<asp:DropDownList ID="cboSmnName" runat="server" BorderStyle="None" BackColor="White" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" Width="98%">
				</asp:DropDownList>
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">DSR Date:&nbsp;&nbsp;
			</td>
			<td style="border: 1px solid #000000; width: 80px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
				<asp:TextBox ID="dpTransDateDSR" runat="server" TextMode="Date" BorderStyle="None" BackColor="White" Height="20px" Font-Names="Segoe UI" Font-Size="small" CssClass="DateBox" Width="95%" AutoPostBack="true"></asp:TextBox>
				
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">DSR No.:&nbsp;&nbsp;
			</td>
			<td style="border: 1px solid #000000; width: 100px; background-color: #ffff99; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
				<asp:TextBox ID="txtDSRNo" runat="server" Font-Names="Segoe UI" Font-Size="small" ReadOnly="false" AutoPostBack="true" BorderStyle="None" BackColor="#ffff99" CssClass="TxtBox" Height="100%" Width="99%"></asp:TextBox>
			</td>
			<td style="width: 80px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
			<td style="width: 80px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
			<td style="width: 300px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

		</tr>
		<tr style="height: 2px; background-color: whitesmoke;">
			<td style="width: 100%; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="12"></td>

		</tr>
		<tr style="height: 26px; background-color: whitesmoke;">
			<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
			<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">DSR Status:&nbsp;&nbsp;
			</td>
			<td style="border: 1px solid #000000; width: 180px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
				<asp:DropDownList ID="cboStat" runat="server" BorderStyle="None" BackColor="White" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" Width="98%">
				</asp:DropDownList>
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
			<td style="width: 80px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Customer No.:&nbsp;&nbsp;
			</td>
			<td style="width: 80px; background-color: whitesmoke; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
				<asp:Label ID="lblCustNo" runat="server" Text="00000" ForeColor="Red"></asp:Label>
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
			<td style="width: 80px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Area No.:&nbsp;&nbsp;
			</td>
			<td style="width: 100px; background-color: whitesmoke; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
				<asp:Label ID="lblAreaNo" runat="server" Text="000" ForeColor="Red"></asp:Label>
			</td>


			<td style="width: auto; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="3"></td>

			<td style="width: 300px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

		</tr>

	</table>

	<ajaxToolkit:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" Style="width: 99%; height: auto;">
		<ajaxToolkit:TabPanel ID="TabPage1" runat="server" HeaderText="Delivery Order">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: whitesmoke; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<%--L1--%>
					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">DO No.:&nbsp;&nbsp;
						</td>
						<td style="border: 1px solid #000000; width: 180px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<%--<asp:DropDownList ID="cboDONo" runat="server" Font-Names="Segoe UI" Font-Size="small" Width="98%" BorderStyle="None" BackColor="White" AutoPostBack="true"  >
							</asp:DropDownList>--%>
							<asp:TextBox ID="txtDONo" runat="server" BackColor="White" BorderStyle="None" Font-Names="Segoe UI" Font-Size="small" AutoPostBack="true" CssClass="txtBoxC"></asp:TextBox>

						</td>
						<td style="width: auto; background-color: whitesmoke; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small; vertical-align: middle" colspan="5">&nbsp;&nbsp;&nbsp;
							<asp:ImageButton ID="lbOpenDO" runat="server" ImageUrl="~/images/list_20.png" ToolTip="Open DO List" CssClass="ImgBtn2" />
							&nbsp;&nbsp;&nbsp;

							<asp:ImageButton ID="cmdAddDO" runat="server" ImageUrl="~/images/add_doc_20.png" ToolTip="Add DO" CssClass="ImgBtn2" />
							&nbsp;&nbsp;&nbsp;

							<asp:ImageButton ID="cmdRemDO" runat="server" ImageUrl="~/images/rem_doc_20.png" ToolTip="Remove DO"  CssClass="ImgBtn2" />

							<%--<asp:Button ID="cmdAddDO" runat="server" Text="Add DO" Width="100" Height="22" BorderStyle="None" BackColor="Green" ForeColor="White" AutoPostBack="true" />--%>
													
							<%--<asp:Button ID="cmdRemDO" runat="server" Text="Remove DO" Width="100" Height="22" BorderStyle="None" BackColor="Red" ForeColor="White" AutoPostBack="true" />--%>

						</td>

						<td style="width: 80px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="width: 300px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

					</tr>
					<%--L2--%>
					<tr style="height: 2px; background-color: whitesmoke;">
						<td style="width: 100%; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="16"></td>

					</tr>
					<%--L3--%>
					<tr style="height: 620px; background-color: whitesmoke;">
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 1px; background-color: floralwhite; text-align: center; padding-left: 0px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small; vertical-align:top;" colspan="8">
							<asp:Panel ID="PandgvDOlist" runat="server" ScrollBars="Auto" Visible="false" CssClass="PanelStd">
								<asp:GridView ID="dgvDOlist" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvDOlist_RowDataBound" OnRowCreated="dgvDOlist_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="True" CssClass="Grid1" >
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:CommandField ShowSelectButton="True">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="74px"></ItemStyle>
										</asp:CommandField>
										<asp:BoundField DataField="dono">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="transdate" DataFormatString="{0:yyyy-MM-dd}">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="plntno">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="350px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="totqty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="totwt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
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

							<asp:Panel ID="PanDgvDOdet" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="DgvDOdet" runat="server" AutoGenerateColumns="False" OnRowDataBound="DgvDOdet_RowDataBound"
									OnRowCreated="DgvDOdet_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="True" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:BoundField DataField="codeno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="119px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="mmdesc">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="471px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="qty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="wt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
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

						<td style="border: 1px solid #000000; width: 646px; background-color: floralwhite; text-align: center; padding-left: 2px; font-family: 'Segoe UI'; font-size: small; vertical-align: top" colspan="7" rowspan="2">
							<asp:Panel ID="Panel5" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="dgvDOdsr" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvDOdsr_RowDataBound"
									OnRowCreated="dgvDOdsr_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="true" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:BoundField HeaderText="DO No."  DataField="dono">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField HeaderText="Date" DataField="transdate" DataFormatString="{0:yyyy-MM-dd}">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField HeaderText="Qty/Hds" DataField="totqty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField HeaderText="Wt/Kgs" DataField="totwt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField HeaderText="Plant No."  DataField="plntno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
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

					</tr>
					<%--L4--%>
					<tr style="height: 26px; background-color: whitesmoke;">
						<%--C1--%>
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<%--C2 to C7--%>
						<td style="border: 1px solid #000000; width: 580px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="6">Total&nbsp;&nbsp; 
						</td>

						<%--C8--%>
						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotQtyDSR" runat="server" Text="0" ForeColor="Red"></asp:Label>&nbsp;&nbsp;

						</td>
						<%--C9--%>
						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotWtDSR" runat="server" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;

						</td>
					</tr>
				</table>
			</ContentTemplate>

		</ajaxToolkit:TabPanel>

		<%--SO List--%>
		<ajaxToolkit:TabPanel ID="TabPage10" runat="server" HeaderText="Sales Data Entry">
			<ContentTemplate>
				<table style="width: 100%; font-family: sans-serif; font-size: small; float: left; background-color: whitesmoke; border-spacing: 1px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<%--line1--%>
					<tr style="height: 26px; background-color: lightgray">
						<%--R1C1--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Inv Type:&nbsp;&nbsp;
						</td>

						<%--R1C2--%>
						<td style="border: 1px solid #000000; width: 100px; background-color: White; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:DropDownList ID="cboInv" runat="server" BorderStyle="None" BackColor="White" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox2" Width="98%">
							</asp:DropDownList>

						</td>

						<%--R1C3--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Inv. No.:&nbsp;&nbsp;
						</td>

						<%--R1C4--%>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtInvNo" runat="server" BackColor="White" BorderStyle="None" Font-Names="Segoe UI" Font-Size="small" AutoPostBack="true" CssClass="txtBoxC"></asp:TextBox>
						</td>

						<%--R1C5--%>
						<td style="width: 130px; background-color: whitesmoke; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;DSR No.:&nbsp;&nbsp;
							<asp:Label ID="lblDSRNo" runat="server" Text="00000" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>

						<%--R1C6--%>
						<td style="width: 80px; background-color: whitesmoke; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">BA Chrg:&nbsp;&nbsp;</td>

						<%--R1C7--%>
						<td style="width: 120px; background-color: whitesmoke; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;
							<asp:Label ID="lblBAto" runat="server" Text="0000" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>

						<%--R1C8--%>
						<td style="width: 80px; background-color: whitesmoke; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Branch:&nbsp;&nbsp;</td>

						<%--R1C9--%>
						<td style="width: 120px; background-color: whitesmoke; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;
							<asp:Label ID="lblBranchTo" runat="server" Text="Branch" ForeColor="Red"></asp:Label>
						</td>

						<%--R1C10--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Gross Amount:&nbsp;&nbsp;</td>

						<%--R1C11--%>
						<td style="border: 1px solid #000000; width: 120px; background-color: cornsilk; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblGrossAmt" runat="server" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>
					</tr>

					<%--line2--%>
					<tr style="height: 26px; background-color: lightgray">
						<%--L2C1--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Inv Date:&nbsp;&nbsp;

						</td>

						<%--L2C2--%>
						<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="dpSalesDate" runat="server" BackColor="White" TextMode="Date" Height="99%" Font-Names="Segoe UI"
								Font-Size="small" BorderStyle="None" CssClass="DateBox" Width="96%"></asp:TextBox>

						</td>

						<%--L2C3--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Salesman:&nbsp;&nbsp;
						</td>

						<%--L2C4to5--%>
						<td style="border: 1px solid #000000; width: 250px; background-color: white; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="2">
							<asp:DropDownList ID="cboSalesSmn" runat="server" BorderStyle="None" BackColor="White" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox2" Width="98%">
							</asp:DropDownList>&nbsp;
						</td>

						<%--L2C6--%>
						<td style="width: 80px; background-color: whitesmoke; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Area:&nbsp;&nbsp;
						</td>

						<%--L2C7--%>
						<td style="width: 120px; background-color: whitesmoke; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;
							<asp:Label ID="lblArea" runat="server" Text="000" ForeColor="Red"></asp:Label>&nbsp;&nbsp;

						</td>
						<%--L2C8--%>
						<td style="width: 80px; background-color: whitesmoke; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Term:&nbsp;&nbsp;</td>
						<%--L2C9--%>
						<td style="width: 120px; background-color: whitesmoke; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;
							<asp:Label ID="lblTerm" runat="server" Text="00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;

						</td>
						<%--L2C10--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:CheckBox ID="CheckBox2" runat="server" ToolTip="Check If VATable" AutoPostBack="true" />
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;VAT:&nbsp;&nbsp;</td>
						<%--L2C11--%>
						<td style="border: 1px solid #000000; width: 120px; background-color: cornsilk; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTaxes" runat="server" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>

					</tr>

					<%--line3--%>
					<tr style="height: 26px; background-color: lightgray">
						<%--L3C1--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Sold To:&nbsp;&nbsp;
						</td>

						<%--L3C2to5--%>
						<td style="border: 1px solid #000000; width: 430px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="4">
							<asp:DropDownList ID="cboCustName" runat="server" BorderStyle="None" BackColor="White" AutoPostBack="true" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox3" Width="99%">
							</asp:DropDownList>

						</td>

						<%--L3C6--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">PC:&nbsp;&nbsp;
				
						</td>

						<%--L3C7to8--%>
						<td style="border: 1px solid #000000; width: 200px; background-color: white; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="2">
							<asp:DropDownList ID="cboPC" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox2" Width="98%">
							</asp:DropDownList>
						</td>

						<%--L3C9--%>
						<td style="width: 120px; background-color: whitesmoke; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblCustType" runat="server" BackColor="WhiteSmoke" Text="Customer" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>
						<%--L3C10--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: white; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:DropDownList ID="cboAddl" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox2" Width="98%">
							</asp:DropDownList>
						</td>
						<%--L3C11--%>
						<td style="border: 1px solid #000000; width: 120px; background-color: cornsilk; text-align: right; padding-left: 1px; padding-right: 8px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtFHamt" runat="server" Font-Names="Segoe UI" Font-Size="Small" Text="0.00" ReadOnly="true" AutoPostBack="true" BackColor="Cornsilk" BorderStyle="None" CssClass="txtAmtBox"></asp:TextBox>

						</td>

					</tr>
					<%--line4--%>
					<tr style="height: 26px; background-color: lightgray">
						<%--L4C1--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Ship To:&nbsp;&nbsp;
						</td>
						<%--L4C2to5--%>
						<td style="border: 1px solid #000000; width: 430px; background-color: white; text-align: left; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="4">
							<asp:DropDownList ID="cboShipTo" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="small" CssClass="cboBox3" Width="99%">
							</asp:DropDownList>

						</td>
						<%--L4C6--%>
						<td style="width: 80px; background-color: whitesmoke; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">&nbsp;
				<asp:Label ID="lblCustVat" runat="server" BackColor="WhiteSmoke" Text="NV" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>
						<%--L4C7--%>
						<td style="border: 1px solid #000000; width: 120px; background-color: deepskyblue; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="3" rowspan="2">Error Message: <
				<asp:Label ID="tssErrorMsg" runat="server" Text="Okay" ForeColor="White" Font-Size="Medium"></asp:Label>
							>
						</td>
						<%--L4C8to10--%>
						<td style="border: 1px solid #000000; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: medium;">Net Invoice:&nbsp;&nbsp;
						</td>
						<%--L4C11--%>
						<td style="border: 1px solid #000000; width: 120px; background-color: cornsilk; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="txtDeductn" runat="server" BorderStyle="None" BackColor="Cornsilk" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>
					</tr>
					<%--line5--%>
					<tr style="height: 26px; background-color: lightgray">
						<%--1--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Ref No:&nbsp;&nbsp;
						</td>
						<%--2--%>
						<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtRefNo" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="small" AutoPostBack="true" CssClass="TxtBox"></asp:TextBox>
						</td>
						<%--3--%>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Remarks:&nbsp;&nbsp;
				
						</td>
						<%--4to6--%>
						<td style="border: 1px solid #000000; width: auto; background-color: white; text-align: left; padding-left: 1px; padding-right: 2px; font-family: 'Segoe UI'; font-size: small;" colspan="3">
							<asp:TextBox ID="txtRemarks" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="small" CssClass="txtBoxL"></asp:TextBox>
						</td>
						<%--10--%>
						<td style="border: 1px solid #000000; background-color: lightgray; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">Net Invoice:&nbsp;&nbsp;
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: cornsilk; text-align: right; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblNetAmt" runat="server" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>

					</tr>

					<tr>
						<%--red line--%>
						<td style="border: 1px solid #000000; width: auto; height: auto; background-color: red;" colspan="12"></td>
					</tr>

				</table>

				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: lightgrey; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<tr style="height: 26px; background-color: lightgray">
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" rowspan="2">Select</td>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Item No.</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Code No.</td>
						<td style="border: 1px solid #000000; width: 450px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="3">
							Description &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<asp:Label ID="lblQtPk" runat="server" Text="0" ForeColor="Red"></asp:Label>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Qty
							
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Wt/Vol
							
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Amount</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Disc
							
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Net Amount
						</td>

						<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblVNV" runat="server" Text="NV" ForeColor="Black"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 25px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" rowspan="2">
							<%--here--%>
							<asp:Label ID="lblBillRef" runat="server" Text="Wt" ForeColor="Red"></asp:Label>
						</td>

					</tr>
					<tr style="height: 26px; background-color: white">
						<td style="border: 1px solid #000000; width: 80px; background-color: white; text-align: center; padding-left: 1px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtItmSI" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" Text="1" AutoPostBack="true" CssClass="TxtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 1px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtCodeNoSI" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="TxtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 450px; background-color: white; text-align: center; font-family: 'Segoe UI'; font-size: small;" colspan="3">
							<asp:DropDownList ID="cboMMdescSI" runat="server" BorderStyle="None" BackColor="White" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" CssClass="cboBox"></asp:DropDownList>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtQtySI" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="txtAmtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtWtSI" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="txtAmtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtSP" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="txtAmtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">

							<asp:Label ID="lblGrossAmtDet" runat="server" BackColor="White" Text="0.00" CssClass="lblLabelAmt"></asp:Label>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtDiscDet" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" ReadOnly="true" CssClass="txtAmtBox"></asp:TextBox>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblNetAmtDet" runat="server" BackColor="White" Text="0.00" CssClass="lblLabelAmt"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="txtVATamt" runat="server" BorderStyle="None" BackColor="White" Text="0.00" CssClass="lblLabelAmt"></asp:Label>
						</td>

					</tr>

					<tr style="height: auto; background-color: lightgray">
						<td style="border: 1px solid #000000; height: 427px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small; vertical-align: top; margin-left: 0px" colspan="13">
							<asp:Panel ID="Panel2" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="DgvSalesdet" runat="server" AutoGenerateColumns="False" OnRowDataBound="DgvSalesdet_RowDataBound" OnRowCreated="DgvSalesdet_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="False" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:CommandField ShowSelectButton="True">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="74px"></ItemStyle>
										</asp:CommandField>
										<asp:BoundField DataField="itemno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="84px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="codeno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="124px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="mmdesc">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="388px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="qty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="126px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="wt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="126px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="sp" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="123px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="itmamt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="122px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="detdiscamt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="123px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="detgrossamt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>

										<asp:BoundField DataField="detvat" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="100px"></ItemStyle>
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
							<asp:ImageButton ID="btnDel" runat="server" ImageUrl="~/images/delete_16.png" />

						</td>

					</tr>

					<tr style="height: 26px; background-color: lightgray">

						<td style="border: 1px solid #000000; width: auto; background-color: lightgray; text-align: center; font-family: 'Segoe UI'; font-size: small;" colspan="6">
							<%--<asp:TextBox ID="txtApprvdBy" runat="server" Text="" Font-Names="Segoe UI" Font-Size="small" CssClass="TxtBox" Width="120px"></asp:TextBox>--%>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							Total &nbsp;&nbsp;
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblSalesTotQty" runat="server" Text="0" ForeColor="Red" CssClass="lblLabelAmt"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblSalesTotWt" runat="server" Text="0.00" ForeColor="Red" CssClass="lblLabelAmt"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotGross" runat="server" CssClass="lblLabelAmt" ForeColor="Red" Text="0.00"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotDisc" runat="server" Text="0.00" ForeColor="Red" CssClass="lblLabelAmt"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotNetAmt" runat="server" Text="0.00" ForeColor="Red" CssClass="lblLabelAmt"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 100px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotVatAmt" runat="server" Text="0.00" ForeColor="Red" CssClass="lblLabelAmt"></asp:Label>
						</td>

						<td style="border: 1px solid #000000; width: 25px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

					</tr>

					<tr style="height: auto; background-color: lightgray">
						<td style="border: 1px solid #000000; height: 20px; background-color: lightgray; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="14">&nbsp;&nbsp; 
							Save Status:&nbsp;&nbsp;
							<asp:Label ID="tsSaveStat" runat="server" Text="Not yet Saved" ForeColor="Red"></asp:Label>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
							Doc Status: &nbsp;&nbsp;
							<asp:Label ID="tssDocStat" runat="server" Text="New" ForeColor="Red"></asp:Label>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
							Edit Doc No.: &nbsp;&nbsp;
							<asp:Label ID="tsDocNoEdit" runat="server" Text="" ForeColor="Red"></asp:Label>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
							<asp:Label ID="tssVoidReqNo" runat="server" Text="" ForeColor="Red"></asp:Label>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
							Price Type:&nbsp;&nbsp
							<asp:Label ID="lblSPtype" runat="server" Text="Customer" ForeColor="Red"></asp:Label>
							<%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bill Ref: &nbsp;&nbsp;--%>
			
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Line Item: &nbsp;&nbsp;
				<asp:Label ID="lblLineItm" runat="server" Text="New" ForeColor="Red"></asp:Label>

						</td>
					</tr>


				</table>

			</ContentTemplate>

		</ajaxToolkit:TabPanel>

		<ajaxToolkit:TabPanel ID="TabPage2" runat="server" HeaderText="Invoices(84/85)">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: whitesmoke; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<%--L1--%>
					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="width: 80px; background-color: whitesmoke; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="7">&nbsp;&nbsp;Invoice List Option:&nbsp;&nbsp;
						<asp:RadioButton ID="RBtcAll" runat="server" GroupName="Tab2" Text="ALL" ToolTip="ALL" />&nbsp;&nbsp;
						<asp:RadioButton ID="RBtc84" runat="server" GroupName="Tab2" Text="ETCSI" ToolTip="Total ETCSI" />&nbsp;&nbsp;
						<asp:RadioButton ID="RBtc85" runat="server" GroupName="Tab2" Text="ETCI" ToolTip="Total ETCI" />

						</td>

						<td style="width: 80px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="width: 300px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

					</tr>
					<%--L2--%>
					<tr style="height: 2px; background-color: whitesmoke;">
						<td style="width: 100%; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="16"></td>

					</tr>
					<%--L3--%>
					<tr style="height: 620px; background-color: whitesmoke;">
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 1px; background-color: floralwhite; text-align: center; padding-left: 0px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="8">
							<asp:Panel ID="Panel4" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="dgvTC8485" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvTC8485_RowDataBound" OnRowCreated="dgvTC8485_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="True" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:BoundField DataField="itmno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="79px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="codeno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="119px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="mmdesc">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="471px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="qty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="wt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
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

						<td style="width: 346px; background-color: whitesmoke; text-align: center; padding-left: 2px; font-family: 'Segoe UI'; font-size: small;" colspan="7" rowspan="2"></td>

					</tr>
					<%--L4--%>
					<tr style="height: 26px; background-color: whitesmoke;">
						<%--C1--%>
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<%--C2 to C8--%>
						<td style="border: 1px solid #000000; width: 880px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="7">Total&nbsp;&nbsp; 
						
						</td>


						<%--C9--%>
						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;">

							<asp:Label ID="lblInvTot" runat="server" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;

						</td>

					</tr>


				</table>


			</ContentTemplate>

		</ajaxToolkit:TabPanel>


		<%--SO Monitoring--%>
		<ajaxToolkit:TabPanel ID="TabPage3" runat="server" HeaderText="Remittance Report">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: whitesmoke; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<tr style="height: 50px; background-color: whitesmoke;">
						<td style="width: 50px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: large;" colspan="2">
							<asp:Label ID="Label1" runat="server" Text="Remittance Report (A/R Setup Salesman)" ForeColor="Red" Font-Size="Large"></asp:Label>&nbsp;&nbsp;
						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;"></td>


						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: large;" colspan="2">
							<asp:Label ID="Label4" runat="server" Text="Sales Summary" ForeColor="Red" Font-Size=""></asp:Label>&nbsp;&nbsp;
						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 1px; font-family: 'Segoe UI'; font-size: small;"></td>
					</tr>

					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="width: 50px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="width: 150px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">Total Cash Sales (TC84):&nbsp;&nbsp;
						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">
							<asp:Label ID="lblRRtot84" runat="server" Text="0.00" ForeColor="Black"></asp:Label>&nbsp;&nbsp;
						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="width: 150px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">Total Cash Sales (TC84):&nbsp;&nbsp;

						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">
							<asp:Label ID="lblTot84" runat="server" Text="0.00" ForeColor="Black"></asp:Label>&nbsp;&nbsp;

						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
					</tr>

					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="width: 50px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="width: 150px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">Total Cash Sales per DSR:&nbsp;&nbsp;
						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">
							<asp:TextBox ID="txtRRAmt" runat="server" Font-Names="Segoe UI" Font-Size="Medium" ReadOnly="false" AutoPostBack="true" CssClass="TxtBox" BorderStyle="None" BackColor="#ffff99"></asp:TextBox>

						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="width: 150px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">Total Charge Sales (TC85):&nbsp;&nbsp;

						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">
							<asp:Label ID="lblTot85" runat="server" Text="0.00" ForeColor="Black"></asp:Label>&nbsp;&nbsp;

						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
					</tr>

					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="width: 50px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="width: 150px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">Variance:&nbsp;&nbsp;

						</td>

						<td style="border-top: 1px solid #000000; border-bottom: double #000000; width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">
							<asp:Label ID="lblVarRR" runat="server" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="width: 150px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">Total Sales:&nbsp;&nbsp;
						</td>

						<td style="border-top: 1px solid #000000; border-bottom: double #000000; width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">
							<asp:Label ID="lblTotalSales" runat="server" Text="0.00" ForeColor="Black"></asp:Label>&nbsp;&nbsp;
						</td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

						<td style="width: 150px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
					</tr>

					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="width: 50px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="8"></td>

					</tr>

					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="width: 50px; background-color: whitesmoke; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;" colspan="8">&nbsp;&nbsp;
							<asp:Label ID="Label8" runat="server" Text="Exception Report" ForeColor="Red" Font-Size="Large"></asp:Label>

						</td>
					</tr>

					<tr style="height: 204px; background-color: whitesmoke;">
						<td style="border: 1px solid #000000; width: 400px; background-color: whitesmoke; text-align: left; padding-left: 5px; padding-top: 2px; font-family: 'Segoe UI'; font-size: small; vertical-align: top;vertical-align:middle; " colspan="4">
							<asp:TextBox ID="txtExcepRep" runat="server" Font-Names="Segoe UI" Font-Size="small" ReadOnly="false" AutoPostBack="true" BorderStyle="None" BackColor="#ffff99" TextMode="MultiLine" Height="200px" MaxLength="255" Width="98%"></asp:TextBox>

						</td>
						<td style="width: 400px; background-color: whitesmoke; text-align: left; padding-left: 5px; padding-top: 2px; font-family: 'Segoe UI'; font-size: small; vertical-align: top" colspan="4">
							

						</td>

					</tr>

					<tr style="height: 281px; background-color: whitesmoke;">
						<td style="width: auto; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="8"></td>
					</tr>
				</table>
			</ContentTemplate>

		</ajaxToolkit:TabPanel>

		<ajaxToolkit:TabPanel ID="TabPage4" runat="server" HeaderText="WRR">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: whitesmoke; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<%--L1--%>
					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">WRR No.:&nbsp;&nbsp;
						</td>
						<td style="border: 1px solid #000000; width: 180px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtWRRNo" runat="server" BackColor="White" BorderStyle="None" Font-Names="Segoe UI" Font-Size="small" AutoPostBack="true" CssClass="txtBoxC"></asp:TextBox>

							<%--<asp:DropDownList ID="cboWRRNo" runat="server" AutoPostBack="true" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="small" Width="98%">
							</asp:DropDownList>--%>
						</td>
						<td style="width: auto; background-color: whitesmoke; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small; vertical-align: middle" colspan="5">&nbsp;&nbsp;&nbsp;
							<asp:ImageButton ID="lbWRRlist" runat="server" ImageUrl="~/images/list_20.png" ToolTip="Open WRR List" CssClass="ImgBtn2" />
							&nbsp;&nbsp;&nbsp;

							<asp:ImageButton ID="Button3" runat="server" ImageUrl="~/images/add_doc_20.png" ToolTip="Add WRR" CssClass="ImgBtn2" />
							&nbsp;&nbsp;&nbsp;
							<asp:ImageButton ID="Button1" runat="server" ImageUrl="~/images/rem_doc_20.png" ToolTip="Remove WRR"  CssClass="ImgBtn2" />

							<%--<asp:Button ID="Button3" runat="server" Text="Add WRR" Width="100" Height="22" BorderStyle="None" BackColor="Green" ForeColor="White" AutoPostBack="true" />
							&nbsp;&nbsp;&nbsp;
							<asp:Button ID="Button1" runat="server" Text="Remove WRR" Width="100" Height="22" BorderStyle="None" BackColor="Red" ForeColor="White" AutoPostBack="true" />--%>

						</td>

						<td style="width: 80px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="width: 300px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>

					</tr>
					<%--L2--%>
					<tr style="height: 2px; background-color: whitesmoke;">
						<td style="width: 100%; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="16"></td>

					</tr>
					<%--L3--%>
					<tr style="height: 620px; background-color: whitesmoke;">
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 1px; background-color: floralwhite; text-align: center; padding-left: 0px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small; vertical-align: top" colspan="8">
							<asp:Panel ID="PandgvWRRlist" runat="server" ScrollBars="Auto" Visible="false" CssClass="PanelStd">
								<asp:GridView ID="dgvWRRlist" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvWRRlist_RowDataBound" OnRowCreated="dgvWRRlist_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="True" CssClass="Grid1" >
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:CommandField ShowSelectButton="True">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="74px"></ItemStyle>
										</asp:CommandField>
										<asp:BoundField DataField="wrrno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="transdate" DataFormatString="{0:yyyy-MM-dd}">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="plntno">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="350px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="totqty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="totwt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
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

							<asp:Panel ID="PandgvWRR" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="dgvWRR" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvWRR_RowDataBound"
									OnRowCreated="dgvWRR_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="False" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:BoundField DataField="codeno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="119px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="mmdesc">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="471px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="qty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="wt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="plntno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="350px"></ItemStyle>
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

						<td style="border: 1px solid #000000; width: 646px; background-color: floralwhite; text-align: center; padding-left: 2px; font-family: 'Segoe UI'; font-size: small;" colspan="7" rowspan="2">
							<asp:Panel ID="Panel6" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="dgvWRRhdr" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvWRRhdr_RowDataBound" OnRowCreated="dgvWRRhdr_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="True" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:BoundField HeaderText="WRR No."  DataField="wrrno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField HeaderText="Date" DataField="transdate" DataFormatString="{0:yyyy-MM-dd}">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField HeaderText="Qty/Hds" DataField="totqty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField HeaderText="Wt/Kgs" DataField="totwt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
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

					</tr>
					<%--L4--%>
					<tr style="height: 26px; background-color: whitesmoke;">
						<%--C1--%>
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<%--C2 to C7--%>
						<td style="border: 1px solid #000000; width: 580px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="6">Total&nbsp;&nbsp; 
						</td>


						<%--C8--%>
						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotWRRqtyDSR" runat="server" Text="0" ForeColor="Red"></asp:Label>&nbsp;&nbsp;

						</td>
						<%--C9--%>
						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotWRRwtDSR" runat="server" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;

						</td>

					</tr>


				</table>

			</ContentTemplate>

		</ajaxToolkit:TabPanel>

		<ajaxToolkit:TabPanel ID="TabPage5" runat="server" HeaderText="Panel Stock">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: lightgray; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<tr style="height: 26px; background-color: lightgray">
						<td style="border: 1px solid #000000; width: 60px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" rowspan="2">Select</td>
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Item No.</td>
						<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Code No.</td>
						<td style="border: 1px solid #000000; width: 350px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="3">Description
							
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Qty
							
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Wt/Vol
							
						</td>

						<td style="width: 30px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" rowspan="2">
							<%--<asp:LinkButton ID="LinkButton1" runat="server" Style="text-decoration: none; background-color: #7fc6f6; padding-right: 5px; font-family: Tahoma; font-size: 14px; color: white; margin-right: 5px; padding-left: 5px; min-height: 22px;" BorderStyle="Solid" ToolTip="Save" Enabled="false">
							<asp:Image runat="server" imageurl="~/images/save_orange_16.png" style="vertical-align: middle"/>
							</asp:LinkButton>--%>
						</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							Source DSR No.:
						</td>
						<td style="border: 1px solid #000000; width: 150px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="TextBox1" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="TxtBox"></asp:TextBox>

						</td>
						<td style="width: 150px; background-color: whitesmoke; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							&nbsp;
							<asp:ImageButton ID="ImageButton4" runat="server" ImageUrl="~/images/LoadFile_20.png" ToolTip="Load AM Stock" CssClass="ImgBtn2" />
							
						</td>
						<td style="width: 180px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>


					</tr>

					<tr style="height: 26px; background-color: lightgray">
						<td style="border: 1px solid #000000; width: 80px; background-color: white; text-align: center; padding-left: 1px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtItm" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" Text="1" AutoPostBack="true" CssClass="TxtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 1px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtCodeNo" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="TxtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 450px; background-color: white; text-align: center; font-family: 'Segoe UI'; font-size: small;" colspan="3">
							<asp:DropDownList ID="cboMMdesc" runat="server" BorderStyle="None" BackColor="White" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" CssClass="cboBox"></asp:DropDownList>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtQty" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="txtAmtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtWt" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="txtAmtBox"></asp:TextBox>
						</td>

						<td style="width: 26px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="4"></td>
						<%--<td style="width: 600px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="4" ></td>--%>
					</tr>

					<tr style="height: 595px; background-color: lightgray">
						<td style="border: 1px solid #000000; width: auto; background-color: floralwhite; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small; vertical-align: top;" colspan="8">
							<asp:Panel ID="Panel7" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="dgvPMstock" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvPMstock_RowDataBound" OnRowCreated="dgvPMstock_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="False" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:CommandField ShowSelectButton="True">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="74px"></ItemStyle>
										</asp:CommandField>
										<asp:BoundField DataField="itmno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="79px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="codeno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="119px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="mmdesc">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="471px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="qty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="wt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
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
						<td style="width: 30px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small; vertical-align: top;" rowspan="2">
							<asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/images/reset_16.png" CssClass="ImgBtn" />
							<asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/images/check_16.png" CssClass="ImgBtn" />
							<asp:ImageButton ID="ImageButton3" runat="server" OnClick="OnConfirm2" OnClientClick="Confirm2()" ImageUrl="~/images/delete_16.png" />

						</td>

						<td style="border: 1px solid #000000; width: 600px; background-color: floralwhite; text-align: center; padding-left: 0px; padding-right:2px ; font-family: 'Segoe UI'; font-size: small; vertical-align:top;" colspan="4" rowspan="2">
							<asp:Panel ID="Panel11" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="dgvAMstock" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvAMstock_RowDataBound" OnRowCreated="dgvAMstock_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="True" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<%--<asp:BoundField DataField="itmno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="79px"></ItemStyle>
										</asp:BoundField>--%>
										<asp:BoundField DataField="codeno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="119px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="mmdesc">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="471px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="qty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="wt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
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
					</tr>

					<tr style="height: 26px; background-color: lightgray">
						<td style="border: 1px solid #000000; width: auto; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="6">Total&nbsp;&nbsp;</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblPMqtyTot" runat="server" Text="0" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblPMwtTot" runat="server" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;

						</td>

						<%--<td style="border: 1px solid #000000; width: auto; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>--%>
					</tr>
				</table>
			</ContentTemplate>

		</ajaxToolkit:TabPanel>

		<ajaxToolkit:TabPanel ID="TabPage6" runat="server" HeaderText="Shrinkage Report">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: whitesmoke; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<%--L1--%>
					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Report Option:&nbsp;&nbsp;</td>
						<td style="border: 1px solid #000000; width: 130px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" ">
							<asp:DropDownList ID="cboShrUnit" runat="server" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" CssClass="cboBox" BorderStyle="None" BackColor="White" ></asp:DropDownList>
						</td>
						<td style="width: 600px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"  colspan="13"></td>
					</tr>
					<%--L2--%>
					<tr style="height: 2px; background-color: whitesmoke;">
						<td style="width: 100%; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="16"></td>
					</tr>
					<%--L3--%>
					<tr style="height: 620px; background-color: whitesmoke;">
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 1px; background-color: floralwhite; text-align: center; padding-left: 0px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small; vertical-align:top " colspan="15">
							<asp:Panel ID="Panel8" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="dgvShrink" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvShrink_RowDataBound" OnRowCreated="dgvShrink_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="True" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<%--col 0--%>
										<asp:BoundField DataField="codeno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="119px"></ItemStyle>
										</asp:BoundField>
										<%--col 1--%>
										<asp:BoundField DataField="mmdesc">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="471px"></ItemStyle>
										</asp:BoundField>
										<%--col 2 AM stock--%>
										<asp:BoundField DataField="qty_amstock" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 3--%>
										<asp:BoundField DataField="wt_amstock" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 4 DO --%>
										<asp:BoundField DataField="qty_do" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 5--%>
										<asp:BoundField DataField="wt_do" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 6 Total Load--%>
										<asp:BoundField DataField="qty_totload" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 7--%>
										<asp:BoundField DataField="wt_totload" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 8 Sales --%>
										<asp:BoundField DataField="qty_sales" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 9--%>
										<asp:BoundField DataField="wt_sales" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 10 WRR --%>
										<asp:BoundField DataField="qty_wrr" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 11--%>
										<asp:BoundField DataField="wt_wrr" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 12 PM stock--%>
										<asp:BoundField DataField="qty_pmstock" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 13--%>
										<asp:BoundField DataField="wt_pmstock" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 14 var. qty --%>
										<asp:BoundField DataField="qty_var" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>

										<%--col 15 Shrink wt--%>
										<asp:BoundField DataField="wt_var" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<%--col 16 %age --%>
										<asp:BoundField DataField="perc_wt" DataFormatString="{0:#,##0.00%;(#,##0.00%)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
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
					</tr>
					<%--L4--%>
					<tr style="height: 26px; background-color: whitesmoke;">
						<%--C1--%>
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<%--C2 to C8--%>
						<td style="border: 1px solid #000000; width: 880px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="13">Total&nbsp;&nbsp; 
						
						</td>


						<%--C9--%>
						<td style="border: 1px solid #000000; width: 100px; background-color: whitesmoke; text-align: right; padding-left: 0px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;">

							<asp:Label ID="lblVarQty2" runat="server" Text="0" ForeColor="Red"></asp:Label>&nbsp;&nbsp;

						</td>
						<td style="border: 1px solid #000000; width: 100px; background-color: whitesmoke; text-align: right; padding-left: 0px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;">
							<asp:Label ID="lblTotVar" runat="server" Text="0.00" ForeColor="Red"></asp:Label>&nbsp;&nbsp;
						</td>
					</tr>
				</table>
			</ContentTemplate>
		</ajaxToolkit:TabPanel>

		<ajaxToolkit:TabPanel ID="TabPage7" runat="server" HeaderText="DSR List">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: whitesmoke; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<%--L1--%>
					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Date From:&nbsp;&nbsp; </td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="dpDateFrom" runat="server" BorderStyle="None" BackColor="White" TextMode="Date" Height="20px" Font-Names="Segoe UI" Font-Size="small" AutoPostBack="true" CssClass="DateBox" Width="95%"></asp:TextBox>

						</td>
						<td style="width: 2px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Date To:&nbsp;&nbsp;</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="dpDateTo" runat="server" BorderStyle="None" BackColor="White" TextMode="Date" Height="20px" Font-Names="Segoe UI" Font-Size="small" AutoPostBack="true" CssClass="DateBox" Width="95%"></asp:TextBox>

						</td>
						<td style="width: 2px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Status:&nbsp;&nbsp;</td>

						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:DropDownList ID="cboStatAll" runat="server" BorderStyle="None" BackColor="White" Width="98%" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" CssClass="cboBox"></asp:DropDownList>
						</td>

						<td style="width: 800px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="7"></td>

					</tr>
					<%--L2--%>
					<tr style="height: 2px; background-color: whitesmoke;">
						<td style="width: 100%; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="16"></td>

					</tr>
					<%--L3--%>
					<tr style="height: 620px; background-color: whitesmoke;">
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 1px; background-color: floralwhite; text-align: center; padding-left: 0px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="15">
							<asp:Panel ID="Panel9" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="dgvDSRlist" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvDSRlist_RowDataBound" OnRowCreated="dgvDSRlist_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="True" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:BoundField DataField="itmno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="79px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="codeno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="119px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="mmdesc">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="471px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="qty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="wt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
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
					</tr>

					<%--L4--%>
					<tr style="height: 26px; background-color: whitesmoke;">
						<%--C1--%>
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<%--C2 to C8--%>
						<td style="border: 1px solid #000000; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="13">&nbsp;&nbsp; 
						</td>
					</tr>
				</table>
			</ContentTemplate>
		</ajaxToolkit:TabPanel>

		<ajaxToolkit:TabPanel ID="TabPage8" runat="server" HeaderText="Exception Report">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: whitesmoke; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="2">
							Exception Type:&nbsp;&nbsp;
						</td>
						
						<td style="border: 1px solid #000000; width: 300px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="2">
							<asp:DropDownList ID="cboExcepType" runat="server" BorderStyle="None" BackColor="White" Width="98%" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" CssClass="cboBox"></asp:DropDownList>

						</td>

						<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" >Inv. No.:&nbsp;&nbsp; </td>

						<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="2">
							<asp:DropDownList ID="cboInvNo" runat="server" BorderStyle="None" BackColor="White" Width="98%" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" CssClass="cboBox"></asp:DropDownList>
						</td>
						
						<td style="border: 1px solid #000000; width: 100px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="2"></td>
						
						<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Date From:&nbsp;&nbsp;</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="dpDate1" runat="server" BorderStyle="None" BackColor="White" TextMode="Date" Height="20px" Font-Names="Segoe UI" Font-Size="small" AutoPostBack="true" CssClass="DateBox" Width="95%"></asp:TextBox>
						</td>
						<td style="width: 3px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Date To:&nbsp;&nbsp;</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="dpDate2" runat="server" BorderStyle="None" BackColor="White" TextMode="Date" Height="20px" Font-Names="Segoe UI" Font-Size="small" AutoPostBack="true" CssClass="DateBox" Width="95%"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="2">
							<asp:DropDownList ID="cboListType" runat="server" BorderStyle="None" BackColor="White" Width="98%" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" CssClass="cboBox"></asp:DropDownList>
						</td>
						
					</tr>

					<tr style="height: 1px; background-color: whitesmoke;">
						<td style="width: 100%; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="16"></td>
					</tr>
					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgrey; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" rowspan="2">Select</td>
						<td style="border: 1px solid #000000; width: 60px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Itm No.</td>
						<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="3">Description/Particulars</td>
						
						<td style="border: 1px solid #000000; width: 80px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Qty/Hd</td>
						<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Wt/Kls</td>
						<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">SP</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: lightgray; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">Amount</td>
						
						<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="7" rowspan="2">
							<asp:TextBox ID="txtExcepRem" runat="server" Font-Names="Segoe UI" Font-Size="small" ReadOnly="false" AutoPostBack="true" BorderStyle="None" BackColor="White" TextMode="MultiLine" Height="44px" MaxLength="255" Width="98%"></asp:TextBox>
						</td>
					</tr>
										
					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="border: 1px solid #000000; width: 60px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtItmNo" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="TxtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="3">
							<asp:DropDownList ID="cboMMdescExcep" runat="server" BorderStyle="None" BackColor="White" Width="98%" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="Small" CssClass="cboBox"></asp:DropDownList>
						</td>
						
						<td style="border: 1px solid #000000; width: 80px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtQtyT8" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="TxtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtWtT8" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="txtAmtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"> 
							<asp:TextBox ID="txtSPT8" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="txtAmtBox"></asp:TextBox>
						</td>
						<td style="border: 1px solid #000000; width: 120px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtAmtT8" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="txtAmtBox"></asp:TextBox>
						</td>
																		
					</tr>

					<tr style="height: 1px; background-color: whitesmoke;">
						<td style="width: 100%; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="16"></td>
					</tr>

					<tr style="height: 590px; background-color: whitesmoke;">
						<td style="border: 1px solid #000000; width: 100%; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="16">
							<asp:Panel ID="Panel10" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="dgvExcep" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvExcep_RowDataBound" OnRowCreated="dgvExcep_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="True" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<asp:BoundField DataField="itmno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="79px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="codeno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="119px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="mmdesc">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="471px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="qty" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="wt" DataFormatString="{0:#,##0.00;(#,##0.00)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
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
					</tr>
				</table>
			</ContentTemplate>
		</ajaxToolkit:TabPanel>

		<ajaxToolkit:TabPanel ID="TabPage9" runat="server" HeaderText="DSR Maitenance">
			<ContentTemplate>
				<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: whitesmoke; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
					<%--L1--%>
					<tr style="height: 26px; background-color: whitesmoke;">
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 100px; background-color: lightgray; text-align: right; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">New DSR No.:&nbsp;&nbsp;</td>
						<td style="border: 1px solid #000000; width: 100px; background-color: white; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
							<asp:TextBox ID="txtNewDSRNo" runat="server" BorderStyle="None" BackColor="White" Font-Names="Segoe UI" Font-Size="Small" AutoPostBack="true" CssClass="TxtBox"></asp:TextBox>
						</td>
						<td style="width: 700px; background-color: whitesmoke; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"  colspan="13">
						&nbsp;
							<asp:ImageButton ID="btnVerDSR" runat="server" ImageUrl="~/images/LoadFile_20.png" ToolTip="Load AM Stock" CssClass="ImgBtn2" />
						</td>
					</tr>
					<%--L2--%>
					<tr style="height: 2px; background-color: whitesmoke;">
						<td style="width: 100%; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;" colspan="16"></td>
					</tr>
					<%--L3--%>
					<tr style="height: 646px; background-color: whitesmoke;">
						<td style="width: 1px; background-color: whitesmoke; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;"></td>
						<td style="border: 1px solid #000000; width: 1px; background-color: floralwhite; text-align: center; padding-left: 0px; padding-right: 1px; font-family: 'Segoe UI'; font-size: small;" colspan="15">
							<asp:Panel ID="Panel12" runat="server" ScrollBars="Auto" CssClass="PanelStd">
								<asp:GridView ID="dgvInvListDSR" runat="server" AutoGenerateColumns="False" OnRowDataBound="dgvInvListDSR_RowDataBound" OnRowCreated="dgvInvListDSR_RowCreated" Font-Names="Segoe UI" Font-Size="Small" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
									BorderWidth="1px" CellPadding="3" GridLines="Vertical" ShowHeader="True" CssClass="Grid1">
									<AlternatingRowStyle BackColor="Gainsboro" />
									<Columns>
										<%--a.tc,a.docno,concat(a.shipto,space(1),b.bussname) as custno,a.netamt,a.dsrno--%>
										<asp:BoundField DataField="invno">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="tc">
											<ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="60px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="docno">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="100px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="custno">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="471px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="netamt" DataFormatString="{0:#,##0;(#,##0)}">
											<ItemStyle HorizontalAlign="Right" VerticalAlign="Middle" Width="120px"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="dsrno">
											<ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" Width="100px"></ItemStyle>
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
					</tr>
				</table>
			</ContentTemplate>
		</ajaxToolkit:TabPanel>

	</ajaxToolkit:TabContainer>

	<table style="width: 100%; font-family: 'Segoe UI'; font-size: small; float: left; background-color: whitesmoke; border-spacing: 0px; margin-left: 0px; padding-left: 0px; padding-right: 0px;">
		<tr style="height: 22px; background-color: whitesmoke;">
			<td style="border: 1px solid #000000; width: 100%; background-color: whitesmoke; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
				&nbsp;&nbsp;
				Doc. Status: 
				&nbsp;&nbsp;
				<asp:Label ID="tssDSRstat" runat="server" Text="New" ForeColor="Red"></asp:Label>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				Edit Doc. No.:
				<asp:Label ID="tssDocNo" runat="server" Text="00000000" ForeColor="Red"></asp:Label>
			</td>
			</tr>

		</table>



</asp:Content>
