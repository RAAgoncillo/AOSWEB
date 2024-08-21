<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/FI.master" CodeBehind="FinancialAccounting.aspx.vb" Inherits="AOS100web.FinancialAccounting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentOfFinAcctg" runat="server">
	 <table style="width: 98%; font-family: 'Segoe UI'; float: left; margin-top: 0px; padding-top: 0px; border-spacing: 0px; ">
		<%--Line 1--%>
		 <tr style="height: 26px; background-color: lightgray;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">What's New		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>

			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: Medium;">Available Modules		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">On Going
				<asp:Label ID="lblUser" runat="server" Text="User" Visible="false"></asp:Label>
				<asp:Label ID="lblGrpUser" runat="server" Text="Grp User" Visible="false"></asp:Label>
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<%--Line 2--%>
		 <tr style="height: 26px; background-color: lightgray;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="border-top:dotted; border-bottom-color:blanchedalmond; width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">&nbsp;&nbsp;Module:	
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="border-top:dotted; border-bottom-color:blanchedalmond; width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: Medium;">&nbsp;&nbsp;Modules:		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="border-top:dotted; border-bottom-color:blanchedalmond; width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		 <%--Line 3--%>
		<tr style="height: 26px; background-color: lightgray;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;Option to Hide/Show Side Menu		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;
				<asp:LinkButton ID="lbJVentry" runat="server">Journal Voucher Entry</asp:LinkButton>
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">&nbsp;&nbsp;Reports:		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		 <%--Line4--%>
		<tr style="height: 26px; background-color: lightgray;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;Cashier's Report > Collection Register and Summary		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;
				 <asp:LinkButton ID="lbJVapprov" runat="server">JV Posting</asp:LinkButton>
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;Cashier's Reports		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		 <%--Line 5--%>
		<tr style="height: 26px; background-color: lightgray;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;A/R Reports > Register Summary		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
					   
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;
				 <asp:LinkButton ID="lbCALiq" runat="server">CA Liquidation</asp:LinkButton>
				
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>

		 <%--Line 6--%>
		<tr style="height: 26px; background-color: lightgray;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;A/P Reports > Register Summary		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;
				  <asp:LinkButton ID="lbDocPost" runat="server">Document Posting</asp:LinkButton>

			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		 <%--Line 7--%>
		 <tr style="height: 26px; background-color: lightgray;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;
				 <asp:LinkButton ID="lbDSR" runat="server">Daily Sales Report</asp:LinkButton>
				
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>

		 <%--Line 8--%>

		<tr style="height: 26px; background-color: lightgray;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: medium;">&nbsp;&nbsp;Reports:
				
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>

		 <%--Line 8--%>
		<tr style="height: 26px; background-color: lightgray;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;
				 <asp:LinkButton ID="lbARrep" runat="server">Account Receivables</asp:LinkButton>
				
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: lightgray;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;
				 <asp:LinkButton ID="lbAPrep" runat="server">A/P Reports</asp:LinkButton>
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: lightgray;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;
				<asp:LinkButton ID="lbGLrep" runat="server">GL Reports</asp:LinkButton>
				
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;
				<asp:LinkButton ID="lbBudRep" runat="server" Visible="false">Budget Monitoring</asp:LinkButton>
			</td>
			<td style="width: 2px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;
				 <asp:LinkButton ID="lbFSrep" runat="server" Visible="false">Financial Reports</asp:LinkButton>
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">&nbsp;&nbsp;&nbsp;&nbsp;
				 <asp:LinkButton ID="lbCashierRep" runat="server" >Cashier's Reports</asp:LinkButton>
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 26px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>
		<tr style="height: 213px; background-color: floralwhite;">
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: left; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">
			</td>
			<td style="width: 12px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
			<td style="width: 490px; background-color: floralwhite; text-align: center; padding-left: 0px; font-family: 'Segoe UI'; font-size: small;">		
			</td>
			<td style="width: 10px; background-color: whitesmoke; text-align: right; padding-left: 0px;"></td>
		</tr>

	</table>
	  
   
	 
</asp:Content>
