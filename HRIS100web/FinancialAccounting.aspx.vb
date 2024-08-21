
Public Class FinancialAccounting
	Inherits System.Web.UI.Page
	Dim dt As DataTable

	Protected Sub AdmMsgBox(ByVal sMessage As String)
		Dim msg As String
		msg = "<script language='javascript'>"
		msg += "alert('" & sMessage & "');"
		msg += "<" & "/script>"
		Response.Write(msg)
	End Sub

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		If vLoggedUserID Is Nothing Then
			Response.Redirect("login.aspx")
			Exit Sub
		End If

		If Not Me.IsPostBack Then
			lblUser.Text = Session("UserID")
			lblGrpUser.Text = Session("UserGrp")

		End If

		LoadCurrMon()

		Select Case vLoggedBussArea
			Case "8100"
				lbFSrep.Visible = True
				lbBudRep.Visible = False
			Case "8200"
				lbFSrep.Visible = True
				lbBudRep.Visible = False
			Case "8300"
				lbFSrep.Visible = True
				lbBudRep.Visible = True
		End Select

	End Sub

	Private Sub LoadCurrMon()

		Dim strGLStat As String
		strGLStat = "OPEN"

		dt = GetDataTable("select dfrom from gltransmonstatus where yearstat = '" & strGLStat & "' " &
						  "and monstat = '" & strGLStat & "'")
		If Not CBool(dt.Rows.Count) Then
			Exit Sub
		Else
			For Each dr As DataRow In dt.Rows
				vTransMon = dr.Item(0).ToString()

			Next
		End If

		Call dt.Dispose()

		dt = GetDataTable("select dto from gltransmonstatus where yearstat = 'OPEN' " &
						  "and monstat = 'CLOSE' and yearendcltype <> 'Final' and transmon = '12'")
		If Not CBool(dt.Rows.Count) Then
			vTransYear = LastDayOfMonth(vTransMon)
		Else
			For Each dr As DataRow In dt.Rows
				vTransYear = dr.Item(0).ToString()

			Next
		End If

		Call dt.Dispose()

	End Sub

	Private Sub lbCALiq_Click(sender As Object, e As EventArgs) Handles lbCALiq.Click

		If IsAllowed(lblGrpUser.Text, "038", 1) = True Then
			vFormOpen = "CA Liquidation"
			Session("FormOpen") = vFormOpen
			Response.Redirect("Liquidation.aspx")
		Else
			AdmMsgBox("You're not allowed to this Module")
			Response.Redirect("FinancialAccounting.aspx")

		End If

	End Sub

	Private Sub lbAPrep_Click(sender As Object, e As EventArgs) Handles lbAPrep.Click
		If IsAllowed(lblGrpUser.Text, "032", 1) = True Then
			Response.Redirect("APreports.aspx")

		Else
			AdmMsgBox("You're not allowed to this Module")
			Response.Redirect("FinancialAccounting.aspx")

		End If
	End Sub

	Private Sub lbARrep_Click(sender As Object, e As EventArgs) Handles lbARrep.Click
		If IsAllowed(lblGrpUser.Text, "014", 1) = True Then
			Response.Redirect("ARreports.aspx")

		Else
			AdmMsgBox("You're not allowed to this Module")
			Response.Redirect("FinancialAccounting.aspx")

		End If
	End Sub

	Private Sub lbBudRep_Click(sender As Object, e As EventArgs) Handles lbBudRep.Click
		If IsAllowed(lblGrpUser.Text, "079", 1) = True Then
			Response.Redirect("BudgetMonitor.aspx")

		Else
			AdmMsgBox("You're not allowed to this Module")
			Response.Redirect("FinancialAccounting.aspx")

		End If
	End Sub

	Private Sub lbFSrep_Click(sender As Object, e As EventArgs) Handles lbFSrep.Click
		If IsAllowed(lblGrpUser.Text, "063", 1) = True Then
			Select Case vLoggedBussArea
				Case "8100"
					Response.Redirect("FS.aspx")
				Case "8200"
					Response.Redirect("FS.aspx")
				Case "8300"
					Response.Redirect("FSChemag.aspx")
			End Select

		Else
			AdmMsgBox("You're not allowed to this Module")
			Response.Redirect("FinancialAccounting.aspx")

		End If

	End Sub

	Private Sub lbGLrep_Click(sender As Object, e As EventArgs) Handles lbGLrep.Click
		If IsAllowed(lblGrpUser.Text, "052", 1) = True Then
			Response.Redirect("GLReports.aspx")

		Else
			AdmMsgBox("You're not allowed to this Module")
			Response.Redirect("FinancialAccounting.aspx")

		End If

	End Sub

	Private Sub lbJVapprov_Click(sender As Object, e As EventArgs) Handles lbJVapprov.Click
		If IsAllowed(lblGrpUser.Text, "038", 1) = True Then
			Response.Redirect("JVPosting.aspx")

		Else
			AdmMsgBox("You're not allowed to this Module")
			Response.Redirect("FinancialAccounting.aspx")

		End If

	End Sub

	Private Sub lbJVentry_Click(sender As Object, e As EventArgs) Handles lbJVentry.Click
		If IsAllowed(lblGrpUser.Text, "052", 1) = True Then
			Response.Redirect("JournalVoucher.aspx")

		Else
			AdmMsgBox("You're not allowed to this Module")
			Response.Redirect("FinancialAccounting.aspx")

		End If
	End Sub

	Private Sub lbCashierRep_Click(sender As Object, e As EventArgs) Handles lbCashierRep.Click
		If IsAllowed(lblGrpUser.Text, "047", 1) = True Then
			Response.Redirect("CashierReports.aspx")
		Else
			AdmMsgBox("You're not allowed to this Module")
			Response.Redirect("FinancialAccounting.aspx")

		End If

	End Sub

	Private Sub lbDocPost_Click(sender As Object, e As EventArgs) Handles lbDocPost.Click
		If IsAllowed(lblGrpUser.Text, "027", 1) = True Then
			Response.Redirect("APapp.aspx")

		Else
			AdmMsgBox("You're not allowed to this Module")
			Response.Redirect("FinancialAccounting.aspx")

		End If
	End Sub

	Private Sub lbDSR_Click(sender As Object, e As EventArgs) Handles lbDSR.Click
		If IsAllowed(lblGrpUser.Text, "046", 1) = True Then
			Response.Redirect("DailySalesReport.aspx")

		Else
			AdmMsgBox("You're not allowed to this Module")
			Response.Redirect("FinancialAccounting.aspx")

		End If

	End Sub
End Class