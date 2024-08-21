Imports MySql.Data.MySqlClient
Imports System
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports MySql.Data

Public Class APapp
	Inherits System.Web.UI.Page
	Dim dt As DataTable
	Dim sql As String
	Dim sqldata As String
	Dim admDocType As String
	Dim strReport As String
	Dim strStat As String

	Protected Sub AdmMsgBox(ByVal sMessage As String)
		Dim msg As String
		msg = "<script language='javascript'>"
		msg += "alert('" & sMessage & "');"
		msg += "<" & "/script>"
		Response.Write(msg)
	End Sub

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

		If lblUser.Text Is Nothing Then
			Response.Redirect("login.aspx")
			Exit Sub

		End If

		vThisFormCode = "027"

		If Not Me.IsPostBack Then
			lblUser.Text = Session("UserID")
			lblGrpUser.Text = Session("UserGrp")

			Call CheckGroupRights()

		End If

		dpPostDate.Text = Format(CDate(Now()), "yyyy-MM-dd")

	End Sub

	Protected Sub CheckGroupRights()
		cboDocType.Items.Clear()

		If IsAllowed(lblGrpUser.Text, vThisFormCode, 2) = True Then 'edit all
			cboDocType.Items.Add("")
			cboDocType.Items.Add("Voucher Payables")
			cboDocType.Items.Add("Weekly Expense")
			cboDocType.Items.Add("Customer Credit Memo")
			cboDocType.Items.Add("Fund Replenishment")
			cboDocType.Items.Add("Vendor Debit Memo")

			If cboDocType.Items.Count > 1 Then
				cboDocType.SelectedIndex = 0
			End If


		Else
			AdmMsgBox("No Authorization Found")
			cboDocType.Items.Clear()

		End If

		'If IsAllowed(lblGrpUser.text, vThisFormCode, 3) = True Then ' 3 = Insert 
		'    cboDocType.Items.Add("Weekly Expense")
		'    cboDocType.Text = ("Weekly Expense")

		'Else
		'    'cboDocType.Items.Clear()

		'End If


		'If IsAllowed(lblGrpUser.text, vThisFormCode, 4) = True Then ' 4 = Delete
		'    cboDocType.Items.Add("Customer Credit Memo")
		'    cboDocType.Items.Add("Vendor Debit Memo")
		'    cboDocType.Text = ("Customer Credit Memo")

		'Else
		'    ' cboDocType.Items.Clear()

		'End If

	End Sub

	Protected Sub CboDocType_Load(sender As Object, e As EventArgs) Handles cboDocType.Load

		GetLimit()

	End Sub

	Protected Sub LbLoadDocType_Click(sender As Object, e As EventArgs) Handles lbLoadDocType.Click
		vThisFormCode = "027"
		Call CheckGroupRights()

	End Sub

	Protected Sub GetLimit()

		If cboDocType.Text = "" Or cboDocType.Text = Nothing Then
			Exit Sub
		End If

		Select Case cboDocType.Text
			Case "Voucher Payables"
				lblTC.Text = "42"

			Case "Weekly Expense"
				lblTC.Text = "41"

			Case "Vendor Debit Memo"
				lblTC.Text = "94"

			Case "Customer Credit Memo"
				lblTC.Text = "90"

		End Select

		Select Case cboDocType.Text
			Case "Voucher Payables", "Weekly Expense", "Fund Replenishment"
				dt = GetDataTable("Select ifnull(maxamt,0) from authtbl where form = 'APapp' and userid ='" & lblUser.Text & "' and " &
								  "appstat = 'POST'")

			Case "Customer Credit Memo"
				dt = GetDataTable("Select ifnull(maxamt,0) from authtbl where form = 'CMapp' and userid ='" & lblUser.Text & "' and " &
								  "appstat = 'APPROVED'")

		End Select

		If Not CBool(dt.Rows.Count) Then
			lblAutoLimitAmt.Text = "0.00"
		Else
			For Each dr As DataRow In dt.Rows
				lblAutoLimitAmt.Text = Format(CDbl(dr.Item(0).ToString()), "#,##0.00")

			Next

			lbSave.Enabled = True

		End If

		dt.Dispose()

		'populate autho combo
		CboStat.Items.Clear()

		Select Case lblTC.Text
			Case "41", "42"
				dt = GetDataTable("Select appstat from authtbl where form = 'APapp' and userid ='" & lblUser.Text & "' group by appstat")

			Case "90"
				dt = GetDataTable("Select appstat from authtbl where form = 'CMapp' and userid ='" & lblUser.Text & "' group by appstat")

		End Select

		If Not CBool(dt.Rows.Count) Then
			CboStat.Items.Clear()
		Else
			For Each dr As DataRow In dt.Rows
				CboStat.Items.Add(dr.Item(0).ToString())

			Next

		End If

		dt.Dispose()

	End Sub

	Protected Sub LbLoadLimit_Click(sender As Object, e As EventArgs) Handles lbLoadLimit.Click

		If cboDocType.Text = "" Then
			Exit Sub
		End If

		GetLimit()

	End Sub

	Protected Sub CboDocType_TextChanged(sender As Object, e As EventArgs) Handles cboDocType.TextChanged
		GetLimit()

	End Sub

	Protected Sub LbClose_Click(sender As Object, e As EventArgs) Handles lbClose.Click
		Response.Redirect("FinancialAccounting.aspx")

	End Sub

	Protected Sub LbGetStatList_Click(sender As Object, e As EventArgs) Handles lbGetStatList.Click
		GetListAll()

	End Sub

	Protected Sub CreateData()
		sql = "delete from tempexphdrtbl where user = '" & lblUser.Text & "'"
		ExecuteNonQuery(Sql)

		sql = "insert into tempexphdrtbl(docno,tc,transdate,venno,payee,docamt,remarks,branch,user) select a.docno,a.tc,a.transdate," &
			  "a.venno,b.venname,a.docamt,concat(a.status,'-',ifnull(a.postedby,'Park'),'/',a.auditby)," &
			  "c.deptname,'" & lblUser.Text & "' from exphdrtbl a left join venmasttbl b on a.venno=b.venno " &
			  "left join depttbl c on a.dept=c.dept left join batbl d on a.bato=d.ba where a.transdate " &
			  "between '" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' and " &
			  "'" & Format(CDate(dpTransDate2.Text), "yyyy-MM-dd") & "' and a.docamt <= " & CDbl(IIf(lblAutoLimitAmt.Text = "", 0, lblAutoLimitAmt.Text)) & " " &
			  "and a.tc = '" & lblTC.Text & "' and a.status = '" & cboStatList.Text & "' and a.cvstat is null group by a.docno order by a.docno"
		ExecuteNonQuery(sql)

		'sql = "update tempexphdrtbl set branch = '' where user = '" & lblUser.Text & "' and branch is null"
		'ExecuteNonQuery(sql)

	End Sub

	Protected Sub GetListAll()
		If cboDocType.Text = Nothing Then
			AdmMsgBox("Document Type is Blank")
			Exit Sub

		ElseIf cboStatList.Text = Nothing Then
			AdmMsgBox("Posting Type is Blank")
			Exit Sub

		ElseIf dpTransDate.Text = Nothing Then
			AdmMsgBox("Select Date From")
			Exit Sub

		ElseIf dpTransDate2.Text = Nothing Then
			AdmMsgBox("Select Date To")
			Exit Sub

		ElseIf dpPostDate.Text = Nothing Then
			AdmMsgBox("Select Posting Date")
			Exit Sub

		End If

		Select Case cboDocType.Text
			Case "Voucher Payables"
				CreateData()
				VPprocList()

		End Select

	End Sub

	Protected Sub VPprocList()

		Dim adapter As New MySqlDataAdapter
		Dim ds As New DataSet()
		'Dim i As Integer = 0
		sqldata = Nothing

		sqldata = "select docno,tc,transdate,venno,payee,docamt,remarks,ifnull(branch,'') as branch from " &
				  "tempexphdrtbl where user = '" & lblUser.Text & "'"

		conn.Open()
		Dim command As New MySqlCommand(sqldata, conn)
		adapter.SelectCommand = command
		adapter.Fill(ds)
		adapter.Dispose()
		command.Dispose()
		conn.Close()
		dgvReport.DataSource = ds.Tables(0)
		dgvReport.DataBind()

	End Sub

	Protected Sub DgvVPList_RowDataBound(sender As Object, e As GridViewRowEventArgs)


	End Sub

	Protected Sub LbNew_Click(sender As Object, e As EventArgs)
		GetListAll()

	End Sub

	Protected Sub LbSave_Click(sender As Object, e As EventArgs)


	End Sub

	Protected Sub LbDelete_Click(sender As Object, e As EventArgs)

	End Sub

	Protected Sub DgvReport_RowDataBound(sender As Object, e As GridViewRowEventArgs)

	End Sub

	Protected Sub DgvReport_RowCreated(sender As Object, e As GridViewRowEventArgs)

	End Sub

	Private Sub CboStatList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboStatList.SelectedIndexChanged
		GetListAll()

	End Sub

	'Private Sub DgvReport_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DgvReport.SelectedIndexChanged
	'	'Select Case lblTC.Text
	'	'	Case "41"
	'	'		admDocType = "WER"

	'	'	Case "42"
	'	'		admDocType = "VP"

	'	'	Case "49"
	'	'		admDocType = "Fund Replenishment"

	'	'	Case "90"
	'	'		admDocType = "CM"

	'	'	Case "94"
	'	'		admDocType = "Vendor DM"

	'	'End Select

	'	'Answer = AdmMsgbox("Are you sure to POST " & admDocType & Space(1) & DgvReport.SelectedRow.Cells(1).Text & "?", vbExclamation + vbYesNo)
	'	'If Answer = vbYes Then

	'	'Else
	'	'	Exit Sub

	'	'End If

	'End Sub

	Protected Sub OnConfirm(sender As Object, e As EventArgs)
		'Select Case lblTC.Text
		'	Case "41"
		'		admDocType = "WER"

		'	Case "42"
		'		admDocType = "VP"

		'	Case "49"
		'		admDocType = "Fund Replenishment"

		'	Case "90"
		'		admDocType = "CM"

		'	Case "94"
		'		admDocType = "Vendor DM"

		'End Select

		Dim confirmValue As String = Request.Form("confirm_value")
		If confirmValue = "Yes" Then
			DocPosting()

		Else
			AdmMsgBox("Action Aborted...")

		End If
	End Sub

	Protected Sub DocPosting()
		Select Case CboStat.Text
			Case "POST"
				strStat = "posted"

			Case "PARK"
				strStat = "parked"

			Case "APPROVED"
				strStat = "posted"

			Case Else
				strStat = CboStat.Text

		End Select

		Select Case lblTC.Text
			Case "41", "42"
				sql = "update exphdrtbl set status = '" & strStat & "',postedby = '" & lblUser.Text & "'," &
					  "datepost = '" & Format(CDate(dpPostDate.Text), "yyyy-MM-dd") & "' " &
					  "where docno = '" & txtDocNo.Text & "' and tc = '" & lblTC.Text & "'" 'actualpostdate = '" & Format(CDate(Now), "yyyy-MM-dd HH:mm:ss") & "'
				ExecuteNonQuery(sql)

				Select Case CboStat.Text
					Case "POST"
						PostCAtoPayroll()

					Case Else
						sql = "delete from payloanmasttbl where loanrefno = '" & "VP" & txtDocNo.Text & "'"
						ExecuteNonQuery(sql)

				End Select

			Case "90"
				sql = "update custdmcmhdrtbl set status = '" & strStat & "',apprvdby = '" & lblUser.Text & "'," &
					  "dateapp = '" & Format(CDate(dpPostDate.Text), "yyyy-MM-dd") & "' where  tc = '" & lblTC.Text & "' " &
					  "and dmcmno = '" & txtDocNo.Text & "'"
				ExecuteNonQuery(sql)

			Case "94"
				sql = "update cvhdrtbl set status = '" & strStat & "',updateby = '" & lblUser.Text & "'," &
					  "reldate = '" & Format(CDate(dpPostDate.Text), "yyyy-MM-dd") & "' where docno = '" & txtDocNo.Text & "' " &
					  "and tc = '" & lblTC.Text & "'"
				ExecuteNonQuery(sql)

		End Select

		Select Case UCase(CboStat.Text)
			Case "POST", "APPROVED"
				Call GLEntryProc()

			Case Else
				sql = "delete from gltranstbl where docno = '" & txtDocNo.Text & "' and tc = '" & lblTC.Text & "'"
				ExecuteNonQuery(sql)

		End Select

		strReport = CboStat.Text
		Call SaveLogs()

		GetListAll()

	End Sub

	Protected Sub PostCAtoPayroll()
		dt = GetDataTable("select ifnull(caseq,'No') from exphdrtbl where docno = '" & txtDocNo.Text & "' and tc = '" & lblTC.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			Exit Sub

		Else
			For Each dr As DataRow In dt.Rows
				Select Case dr.Item(0).ToString()
					Case "No"
						Exit Sub

					Case Else
						SaveCAtoPayProc()

				End Select
			Next

		End If

		dt.Dispose()

	End Sub

	Private Sub GLEntryProc()
		dt = GetDataTable("select * from gltranstbl where docno = '" & txtDocNo.Text & "' and tc = '" & lblTC.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			Call GLEntry()
			strReport = "gl entries"

		Else
			Select Case cboDocType.Text
				Case "Voucher Payables", "Weekly Expense", "Vendor Debit Memo"
					sql = "delete from gltranstbl where docno = '" & txtDocNo.Text & "' and tc = '" & lblTC.Text & "'"
					ExecuteNonQuery(sql)

					Call GLEntry()
					strReport = "Update GL Entries"

				Case Else
					sql = "update gltranstbl set glstatus = 'OPEN' where docno = '" & txtDocNo.Text & "' " &
						  "and tc = '" & lblTC.Text & "'"
					ExecuteNonQuery(sql)

			End Select

		End If

		Call SaveLogs()

	End Sub

	Private Sub GLEntry()

		Dim strEntry As String = "Det"

		Select Case cboDocType.Text
			Case "Voucher Payables"
				sql = "insert into gltranstbl(acctno,dramt,cramt,ccno,transyear,transmon,subacct," &
					  "user,jvsource,glstatus,dateposted,transdate,docno,tc,pk,posttype,branch,bato,branchto,dept) " &
					  "select a.acctno,a.dramt,a.cramt,a.ccno,a.transyear,a.transmon,a.venno,b.user," &
					  "'" & cboDocType.Text & "',a.glstat,'" & Format(CDate(dpPostDate.Text), "yyyy-MM-dd") & "'," &
					  "a.transdate,a.docno,a.tc,a.pk,'" & strEntry & "','" & vLoggedBranch & "',b.bato,b.branchto,a.dept " &
					  "from expdettbl a left join exphdrtbl b on a.docno=b.docno where a.docno = '" & txtDocNo.Text & "' " &
					  "and a.tc = '" & lblTC.Text & "'"
				ExecuteNonQuery(sql)

				sql = "update gltranstbl set cos = 'Y' where jvsource = '" & cboDocType.Text & "' and docno = '" & txtDocNo.Text & "' " &
					  "and tc = '" & lblTC.Text & "' and (acctno = '1131100' or acctno = '1131120')"
				ExecuteNonQuery(sql)

			Case "Weekly Expense"
				sql = "insert into gltranstbl(acctno,dramt,cramt,ccno,transyear,transmon,subacct," &
					  "user,jvsource,glstatus,dateposted,transdate,docno,tc,pk,posttype,branch,bato,branchto,dept) " &
					  "select a.acctno,a.dramt,a.cramt,a.ccno,a.transyear,a.transmon,a.venno,b.user," &
					  "'" & cboDocType.Text & "',a.glstat,'" & Format(CDate(dpPostDate.Text), "yyyy-MM-dd") & "'," &
					  "a.transdate,a.docno,a.tc,a.pk,'" & strEntry & "','" & vLoggedBranch & "',b.bato,b.branchto,a.dept " &
					  "from expdettbl a left join exphdrtbl b on a.docno=b.docno where a.docno = '" & txtDocNo.Text & "' " &
					  "and a.tc = '" & lblTC.Text & "'"
				ExecuteNonQuery(sql)

			Case "Customer Credit Memo"
				sql = "update gltranstbl set glstatus = 'OPEN' where docno = '" & txtDocNo.Text & "' " &
					  "and tc = '" & lblTC.Text & "'"
				ExecuteNonQuery(sql)

			Case "Vendor Debit Memo"
				sql = "insert into gltranstbl(acctno,dramt,cramt,ccno,transyear,transmon,subacct," &
					  "user,jvsource,glstatus,dateposted,transdate,docno,tc,pk,posttype,branch,bato,branchto) " &
					  "select a.acctno,a.dramt,a.cramt,a.ccno,a.transyear,a.transmon,a.venno,b.user," &
					  "'" & cboDocType.Text & "','open','" & Format(CDate(dpPostDate.Text), "yyyy-MM-dd") & "'," &
					  "a.transdate,a.docno,a.tc,a.pk,'" & strEntry & "','" & vLoggedBranch & "',b.ba,b.branch " &
					  "from cvdettbl a left join cvhdrtbl b on a.docno=b.docno where a.docno = '" & txtDocNo.Text & "' " &
					  "and a.tc = '" & lblTC.Text & "'"
				ExecuteNonQuery(sql)

		End Select

	End Sub

	Protected Sub SaveCAtoPayProc()
		dt = GetDataTable("select * from payloanmasttbl where loanrefno = '" & "VP" & txtDocNo.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			SaveCAtoPay()

		Else
			Exit Sub

		End If

	End Sub

	Protected Sub SaveCAtoPay()
		sql = "insert into payloanmasttbl(empno,paycodeno,loanrefno,terms,loanamt,amortamt,loanstat,payseq,user,pdate,datestart,dateend) " &
			  "select b.empno,'112','" & "VP" & txtDocNo.Text & "',a.caterms,a.docamt,a.amortamt,'Open',a.caseq,a.user," &
			  "'" & Format(CDate(Now()), "yyyy-MM-dd HH:mm:ss") & "',a.castart,a.caend from exphdrtbl a left join payemployeetbl b on " &
			  "a.venno=b.venno where a.docno = '" & txtDocNo.Text & "' and a.tc = '" & lblTC.Text & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub SaveLogs()

		sql = "INSERT INTO translog(trans,form,datetimelog,user,docno,tc)VALUES" &
			  "('" & strReport & "','Doc Posting','" & Format(CDate(Now), "yyyy-MM-dd HH:mm:ss") & "'," &
			  "'" & lblUser.Text & "','" & txtDocNo.Text & "','AP App')"
		ExecuteNonQuery(sql)

	End Sub

	Private Sub DpTransDate2_TextChanged(sender As Object, e As EventArgs) Handles dpTransDate2.TextChanged

		GetListAll()

	End Sub

	Private Sub LbGetStat_Click(sender As Object, e As EventArgs) Handles lbGetStat.Click


	End Sub

	Protected Sub lbPrint_Click(sender As Object, e As EventArgs)

		ReportToPrint = "prtAcctChart"
		Response.Redirect("Report_Viewer.aspx")

	End Sub

	Protected Sub ClrFields()
		lblVendor.Text = ""
		lblDatePrep.Text = ""
		lblPrepBy.Text = ""
		lblDept.Text = ""
		lblDocAmt.Text = ""
		lblRem.Text = ""
		txtDocNo.Text = ""
		CboStat.Text = ""

		'lblMMRRno.Text = ""
		'lblPOno.Text = ""
		'lblDateDel.Text = ""
		'lblMMRRrem.Text = ""
		'dgvMMRRdet.DataSource = Nothing

	End Sub

	Protected Sub DgvReport_SelectedIndexChanged(sender As Object, e As EventArgs)
		txtDocNo.Text = DgvReport.SelectedRow.Cells(1).Text
		lblDocAmt.Text = Format(CDbl(DgvReport.SelectedRow.Cells(6).Text), "#,##0.00")
		GetDocDetAll()

	End Sub

	Protected Sub GetDocDetAll()
		Select Case cboDocType.Text
			Case "Voucher Payables"
				dt = GetDataTable("select a.venno,a.dept,a.parkdate,b.venname,a.user,a.remarks,c.deptname,a.reflabel,a.mmrrno from exphdrtbl a " &
								  "left join venmasttbl b on a.venno=b.venno left join depttbl c on a.dept=c.dept " &
								  "where a.docno = '" & txtDocNo.Text & "'")
				If Not CBool(dt.Rows.Count) Then
					AdmMsgBox("Doc not found")
					ClrFields()
					Exit Sub
				End If

				For Each dr As DataRow In dt.Rows
					lblVendor.Text = dr.Item(0).ToString() & Space(1) & dr.Item(3).ToString()
					lblDept.Text = dr.Item(1).ToString() & Space(1) & dr.Item(6).ToString()
					lblDatePrep.Text = Format(dr.Item(2), "yyyy-MM-dd".ToString())
					lblPrepBy.Text = dr.Item(4).ToString()
					lblRem.Text = dr.Item(5).ToString() & ""
					'admSubDoc = dr.Item(7).ToString() & ""
					'lblMMRRno.Text = dr.Item(8).ToString() & ""
				Next

				Call dt.Dispose()

				'Select Case UCase(admSubDoc)
				'	Case "MMRR"
				'		getSupDocs()
				'End Select

			Case "Weekly Expense"
				dt = GetDataTable("select a.venno,a.dept,a.parkdate,b.venname,a.user,a.remarks,c.deptname from exphdrtbl a " &
								  "left join venmasttbl b on a.venno=b.venno " &
								  "left join depttbl c on a.venno=b.venno where a.docno = '" & txtDocNo.Text & "'")
				If Not CBool(dt.Rows.Count) Then
					AdmMsgBox("Doc not found")
					ClrFields()
					Exit Sub
				End If

				For Each dr As DataRow In dt.Rows
					lblVendor.Text = dr.Item(0).ToString() & Space(1) & dr.Item(3).ToString()
					lblDept.Text = dr.Item(1).ToString() & Space(1) & dr.Item(6).ToString()
					lblDatePrep.Text = Format(dr.Item(2), "yyyy-MM-dd".ToString())
					lblPrepBy.Text = dr.Item(4).ToString()
					lblRem.Text = dr.Item(5).ToString() & ""

				Next

				Call dt.Dispose()

			Case "Customer Credit Memo"
				dt = GetDataTable("select a.custno,a.smnno,a.transdate,b.bussname,a.user,a.remarks,c.fullname from custdmcmhdrtbl a " &
								  "left join custmasttbl b on a.custno=b.custno left join smnmtbl c on a.smnno=c.smnno " &
								  "where a.dmcmno = '" & txtDocNo.Text & "' group by a.dmcmno")
				If Not CBool(dt.Rows.Count) Then
					AdmMsgBox("Doc not found")
					ClrFields()
					Exit Sub
				End If

				For Each dr As DataRow In dt.Rows
					lblVendor.Text = dr.Item(0).ToString() & Space(1) & dr.Item(3).ToString()
					lblDept.Text = dr.Item(1).ToString() & Space(1) & dr.Item(6).ToString()
					lblDatePrep.Text = Format(dr.Item(2), "yyyy-MM-dd".ToString())
					lblPrepBy.Text = dr.Item(4).ToString()
					lblRem.Text = dr.Item(5).ToString() & ""

				Next

				Call dt.Dispose()

			Case "Vendor Debit Memo"
				dt = GetDataTable("select concat(a.venno,space(1),b.venname) as ven,a.transdate,a.user,a.remarks from cvhdrtbl a " &
								 "left join venmasttbl b on a.venno=b.venno " &
								 "where a.docno = '" & txtDocNo.Text & "'")
				If Not CBool(dt.Rows.Count) Then
					AdmMsgBox("Doc not found")
					ClrFields()
					Exit Sub
				End If

				For Each dr As DataRow In dt.Rows
					lblVendor.Text = dr.Item(0).ToString()
					lblDatePrep.Text = Format(CDate(dr.Item(1).ToString()), "yyyy-MM-dd")
					lblPrepBy.Text = dr.Item(2).ToString()
					lblRem.Text = dr.Item(3).ToString() & ""

				Next

				Call dt.Dispose()

		End Select

	End Sub

	Private Sub cboDocType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboDocType.SelectedIndexChanged

	End Sub

	Private Sub CboStat_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CboStat.SelectedIndexChanged

	End Sub
End Class