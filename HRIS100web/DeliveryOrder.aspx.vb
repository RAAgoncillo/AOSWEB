Imports System
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports MySql.Data
Imports System.Windows.Forms
Imports MySql.Data.MySqlClient

Public Class DeliveryOrder
	Inherits System.Web.UI.Page

	Dim strYes As String
	Dim strReport As String
	Dim strStat As String
	Dim vThisFormCode As String
	Dim dt As DataTable
	Dim dt2 As DataTable
	Dim sql As String
	Dim BalWt As Double
	Dim SP As Double
	Dim SalesAcct As String
	Dim admPlntNo As String
	Dim admSmnNo As String
	Dim admPlntNo2 As String
	Dim admVersion As String = "AOS100 Web"
	Dim admCodeNo As String
	Dim strARacctNo As String
	Dim strCCNo As String
	Dim Amt As Double
	Dim admMMtype As String
	Dim admUpdateNo As String
	Dim admStatType As String
	Dim sqldata As String
	Dim admStopMMdesc As String
	Dim admAddDesc As String
	Dim DiscAcct As String
	Dim admMMtype2 As String
	Dim admUpdate As String
	Dim admDOdate As Date
	Dim admSIdate As Date
	Dim admDealRem As String
	Dim Qty As Long
	Dim Wt As Double
	Dim BalQty As Long
	Dim Answer As String
	Dim MyDA_conn As New MySqlDataAdapter
	Dim MyDataSet As New DataSet
	Dim MySqlScript As String
	Dim strTC As String = "30"

	Protected Sub AdmMsgBox(ByVal sMessage As String)
		Dim msg As String
		msg = "<script language='javascript'>"
		msg += "alert('" & sMessage & "');"
		msg += "<" & "/script>"
		Response.Write(msg)
	End Sub

	Protected Sub SaveLogs()
		Dim strForm As String = "Delivery Order"
		sql = "insert into translog(trans,form,datetimelog,user,docno,tc)values" &
			  "('" & strReport & "','" & strForm & "','" & Format(CDate(Now), "yyyy-MM-dd hh:mm:ss") & "'," &
			  "'" & lblUser.Text & "','" & txtSONo.Text & "','" & lblTC.Text & "')"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		'AdmMsgBox("Not Yet Completed")

		If lblUser.Text Is Nothing Then
			Response.Redirect("login.aspx")

		End If

		If Not Me.IsPostBack Then
			lblUser.Text = Session("UserID")
			lblGrpUser.Text = Session("UserGrp")

		End If

	End Sub

	Protected Sub CheckGroupRights()
		If IsAllowed(lblGrpUser.Text, vThisFormCode, 3) = True Then 'save
			lbSave.Enabled = True

		Else
			lbSave.Enabled = False

		End If

		If IsAllowed(lblGrpUser.Text, vThisFormCode, 2) = True Then 'edit
			txtDONo.ReadOnly = False
		Else
			txtDONo.ReadOnly = True
		End If

		If IsAllowed(lblGrpUser.Text, vThisFormCode, 4) = True Then ' 4 = Delete
			lbDelete.Enabled = True

		Else
			lbDelete.Enabled = False

		End If

	End Sub

	Protected Sub DisableFields()
		txtSONo.Enabled = False
		txtItm.Enabled = False
		txtCodeNo.Enabled = False
		txtQty.Enabled = False
		txtWt.Enabled = False
		txtSP.Enabled = False
		cboSLoc.Enabled = False
		cboLotNo.Enabled = False
		'btnOpenSO.Enabled = False
		btnAdd.Enabled = False
		btnDel.Enabled = False
		'txtCustNo.Enabled = False
		'txtShipTo.Enabled = False
		txtRefNo.Enabled = False
		txtDriver.Enabled = False
		'txtPlNo.Enabled = False


	End Sub

	Protected Sub PopDigits()
		cboAdmDig.Items.Clear()
		cboAdmDig.Items.Add("2")
		cboAdmDig.Items.Add("3")
		cboAdmDig.Items.Add("4")
		cboAdmDig.Items.Add("5")
		cboAdmDig.Items.Add("6")
		cboAdmDig.Items.Add("7")

	End Sub

	Protected Sub PopSmnNames()
		cboSmnName.Items.Clear()
		dt = GetDataTable("select concat(smnno,space(1),fullname) from smnmtbl where status = 'active' order by fullname")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("No Salesman Found")
			Exit Sub

		Else
			cboSmnName.Items.Add("")
			For Each dr As DataRow In dt.Rows
				cboSmnName.Items.Add(dr.Item(0).ToString())
			Next

		End If

		Call dt.Dispose()

	End Sub

	Protected Sub GetPlant()
		cboPlnt.Items.Clear()
		dt = GetDataTable("select concat(plntno,space(1),plntname) from plnttbl where status = 'active' and " &
						  "invset = 'On' order by plntname")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("Not found.")
			Exit Sub
		Else
			cboPlnt.Items.Add("")
			For Each dr As DataRow In dt.Rows
				cboPlnt.Items.Add(dr.Item(0).ToString())

			Next

		End If

		Call dt.Dispose()

	End Sub

	Protected Sub PopMovType()
		cboMovType.Items.Clear()

		dt = GetDataTable("select concat(b.mov,space(1),a.movdesc) from movtbl a left join movplnttbl b on b.mov=a.mov where " &
						  "b.plntno = '" & cboPlnt.Text.Substring(0, 3) & "' and a.form = 'frmdo' and " &
						  "a.ttype = 'Post' order by a.movdesc")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("not found.")
			Exit Sub
		Else
			cboMovType.Items.Add("")
			For Each dr As DataRow In dt.Rows
				cboMovType.Items.Add(dr.Item(0).ToString())

			Next

		End If

		Call dt.Dispose()

	End Sub

	Protected Sub lbPrint_Click(sender As Object, e As EventArgs)

	End Sub

	Protected Sub OnConfirm2(sender As Object, e As EventArgs)
		Dim confirmValue As String = Request.Form("confirm_value")
		If confirmValue = "Yes" Then
			AdmMsgBox("Yes")

		Else
			AdmMsgBox("Action Aborted")

		End If

	End Sub

	Protected Sub NewLoadProc()
		Select Case vLoggedBussArea
			Case "8100", "8200"
				CheckBox5.Visible = False
			Case "8300"
				CheckBox5.Visible = True
		End Select

		tsDocNoEdit.Text = Nothing
		'lblBA.Text = mdiMain.tssBA.Text

		vThisFormCode = "007"
		Call CheckGroupRights()

		'strReport = "Load Form"
		'Call SaveLogs()

		tssDocStat.Text = "New"
		tssDSRstat.Text = "Not Yet Served"

		Select Case vLoggedBussArea
			Case "8100"
				vPC = "1"


			Case "8200"
				vPC = "1"
				'lblPC.Text = "1"

		End Select

		GetPlant()
		PopSmnNames()
		PopDigits()

		CheckBox3.Checked = True

		admMMtype = "ALL"
		tssErrorMsg.Text = ""

		dpTransDate.Text = Format(CDate(Now()), "yyyy-MM-dd")

		Select Case vLoggedBussArea
			Case "8100", "8200"
				CheckBox5.Visible = False
			Case "8300"
				CheckBox5.Visible = True
		End Select

		dt = GetDataTable("select * from information_schema.tables where table_schema =  '" & vDbase & "' and " &
						  "table_name = 'tempissdettbl'")
		If Not CBool(dt.Rows.Count) Then
			sql = "CREATE TABLE tempissdettbl LIKE tempsodettbl"
			ExecuteNonQuery(sql)

		End If

		dt.Dispose()

	End Sub

	Protected Sub OnConfirm3(sender As Object, e As EventArgs)
		Dim confirmValue As String = Request.Form("confirm_value")
		If confirmValue = "Yes" Then
			sql = "delete from tempissdettbl where itmno = '" & DgvDOdet.SelectedRow.Cells(1).Text & "' and " &
				  "user = '" & lblUser.Text & "'"
			ExecuteNonQuery(sql)

			tsSaveStat.Text = "Not yet Saved"

			FillLvSOdet()

		Else
			AdmMsgBox("Action Aborted")

		End If

	End Sub

	Protected Sub OnConfirm(sender As Object, e As EventArgs)
		If txtDONo.Text = Nothing Then
			NewLoadProc()
		Else
			Dim confirmValue As String = Request.Form("confirm_value")
			If confirmValue = "Yes" Then
				StartNewDoc()

			Else
				AdmMsgBox("Action Aborted")

			End If
		End If

	End Sub

	Protected Sub StartNewDoc()
		If txtDONo.Text <> "" Then
			dt = GetDataTable("select * from issdettbl where dono = '" & txtDONo.Text & "'")
			If Not CBool(dt.Rows.Count) Then
				Select Case cboMovType.Text.Substring(0, 3)
					Case "501"

					Case Else
						sql = "update isshdrtbl set status = 'VOID',dsrstat = 'VOID',sono = null,refdoc = null,user = '" & lblUser.Text & "'," &
							  "totqty = 0,totwt = 0 where dono = '" & txtDONo.Text & "' and ttype = 'Post'"
						ExecuteNonQuery(sql)
				End Select

			End If

			dt.Dispose()

		End If

		Call clrFields()
		Call ClrLines()
		clrCodeNoLotNo()

		tssDocStat.Text = "New"
		tssDSRstat.Text = "Not Yet Served"
		tsDocNoEdit.Text = ""

		tsDocNoEdit.Text = Nothing
		'lblBA.Text = mdiMain.tssBA.Text
		admStatType = Nothing

		vThisFormCode = "007"
		Call CheckGroupRights()

		Select Case vLoggedBussArea
			Case "8100", "8200"
				vPC = "1"

			Case "8300"

		End Select


		'dgvLotNoT1.Visible = False

		GetPlant()
		PopSmnNames()
		PopDigits()

	End Sub

	Protected Sub clrCodeNoLotNo()
		sql = "delete from templotnotbl where user = '" & lblUser.Text & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub LogMeIn()
		sql = "insert into doclocktbl(docno,tc,transdate,user,stat,pdate)values" &
			  "('" & txtDONo.Text & "','" & lblTC.Text & "','" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "'," &
			  "'" & lblUser.Text & "','" & strStat & "','" & Format(CDate(Now()), "yyyy-MM-dd HH:mm:ss") & "')"
		ExecuteNonQuery(sql)
	End Sub

	Protected Sub LogMeOut()
		sql = "delete from doclocktbl where docno = '" & txtDONo.Text & "' and tc = '" & lblTC.Text & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub clrFields()
		LogMeOut()
		btnUpdate.Visible = False
		btnSIdateUpdate.Visible = False
		txtDONo.Text = ""
		cboSmnName.Text = Nothing
		cboPlnt.Text = Nothing
		cboMovType.Items.Clear()
		cboMovType.Text = Nothing
		cboCustName.Items.Clear()
		cboCustName.Text = Nothing
		cboShipTo.Items.Clear()
		cboShipTo.Text = Nothing
		txtSONo.Text = ""
		cboPlnt2.Enabled = True
		cboPlnt2.Text = Nothing
		txtRefNo.Text = ""

		txtRemarks.Text = ""
		txtPlNo.Text = ""
		txtDriver.Text = ""
		txtPOno.Text = ""
		lblTotQty.Text = ""
		lblTotWt.Text = ""
		lblTotAmt.Text = ""
		tssInvNo.Text = "00000000"

		tssDocStat.Text = "New"
		tssErrorMsg.Text = "Okay"
		DgvDOdet.DataSource = Nothing
		DgvDOdet.DataBind()
		clrCodeNoLotNo()
		cboMMdesc.Items.Clear()
		cboMMdesc.Text = Nothing
		'cboMovType.DropDownStyle = ComboBoxStyle.DropDownList

		'Select Case vLoggedBussArea
		'	Case "8100", "8200"
		'		GroupBox1.Visible = False

		'	Case "8300"
		'		GroupBox1.Visible = True
		'End Select

		txtDONo.ReadOnly = False
		'btnOpenSO.Enabled = True
		admDOdate = Now()
		admSIdate = Now()

	End Sub

	Protected Sub lbDelete_Click(sender As Object, e As EventArgs)

	End Sub

	Protected Sub lbClose_Click(sender As Object, e As EventArgs)

	End Sub

	Protected Sub DgvDOdet_RowDataBound(sender As Object, e As GridViewRowEventArgs)

	End Sub

	Protected Sub DgvDOdet_RowCreated(sender As Object, e As GridViewRowEventArgs)

	End Sub

	Protected Sub CheckBox1_CheckedChanged(sender As Object, e As EventArgs)

	End Sub

	Protected Sub CheckBox6_CheckedChanged(sender As Object, e As EventArgs)

	End Sub

	Protected Sub DgvSOList_RowDataBound(sender As Object, e As GridViewRowEventArgs)

	End Sub

	Protected Sub DgvSOList_RowCreated(sender As Object, e As GridViewRowEventArgs)

	End Sub

	Protected Sub cboPlnt_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboPlnt.SelectedIndexChanged
		PopMovType()
		PopSignaturies()
		PopPClass()

	End Sub

	Protected Sub PopSignaturies()
		cboCheckBy.Items.Clear()
		dt = GetDataTable("select fullname from signtbl where plntno = '" & cboPlnt.Text.Substring(0, 3) & "' " &
						  "and signtype = 'Checked By' and frmname = 'DO'")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("No signatory found.")
			Exit Sub

		Else
			For Each dr As DataRow In dt.Rows
				cboCheckBy.Items.Add(dr.Item(0).ToString())

			Next

		End If

		Call dt.Dispose()

		If cboCheckBy.Items.Count > 0 Then
			cboCheckBy.SelectedIndex = 0
		End If

	End Sub

	Protected Sub cboMovType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboMovType.SelectedIndexChanged
		If cboMovType.Text = Nothing Then
			Exit Sub
		End If

		MovTypeExec()

	End Sub

	Protected Sub MovTypeExec()
		Select Case vLoggedBussArea
			Case "8300"
				If cboPClass.Text = "" Then
					AdmMsgBox("Select Product Class")
					cboMovType.Text = Nothing
					Exit Sub
				End If

		End Select

		CheckBox1.Checked = False

		dt = GetDataTable("select soporeq from movtbl where mov = '" & cboMovType.Text.Substring(0, 3) & "'")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("Not found.")
			Exit Sub

		Else
			For Each dr As DataRow In dt.Rows
				strYes = dr.Item(0).ToString() & ""

				If strYes = "Yes" Then
					txtSONo.Enabled = True
					cboSmnName.Enabled = True

				Else
					cboSmnName.Items.Clear()
					txtSONo.Text = ""
					cboSmnName.Text = Nothing
					txtSONo.Enabled = False
					cboSmnName.Enabled = False

				End If

			Next

		End If

		Call dt.Dispose()

		Select Case cboMovType.Text.Substring(0, 3)
			Case "121"

				admMMtype = "ALL"
				cboSmnName.Text = Nothing

			Case "201"
				getCustNoPlnt()
				txtUMmatl.Visible = True
				cboPlnt2.Enabled = False
				cboPlnt2.Items.Clear()
				cboPlnt2.Text = Nothing

				admMMtype = "RM"
				CheckBox1.Checked = True
				cboSmnName.Text = Nothing

				Select Case vLoggedBussArea
					Case "8300"
						cboFGmmGrp.Enabled = True
						PopFGmmGrp()
					Case Else
						cboFGmmGrp.Enabled = False
						cboFGmmGrp.Items.Clear()
				End Select

			Case "203"
				getVenCustNoPlant()
				txtUMmatl.Visible = True
				cboPlnt2.Enabled = False
				cboPlnt2.Items.Clear()
				cboPlnt2.Text = Nothing

				txtSONo.Focus()

				'Label6.Text = "SO No.:"
				'GroupBox1.Visible = False PClass
				cboSmnName.Text = Nothing

				'cbSP.Visible = False
				admMMtype = "Packaging"

				Select Case vLoggedBussArea
					Case "8300"
						cboFGmmGrp.Enabled = True
						PopFGmmGrp()
					Case Else
						cboFGmmGrp.Enabled = False
						cboFGmmGrp.Items.Clear()
				End Select


			Case "301"
				cboPlnt2.Enabled = True
				PopNewPlant()
				txtUMmatl.Visible = True

				'Label6.Text = "SO No.:"
				'GroupBox1.Visible = False


				'cbSP.Visible = False
				admMMtype = "Trans"

				'If IsAllowed(lblGrpUser.Text, "073", 5) = True Then
				'	tsmi_invty.Visible = True

				'Else
				'	tsmi_invty.Visible = False

				'End If
				cboSmnName.Text = Nothing
			Case "303"



			Case "312", "501"
				getCustNoPlnt()
				txtUMmatl.Visible = True
				cboPlnt2.Enabled = False
				cboPlnt2.Items.Clear()
				cboPlnt2.Text = Nothing


				'Label6.Text = "SO No.:"
				'GroupBox1.Visible = False

				'cbSP.Visible = False
				admMMtype = "ALL"
				cboSmnName.Text = Nothing

			Case "601"
				txtUMmatl.Visible = False
				cboPlnt2.Enabled = False
				cboPlnt2.Items.Clear()
				cboPlnt2.Text = Nothing
				cboFGmmGrp.Enabled = False


				'Label6.Text = "SO No.:"
				'UpdateBatchToolStripMenuItem.Visible = True
				'cbSP.Visible = True
				admMMtype = "ALL"
				CheckBox1.Checked = True
				TabPanel2.Focus()
				TabContainer1.ActiveTabIndex = 1

			Case "611"
				txtUMmatl.Visible = False
				cboPlnt2.Enabled = False
				cboPlnt2.Items.Clear()
				cboPlnt2.Text = Nothing


				'txtCustNo.ReadOnly = False
				'txtShipTo.ReadOnly = False
				'Label6.Text = "SO No.:"
				'UpdateBatchToolStripMenuItem.Visible = True
				'cbSP.Visible = True
				admMMtype = "ALL"
				CheckBox1.Checked = True

			Case "613"
				txtUMmatl.Visible = False
				cboPlnt2.Enabled = False
				cboPlnt2.Items.Clear()
				cboPlnt2.Text = Nothing


				PopPClass()
				'Label6.Text = "SO No.:"
				'cbSP.Visible = False
				admMMtype = "ALL"

			Case Else
				txtUMmatl.Visible = False
				cboPlnt2.Enabled = False
				cboPlnt2.Items.Clear()
				cboPlnt2.Text = Nothing

				'Label6.Text = "SO No.:"
				'GroupBox1.Visible = False

				'cbSP.Visible = False
				admMMtype = "ALL"
				cboSmnName.Text = Nothing

		End Select

		cboSLoc.Items.Clear()
		dt = GetDataTable("select slocdesc from sloctbl where plntno = '" & cboPlnt.Text.Substring(0, 3) & "' " &
						  "and pc = '" & cboPClass.Text.Substring(0, 1) & "'")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("Not found.")
			Exit Sub
		Else
			For Each dr As DataRow In dt.Rows
				cboSLoc.Items.Add(dr.Item(0).ToString())
			Next

		End If

		Call dt.Dispose()

		If cboSLoc.Items.Count > 0 Then
			cboSLoc.SelectedIndex = 0
		End If

		GetSLocNo()

	End Sub

	Protected Sub GetSLocNo()
		dt = GetDataTable("select sloc from sloctbl where slocdesc = '" & cboSLoc.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("Not found.")
			Exit Sub
		Else
			For Each dr As DataRow In dt.Rows
				lblSLoc.Text = dr.Item(0).ToString()
			Next

		End If

		Call dt.Dispose()
	End Sub

	Protected Sub PopPClass()
		cboPClass.Items.Clear()
		dt = GetDataTable("select concat(pc,space(1),pclass) from pctrtbl where tradetype = 'trade'")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("PC Not found.")
			Exit Sub

		Else
			Select Case vLoggedBussArea
				Case "8300"
					cboPClass.Items.Add("")
			End Select

			For Each dr As DataRow In dt.Rows
				cboPClass.Items.Add(dr.Item(0).ToString())

			Next

		End If

		Call dt.Dispose()

		Select Case vLoggedBussArea
			Case "8100", "8200"
				If cboPClass.Items.Count > 0 Then
					cboPClass.SelectedIndex = 0
				End If
		End Select

	End Sub

	Protected Sub PopNewPlant()
		cboPlnt2.Items.Clear()
		dt = GetDataTable("select concat(plntno,space(1),plntname) from plnttbl where status = 'active' and " &
						  "plntno <> '" & cboPlnt.Text.Substring(0, 3) & "' order by plntname")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("Not found.")
			Exit Sub

		Else
			cboPlnt2.Items.Add("")
			For Each dr As DataRow In dt.Rows
				cboPlnt2.Items.Add(dr.Item(0).ToString())

			Next

		End If

		Call dt.Dispose()



	End Sub

	Protected Sub getVenCustNoPlant()
		cboCustName.Items.Clear()
		cboShipTo.Items.Clear()

		dt = GetDataTable("select concat(a.venno2,space(1),,b.bussname) from plnttbl a left join custmasttbl b on a.venno2=b.custno " &
						  "where a.plntno = '" & cboPlnt2.Text.Substring(0, 3) & "'")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("Not found.")
			Exit Sub
		Else
			For Each dr As DataRow In dt.Rows
				cboCustName.Items.Add(dr.Item(0).ToString())
				cboShipTo.Items.Add(dr.Item(0).ToString())
				cboCustName.Text = dr.Item(0).ToString()
				cboShipTo.Text = dr.Item(0).ToString()
			Next

		End If

		Call dt.Dispose()

	End Sub

	Protected Sub PopFGmmGrp()
		dt = GetDataTable("select mmgrp from mmasttbl where mmtype ='finished goods' and pc = '" & cboPClass.Text.Substring(0, 1) & "' group by mmgrp")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("Not found.")
			Exit Sub
		Else
			cboFGmmGrp.Items.Clear()
			For Each dr As DataRow In dt.Rows
				cboFGmmGrp.Items.Add(dr.Item(0).ToString())

			Next
		End If

		Call dt.Dispose()

	End Sub

	Protected Sub getCustNoPlnt()
		cboCustName.Items.Clear()
		cboShipTo.Items.Clear()
		dt = GetDataTable("select concat(a.custno,space(1),b.bussname) from plnttbl a left join custmasttbl b on a.custno=b.custno " &
						  "where a.plntno = '" & cboPlnt.Text.Substring(0, 3) & "'")
		If Not CBool(dt.Rows.Count) Then
			Call MessageBox.Show("Not found.", "Delivery Order", MessageBoxButtons.OK, MessageBoxIcon.Warning)
			Exit Sub
		Else
			For Each dr As DataRow In dt.Rows
				cboCustName.Items.Add(dr.Item(0).ToString())
				cboShipTo.Items.Add(dr.Item(0).ToString())
				cboCustName.Text = dr.Item(0).ToString()
				cboShipTo.Text = dr.Item(0).ToString()

			Next

		End If

		dt.Dispose()

	End Sub

	'Private Sub lbSONo_Click(sender As Object, e As EventArgs) Handles lbSONo.Click

	'End Sub

	Protected Sub GetSOdetAll()
		dt = GetDataTable("select concat(a.custno,space(1),b.bussname),concat(a.shipto,space(1),c.bussname)," &
						  "concat(a.smnno,space(1),d.fullname),a.pono,a.delstat from sohdrtbl a " &
						  "left join custmasttbl b on a.custno=b.custno left join custmasttbl c on a.shipto=c.custno " &
						  "left join smnmtbl d on a.smnno=d.smnno where a.sono = '" & txtSONo.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("SO Not found")
			Exit Sub
		Else
			For Each dr As DataRow In dt.Rows
				Select Case UCase(dr.Item(4).ToString())
					Case "SERVED"
						Select Case vLoggedBussArea
							Case "8200", "8300"
								If IsAllowed(lblGrpUser.Text, vThisFormCode, 5) = True Then

								Else
									AdmMsgBox("SO Already SERVED")
									Exit Sub

								End If

							Case Else
								AdmMsgBox("SO Already SERVED")
								Exit Sub
						End Select

					Case Else

				End Select

				cboCustName.Items.Clear()
				cboCustName.Items.Add(dr.Item(0).ToString())
				cboCustName.Text = dr.Item(0).ToString()
				cboShipTo.Items.Clear()
				cboShipTo.Items.Add(dr.Item(1).ToString())
				cboShipTo.Text = dr.Item(1).ToString()
				cboSmnName.Items.Clear()
				cboSmnName.Items.Add(dr.Item(2).ToString())
				cboSmnName.Text = dr.Item(2).ToString()
				txtPOno.Text = dr.Item(3).ToString()

			Next

		End If
		Call dt.Dispose()

		'txtCustNo.Enabled = False
		'txtShipTo.Enabled = False

		Call GetMainCustDet()
		'Call getShipToDet()
		'Call getSmnName()

		If CheckBox5.Checked = True Then
			Call FillLvSOdet_Serial()
		Else
			getSOItemBals()
			TempDataDet()
			FillLvSOdet()
		End If

		If dpTransDate.Text = Nothing Then
			tssErrorMsg.Text = "Date Not Yet Set"
			Exit Sub
		End If

		Call PopMMdesc()

		'UpdateBatchToolStripMenuItem.Enabled = True

	End Sub

	Protected Sub FillLvSOdet_Serial()


	End Sub

	Protected Sub TempDataDet()
		sql = "delete from tempissdettbl where user ='" & lblUser.Text & "'"
		ExecuteNonQuery(sql)

		sql = "insert into tempissdettbl(itmno,codeno,qty,wt,sp,billref,status,user) " &
			  "select a.itmno,a.codeno,ifnull(a.qtbal,0),ifnull(a.wtbal,0),ifnull(a.sp,0)," &
			  "b.billref,ifnull(a.status,'N'),'" & lblUser.Text & "' from sodettbl a " &
			  "left join mmasttbl b on a.codeno=b.codeno where a.sono = '" & txtSONo.Text & "' " &
			  "and (a.wtbal > 0 Or a.qtbal > 0) group by a.transid order by a.itmno"
		ExecuteNonQuery(sql)

		sql = "update tempissdettbl set itmamt = ifnull(sp,0) * ifnull(qty,0) where user = '" & lblUser.Text & "' " &
			  "and billref = 'qty'"
		ExecuteNonQuery(sql)

		sql = "update tempissdettbl set itmamt = ifnull(sp,0) * ifnull(wt,0) where user = '" & lblUser.Text & "' " &
			  "and billref = 'wt'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub FillLvSOdet()

		Dim adapter As New MySqlDataAdapter
		Dim ds As New DataSet()
		Dim i As Integer = 0
		sqldata = Nothing

		sqldata = "select a.itmno,a.codeno,ifnull(b.codename,b.mmdesc) as mmdesc,ifnull(a.qty,0) as qty,ifnull(a.wt,0) as wt," &
				  "ifnull(a.sp,0) as sp,ifnull(a.itmamt,0) as itmamt,ifnull(a.discamt,0) as discamt,ifnull(a.netamt,0) as netamt," &
				  "a.sloc,a.lotno from tempissdettbl a left join mmasttbl b on a.codeno=b.codeno where a.user = '" & lblUser.Text & "' " &
				  "group by a.itmno order by a.itmno"

		conn.Open()
		Dim command As New MySqlCommand(sqldata, conn)
		adapter.SelectCommand = command
		adapter.Fill(ds)
		adapter.Dispose()
		command.Dispose()
		conn.Close()
		DgvDOdet.DataSource = ds.Tables(0)
		DgvDOdet.DataBind()

		lblLineItm.Text = "On Process"

		GetColTotals()

	End Sub

	Protected Sub GetColTotals()
		dt = GetDataTable("select sum(ifnull(qty,0)),sum(ifnull(wt,0)),sum(ifnull(itmamt,0)) " &
						  "from tempissdettbl where user = '" & lblUser.Text & "' and lotno is not null group by user")
		If Not CBool(dt.Rows.Count) Then
			txtItm.Text = "1"
		Else
			For Each dr As DataRow In dt.Rows
				lblTotQty.Text = Format(CDbl(dr.Item(0).ToString()), "#,##0")
				lblTotWt.Text = Format(CDbl(dr.Item(1).ToString()), "#,##0.00")
				lblTotAmt.Text = Format(CDbl(dr.Item(2).ToString()), "#,##0.00")

			Next

		End If

		dt.Dispose()

	End Sub

	Protected Sub getSOItemBals()

		sql = "update sodettbl set issqty = 0,isswt = 0,issby = null,issdate=null where sono = '" & txtSONo.Text & "'"
		ExecuteNonQuery(sql)

		sql = "update sodettbl a,(select a.codeno,ifnull(sum(a.qty),0) as qty,ifnull(sum(a.wt),0) as wt from issdettbl a " &
			  "left join isshdrtbl b on a.dono=b.dono where b.sono = '" & txtSONo.Text & "' and b.status <> 'void' and " &
			  "b.dono <> '" & txtDONo.Text & "' group by a.codeno) as b set a.issqty = b.qty,a.isswt = b.wt,a.issby = '" & lblUser.Text & "'," &
			  "a.issdate = '" & Format(CDate(Now()), "yyyy-MM-dd HH:mm:ss") & "' where a.sono = '" & txtSONo.Text & "' " &
			  "and a.codeno=b.codeno"
		ExecuteNonQuery(sql)

		sql = "update sodettbl set qtbal = qty - ifnull(issqty,0),wtbal = wt - ifnull(isswt,0) where sono = '" & txtSONo.Text & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub GetMainCustDet()
		dt = GetDataTable("select ifnull(drbiropt,'No BIR') from custmasttbl where custno = '" & cboCustName.Text.Substring(0, 5) & "'")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("Not found.")
			Exit Sub

		Else
			For Each dr As DataRow In dt.Rows
				tssDRprtOpt.Text = dr.Item(0).ToString() & ""
			Next
		End If

		Call dt.Dispose()

	End Sub

	Protected Sub PopMMdesc()
		cboMMdesc.Items.Clear()
		Select Case cboMovType.Text.Substring(0, 3)
			Case "601"
				If txtSONo.Text <> "" Then 'and c.plntno = '" & lblPlntNo.Text & "'
					dt = GetDataTable("select ifnull(b.codename,b.mmdesc) from sodettbl a left join mmasttbl b on a.codeno=b.codeno " &
									  "left join sohdrtbl c on a.sono=c.sono where a.sono = '" & txtSONo.Text & "' " &
									  "and (a.qtbal > 0 or a.wtbal > 0) group by a.codeno order by ifnull(b.codename,b.mmdesc)")
					If Not CBool(dt.Rows.Count) Then
						Exit Sub

					Else
						cboMMdesc.Items.Add("")
						For Each dr As DataRow In dt.Rows
							cboMMdesc.Items.Add(dr.Item(0).ToString())

						Next
					End If

					Call dt.Dispose()

					cboMMdesc.Text = Nothing

				Else
					cboMMdesc.Items.Clear()
					'btnOpenSO.PerformClick()
					'MsgBox("No Sales Order Selected yet")
					Exit Sub

				End If

			Case Else
				cboMMdesc.Items.Clear()
				Select Case admMMtype
					Case "RM"
						dt = GetDataTable("select ifnull(b.codename,b.mmdesc) from invdettbl a left join mmasttbl b on a.codeno=b.codeno " &
										  "left join invhdrtbl c on a.mmrrno=c.mmrrno where c.plntno = '" & cboPlnt.Text.Substring(0, 3) & "' " &
										  "and c.transdate <= '" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' " &
										  "and b.mmtype = 'raw materials' and c.status <> 'void' group by a.codeno order by ifnull(b.codename,b.mmdesc)")

						If Not CBool(dt.Rows.Count) Then
							Exit Sub
						Else
							cboMMdesc.Items.Add("")
							For Each dr As DataRow In dt.Rows
								cboMMdesc.Items.Add(dr.Item(0).ToString())

							Next

						End If

						Call dt.Dispose()

						cboMMdesc.Items.Add("=X=X=Packaging Start Here=X=X=")

						dt = GetDataTable("select b.mmdesc from invdettbl a left join mmasttbl b on a.codeno=b.codeno " &
										  "left join invhdrtbl c on a.mmrrno=c.mmrrno where c.plntno = '" & cboPlnt.Text.Substring(0, 3) & "' " &
										  "and c.transdate <= '" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' " &
										  "and b.mmtype = 'packaging' and c.status <> 'void' group by a.codeno order by b.mmdesc")

						If Not CBool(dt.Rows.Count) Then
							Exit Sub
						Else
							For Each dr As DataRow In dt.Rows
								cboMMdesc.Items.Add(dr.Item(0).ToString())

							Next
						End If

						Call dt.Dispose()

					Case "Trans"
						dt = GetDataTable("select ifnull(b.codename,b.mmdesc) from invdettbl a left join mmasttbl b on a.codeno=b.codeno " &
										  "left join invhdrtbl c on a.mmrrno=c.mmrrno where c.plntno = '" & cboPlnt.Text.Substring(0, 3) & "' " &
										  "and c.transdate <= '" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' " &
										  "and c.status <> 'void' group by a.codeno order by ifnull(b.codename,b.mmdesc)")
						If Not CBool(dt.Rows.Count) Then
							Exit Sub
						Else
							cboMMdesc.Items.Add("")
							For Each dr As DataRow In dt.Rows
								cboMMdesc.Items.Add(dr.Item(0).ToString())

							Next
						End If

						Call dt.Dispose()

					Case "Packaging"
						dt = GetDataTable("select b.mmdesc from invdettbl a left join mmasttbl b on a.codeno=b.codeno " &
										  "left join invhdrtbl c on a.mmrrno=c.mmrrno where c.plntno = '" & cboPlnt.Text.Substring(0, 3) & "' " &
										  "and c.transdate <= '" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' " &
										  "and b.mmtype = 'packaging' and c.status <> 'void' group by a.codeno order by b.mmdesc")

						If Not CBool(dt.Rows.Count) Then
							Exit Sub
						Else
							cboMMdesc.Items.Add("")
							For Each dr As DataRow In dt.Rows
								cboMMdesc.Items.Add(dr.Item(0).ToString())

							Next
						End If

						Call dt.Dispose()

					Case Else
						dt = GetDataTable("select ifnull(b.codename,b.mmdesc) from invdettbl a left join mmasttbl b on a.codeno=b.codeno " &
										  "left join invhdrtbl c on a.mmrrno=c.mmrrno where c.plntno = '" & cboPlnt.Text.Substring(0, 3) & "' " &
										  "and c.transdate <= '" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' " &
										  "and (b.mmtype <> 'raw materials' and b.mmtype <> 'packaging') and c.status <> 'void' " &
										  "group by a.codeno order by ifnull(b.codename,b.mmdesc)")
						If Not CBool(dt.Rows.Count) Then
							Exit Sub
						Else
							cboMMdesc.Items.Add("")
							For Each dr As DataRow In dt.Rows
								cboMMdesc.Items.Add(dr.Item(0).ToString())

							Next
						End If

						Call dt.Dispose()

				End Select

		End Select

		cboMMdesc.Text = ""

	End Sub

	Private Sub LbCustList_Click(sender As Object, e As EventArgs) Handles LbCustList.Click
		'If txtDONo.Text <> "" Then
		'	AdmMsgBox("SO Reloading not possible, please process new DO to continue")
		'	Exit Sub
		'End If
		'If Not Me.IsPostBack Then
		'	PopOpenSOlview()
		'End If

		CustListProc()

	End Sub

	Protected Sub CustListProc()
		If cboMovType.Text = Nothing Or cboMovType.Text = "" Then
			AdmMsgBox("Select Movement Type")
			Exit Sub
		End If

		Select Case cboMovType.Text.Substring(0, 3)
			Case "601"
				PopOpenSOlview()

			Case Else
				Exit Sub
				'AdmMsgBox("Not Applicable to " & cboMovType.Text)

		End Select
	End Sub

	Protected Sub PopOpenSOlview()
		CboCustList.Items.Clear()
		dt = GetDataTable("select concat(a.custno,space(1),b.bussname) from sohdrtbl a left join custmasttbl b " &
						  "on a.custno=b.custno where a.delstat <> 'Served' and a.status = 'approved' " &
						  "group by a.custno order by b.bussname")
		If Not CBool(dt.Rows.Count) Then

		Else
			CboCustList.Items.Add("")
			CboCustList.Items.Add("ALL")
			For Each dr As DataRow In dt.Rows
				CboCustList.Items.Add(dr.Item(0).ToString())
			Next

		End If

		dt.Dispose()

	End Sub

	Private Sub CboCustList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CboCustList.SelectedIndexChanged

		'If Not Me.IsPostBack Then

		'End If
		GetSOlistPerCust()

	End Sub

	Protected Sub GetSOlistPerCust()
		Dim adapter As New MySqlDataAdapter
		Dim ds As New DataSet()
		sqldata = Nothing
		Select Case CboCustList.Text
			Case "ALL"
				sqldata = "select a.sono,a.transdate,concat(a.custno,space(1),b.bussname) as custno,a.status,a.pono from " &
						  "sohdrtbl a left join custmasttbl b on a.custno=b.custno where a.delstat <> 'Served' and a.status = 'approved' " &
						  "and a.apprvdby is not null and a.delstat <> 'served' order by a.transdate desc"
			Case Else
				sqldata = "select a.sono,a.transdate,concat(a.custno,space(1),b.bussname) as custno,a.status,a.pono from " &
						  "sohdrtbl a left join custmasttbl b on a.custno=b.custno where a.delstat <> 'Served' and a.status = 'approved' " &
						  "and a.apprvdby is not null and a.custno = '" & CboCustList.Text.Substring(0, 5) & "' " &
						  "and a.delstat <> 'served' order by a.transdate desc"
		End Select

		conn.Open()
		Dim command As New MySqlCommand(sqldata, conn)
		adapter.SelectCommand = command
		adapter.Fill(ds)
		adapter.Dispose()
		command.Dispose()
		conn.Close()
		DgvSOList.DataSource = ds.Tables(0)
		DgvSOList.DataBind()


	End Sub

	Protected Sub DgvSOdetList_RowDataBound(sender As Object, e As GridViewRowEventArgs)

	End Sub

	Protected Sub DgvSOdetList_RowCreated(sender As Object, e As GridViewRowEventArgs)

	End Sub


	Protected Sub FillSOdetLis()
		Dim adapter As New MySqlDataAdapter
		Dim ds As New DataSet()
		sqldata = Nothing

		sql = "update sodettbl set issqty = 0,isswt = 0,issby = null,issdate=null where sono = '" & DgvSOList.SelectedRow.Cells(1).Text & "'"
		ExecuteNonQuery(sql)

		sql = "update sodettbl a,(select a.codeno,ifnull(sum(a.qty),0) as qty,ifnull(sum(a.wt),0) as wt from issdettbl a " &
			  "left join isshdrtbl b on a.dono=b.dono where b.sono = '" & DgvSOList.SelectedRow.Cells(1).Text & "' and b.status <> 'void' " &
			  "group by a.codeno) as b set a.issqty = b.qty,a.isswt = b.wt,a.issby = '" & lblUser.Text & "'," &
			  "a.issdate = '" & Format(CDate(Now()), "yyyy-MM-dd HH:mm:ss") & "' where a.sono = '" & DgvSOList.SelectedRow.Cells(1).Text & "' " &
			  "and a.codeno=b.codeno"
		ExecuteNonQuery(sql)

		sql = "update sodettbl set qtbal = qty - ifnull(issqty,0),wtbal = wt - ifnull(isswt,0) where " &
			  "sono = '" & DgvSOList.SelectedRow.Cells(1).Text & "'"
		ExecuteNonQuery(sql)

		dt = GetDataTable("select sum(ifnull(qtbal,0)),sum(ifnull(wtbal,0)),sum(ifnull(itmamt,0)) " &
						 "from sodettbl where sono = '" & DgvSOList.SelectedRow.Cells(1).Text & "' and " &
						  "(wtbal <> 0 or qty <> 0) group by sono")
		If Not CBool(dt.Rows.Count) Then
			DgvSOdetList.DataSource = Nothing
			DgvSOdetList.DataBind()
			ds.Clear()
		Else
			For Each dr As DataRow In dt.Rows
				lblTotQtyT2.Text = Format(CDbl(dr.Item(0).ToString()), "#,##0 ; (#,##0)")
				lblTotWtT2.Text = Format(CDbl(dr.Item(1).ToString()), "#,##0.00 ; (#,##0.00)")
				lblTotAmtT2.Text = Format(CDbl(dr.Item(2).ToString()), "#,##0.00 ; (#,##0.00)")
			Next

		End If

		dt.Dispose()

		sqldata = "select a.itmno,a.codeno,b.mmdesc,ifnull(a.qtbal,0) as qty,ifnull(a.wtbal,0) as wt,ifnull(a.sp,0) as sp," &
				  "ifnull(a.itmamt,0) as itmamt from sodettbl a left join mmasttbl b on a.codeno=b.codeno where " &
				  "a.sono = '" & DgvSOList.SelectedRow.Cells(1).Text & "' and (a.wtbal <> 0 Or a.qty <> 0) group by a.transid order by a.itmno"

		conn.Open()
		Dim command As New MySqlCommand(sqldata, conn)
		Adapter.SelectCommand = command
		Adapter.Fill(ds)
		Adapter.Dispose()
		command.Dispose()
		conn.Close()
		DgvSOdetList.DataSource = ds.Tables(0)
		DgvSOdetList.DataBind()

	End Sub

	Private Sub DgvSOList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DgvSOList.SelectedIndexChanged

		FillSOdetLis()

		If txtSONo.Text <> "" Then
			Exit Sub

		Else
			txtSONo.Text = DgvSOList.SelectedRow.Cells(1).Text
			ExecBtn()
			TabContainer1.ActiveTabIndex = 0

		End If

	End Sub


	Private Sub lbPlant_Click(sender As Object, e As EventArgs) Handles lbPlant.Click
		If cboPlnt.Text = Nothing Then
			Exit Sub
		End If

		PopMovType()
		PopSignaturies()
		PopPClass()

	End Sub

	Private Sub lbMovType_Click(sender As Object, e As EventArgs) Handles lbMovType.Click
		If cboMovType.Text = Nothing Then
			Exit Sub
		End If

		MovTypeExec()

		CustListProc()

	End Sub

	Protected Sub ExecBtn()
		If txtSONo.Text <> "" Then
			Select Case cboMovType.Text.Substring(0, 3)
				Case "201"
					Exit Sub

			End Select

			dt = GetDataTable("select delstat from sohdrtbl where sono = '" & txtSONo.Text & "' and delstat = 'served'")
			If Not CBool(dt.Rows.Count) Then
				'MsgBox("SO not found or not yet Approved")
				'PreSaveProc()
				GetSOdetAll()

			Else
				For Each dr As DataRow In dt.Rows
					'Call MessageBox.Show("SO No. " & txtSONo.Text & " / Status: " & dr.Item(0).ToString(), "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
					Exit Sub

				Next
				Call dt.Dispose()

			End If

			txtRefNo.Focus()

		End If

	End Sub

	Private Sub DgvDOdet_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DgvDOdet.SelectedIndexChanged
		If dpTransDate.Text = Nothing Then
			AdmMsgBox("Date is blank")
			Exit Sub

		End If

		txtItm.Text = DgvDOdet.SelectedRow.Cells(1).Text
		txtCodeNo.Text = DgvDOdet.SelectedRow.Cells(2).Text

		If txtItm.Text = "" Then
			tssErrorMsg.Text = "Line Item No. is Blank"
			Exit Sub
		ElseIf txtCodeNo.Text = "" Or txtCodeNo.text = Nothing Then
			tssErrorMsg.Text = "Code No. is Blank"
			Exit Sub
		End If

		GetCodeNoDesc()
		GetLineToEdit()

		DgvDOdet.SelectedIndex = Nothing

	End Sub

	Protected Sub GetLineToEdit()
		dt = GetDataTable("select ifnull(qty,0),ifnull(wt,0),ifnull(sp,0),ifnull(itmamt,0) from tempissdettbl " &
						  "where itmno = " & txtItm.Text & " and user = '" & lblUser.Text & "'")
		If Not CBool(dt.Rows.Count) Then

		Else
			For Each dr As DataRow In dt.Rows
				txtQty.Text = Format(CDbl(dr.Item(0).ToString()), "#,##0")
				txtWt.Text = Format(CDbl(dr.Item(1).ToString()), "#,##0.00")
				txtSP.Text = Format(CDbl(dr.Item(2).ToString()), "#,##0.00")
				lblAmt.Text = Format(CDbl(dr.Item(3).ToString()), "#,##0.00")


			Next

		End If

		dt.Dispose()

	End Sub

	Private Sub btnReset_Click(sender As Object, e As ImageClickEventArgs) Handles btnReset.Click

		ClrLines()
	End Sub

	Protected Sub ClrLines()

		Dim lvCount As Long = DgvDOdet.Rows.Count
		txtItm.Text = lvCount + 1

		txtCodeNo.Text = ""
		cboMMdesc.Text = Nothing
		txtQty.Text = ""
		txtWt.Text = ""
		'cboSLoc.Text = ""
		cboLotNo.Items.Clear()
		cboLotNo.Text = Nothing
		txtSP.Text = ""
		lblAmt.Text = ""

		txtUMmatl.Text = ""
		lblBillRef.Text = ""
		txtCodeNo.ReadOnly = False
		CheckBox7.Checked = False
		admStopMMdesc = Nothing

	End Sub

	Private Sub CheckBox7_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox7.CheckedChanged
		If CheckBox7.Checked = True Then
			CheckBox7.Text = "Deal"
		Else
			CheckBox7.Text = "SP/UC"
		End If

	End Sub

	Private Sub cboMMdesc_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboMMdesc.SelectedIndexChanged
		If admStopMMdesc = "Stop" Then
			Exit Sub
		End If

		GetCodeNoNew()

	End Sub

	Protected Sub GetCodeNoNew()
		dt = GetDataTable("select codeno from mmasttbl where ifnull(codename,mmdesc) = '" & cboMMdesc.Text & "'")
		If Not CBool(dt.Rows.Count) Then

		Else
			For Each dr As DataRow In dt.Rows
				txtCodeNo.Text = dr.Item(0).ToString()

			Next

		End If

		dt.Dispose()

		GetMMdetailsAll()

	End Sub

	Private Sub cboSLoc_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboSLoc.SelectedIndexChanged

		GetSLocNo()

	End Sub

	Private Sub txtCodeNo_TextChanged(sender As Object, e As EventArgs) Handles txtCodeNo.TextChanged

		'If Not Me.IsPostBack Then

		'End If

		GetCodeNoDesc()

	End Sub

	Protected Sub GetCodeNoDesc()
		dt = GetDataTable("select ifnull(codename,mmdesc) from mmasttbl where codeno = '" & txtCodeNo.Text & "'")
		If Not CBool(dt.Rows.Count) Then

		Else
			For Each dr As DataRow In dt.Rows
				cboMMdesc.Text = dr.Item(0).ToString()
			Next

		End If

		dt.Dispose()
		GetMMdetailsAll()
		admStopMMdesc = "Stop"

	End Sub

	Protected Sub GetMMdetailsAll()
		dt = GetDataTable("select billref,packing,um,ifnull(admdigit,'2'),ifnull(qtpk,0) from mmasttbl where " &
						  "codeno = '" & txtCodeNo.Text & "'")
		If Not CBool(dt.Rows.Count) Then

		Else
			For Each dr As DataRow In dt.Rows
				lblBillRef.Text = dr.Item(0).ToString()
				If CheckBox3.Checked = True Then

				End If

				txtUMmatl.Text = dr.Item(2).ToString() & ""
				cboAdmDig.Text = dr.Item(3).ToString() & ""
				lblQtPk.Text = Format(CDbl(dr.Item(4).ToString()), "#,##0.00")

			Next

		End If

		dt.Dispose()

		GetLotNo()

	End Sub

	Protected Sub GetLotNo()

		Select Case cboMovType.Text.Substring(0, 3)
			Case "607"
				'query from wipdet

			Case Else
				GetLotNoCodeNo()

				cboLotNo.Items.Clear() 'templotnos2tbl
				cboLotNo.Text = Nothing

				dt = GetDataTable("select lotno from tempinvtbl2 where user = '" & lblUser.Text & "' order by lotno") 'and wtbal > 0 or qtybal > 0 
				If Not CBool(dt.Rows.Count) Then
					tssErrorMsg.Text = "No Lot No. Found"
					Exit Sub
				Else
					For Each dr As DataRow In dt.Rows
						cboLotNo.Items.Add(dr.Item(0).ToString())

					Next

				End If

				Call dt.Dispose()

		End Select

	End Sub

	Protected Sub GetLotNoCodeNo()

		CheckTables()

		sql = "delete from tempinvtbl where user = '" & lblUser.Text & "'"
		ExecuteNonQuery(sql)

		'insert inventory in
		sql = "insert into tempinvtbl(lotno,qty_in,wt_in,user) " &
			  "select a.lotno,ifnull(sum(a.qty),0),ifnull(sum(a.wt),0),'" & lblUser.Text & "' from invdettbl a " &
			  "left join invhdrtbl b on a.mmrrno=b.mmrrno where a.codeno = '" & txtCodeNo.Text & "' and " &
			  "b.status <> 'void' and b.plntno = '" & cboPlnt.Text.Substring(0, 3) & "' and " &
			  "b.transdate <= '" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' group by a.lotno"
		ExecuteNonQuery(sql)

		'insert wrr
		sql = "insert into tempinvtbl(lotno,qty_in,wt_in,user) " &
			  "select a.lotno,ifnull(sum(a.qty),0),ifnull(sum(a.wt),0),'" & lblUser.Text & "' from wrrdettbl a " &
			  "left join wrrhdrtbl b on a.wrrno=b.wrrno where a.codeno = '" & txtCodeNo.Text & "' and " &
			  "b.status <> 'void' and b.plntno = '" & cboPlnt.Text.Substring(0, 3) & "' and b.transdate <= " &
			  "'" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' group by a.lotno"
		ExecuteNonQuery(sql)

		'insert issuance
		sql = "insert into tempinvtbl(lotno,qty_out,wt_out,user) " &
			  "select a.lotno,ifnull(sum(a.qty),0),ifnull(sum(a.wt),0),'" & lblUser.Text & "' from issdettbl a " &
			  "left join isshdrtbl b on a.dono=b.dono where a.codeno = '" & txtCodeNo.Text & "' and " &
			  "b.status <> 'void' and b.plntno = '" & cboPlnt.Text.Substring(0, 3) & "' and b.transdate <= " &
			  "'" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' group by a.lotno"
		ExecuteNonQuery(sql)

		''adjtable in
		sql = "insert into tempinvtbl(lotno,qty_in,wt_in,user,codeno) " &
			  "select a.lotno,sum(ifnull(a.stdqty,0)),sum(ifnull(a.stdwt,0)),'" & lblUser.Text & "','in' from invadjdettbl a " &
			  "left join invadjhdrtbl b on a.dono=b.dono where a.codeno = '" & txtCodeNo.Text & "' and " &
			  "a.pono = 'PARK' and b.plntno = '" & cboPlnt.Text.Substring(0, 3) & "' and b.transdate <= " &
			  "'" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' and a.tc = '10' group by a.lotno"
		ExecuteNonQuery(sql)
		'adj out
		sql = "insert into tempinvtbl(lotno,qty_out,wt_out,user,codeno) " &
			  "select a.lotno,sum(ifnull(a.qty,0)),sum(ifnull(a.wt,0)),'" & lblUser.Text & "','out' from invadjdettbl a " &
			  "left join invadjhdrtbl b on a.dono=b.dono where a.codeno = '" & txtCodeNo.Text & "' and " &
			  "a.pono = 'PARK' and b.plntno = '" & cboPlnt.Text.Substring(0, 3) & "' and b.transdate <= " &
			  "'" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' and a.tc = '30' group by a.lotno"
		ExecuteNonQuery(sql)

		dt = GetDataTable("select * from information_schema.tables where table_schema =  '" & vDbase & "' and " &
						  "table_name = 'tempinvtbl2'")
		If Not CBool(dt.Rows.Count) Then
			sql = "CREATE TABLE tempinvtbl2 LIKE tempinvtbl"
			ExecuteNonQuery(sql)

		Else
			sql = "delete from tempinvtbl2 where user = '" & lblUser.Text & "'"
			ExecuteNonQuery(sql)

		End If

		dt.Dispose()

		sql = "insert into tempinvtbl2(lotno,qty_in,wt_in,qty_out,wt_out,user,codeno) select lotno,sum(ifnull(qty_in,0))," &
			  "sum(ifnull(wt_in,0)),sum(ifnull(qty_out,0)),sum(ifnull(wt_out,0)),'" & lblUser.Text & "','" & txtCodeNo.Text & "' " &
			  "from tempinvtbl where user = '" & lblUser.Text & "' group by lotno"
		ExecuteNonQuery(sql)

		sql = "update tempinvtbl2 set qty_bal = ifnull(qty_in,0)-ifnull(qty_out,0), wt_bal = ifnull(wt_in,0)-ifnull(wt_out,0) " &
			  "where user = '" & lblUser.Text & "'"
		ExecuteNonQuery(sql)

		sql = "delete from tempinvtbl2 where user = '" & lblUser.Text & "' and qty_bal <= 0 and wt_bal <= 0"
		ExecuteNonQuery(sql)

		Select Case LCase(lblBillRef.Text)
			Case "qty"
				sql = "delete from tempinvtbl2 where user = '" & lblUser.Text & "' and qty_bal <= 0"
				ExecuteNonQuery(sql)
			Case Else
				sql = "delete from tempinvtbl2 where user = '" & lblUser.Text & "' and wt_bal <= 0"
				ExecuteNonQuery(sql)
		End Select


	End Sub

	Protected Sub CheckTables()
		dt = GetDataTable("select * from information_schema.tables where table_schema =  '" & vDbase & "' and " &
						  "table_name = 'invadjhdrtbl'")
		If Not CBool(dt.Rows.Count) Then
			sql = "CREATE TABLE invadjhdrtbl LIKE isshdrtbl"
			ExecuteNonQuery(sql)

		End If

		dt.Dispose()

		dt = GetDataTable("select * from information_schema.tables where table_schema =  '" & vDbase & "' and " &
						  "table_name = 'invadjdettbl'")
		If Not CBool(dt.Rows.Count) Then
			sql = "CREATE TABLE invadjdettbl LIKE tempdodet"
			ExecuteNonQuery(sql)

		End If

		dt.Dispose()


	End Sub

	Private Sub cboPlnt2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboPlnt2.SelectedIndexChanged
		If cboPlnt.Text = Nothing Then
			Exit Sub

		ElseIf cboMovType.Text = Nothing Then
			AdmMsgBox("Select Movement Type")
			Exit Sub

		End If

		Plant2Proc()

		If dpTransDate.Text = Nothing Then
			tssErrorMsg.Text = "Date Not Yet Set"
			Exit Sub
		End If

		PopMMdesc()

	End Sub

	Protected Sub Plant2Proc()

		Select Case cboMovType.Text.Substring(0, 3)
			Case 301
				getPlantCust2()


		End Select

	End Sub

	Protected Sub GetPlantCust2()
		cboCustName.Items.Clear()
		cboShipTo.Items.Clear()

		dt = GetDataTable("select concat(a.custno,space(1),b.bussname) from plnttbl a left join custmasttbl b on a.custno=b.custno " &
						  "where a.plntno = '" & cboPlnt2.Text.Substring(0, 3) & "'")
		If Not CBool(dt.Rows.Count) Then
			tssErrorMsg.Text = "Not found."
			Exit Sub

		Else
			For Each dr As DataRow In dt.Rows
				cboCustName.Items.Add(dr.Item(0).ToString())
				cboShipTo.Items.Add(dr.Item(0).ToString())
				cboCustName.Text = dr.Item(0).ToString()
				cboShipTo.Text = dr.Item(0).ToString()

			Next

		End If

		Call dt.Dispose()

	End Sub

	Private Sub lbPlnt2_Click(sender As Object, e As EventArgs) Handles lbPlnt2.Click
		If Not Me.IsPostBack Then

		End If

		GetPlantCust2()

		If dpTransDate.Text = Nothing Then
			tssErrorMsg.Text = "Date Not Yet Set"
			Exit Sub
		End If

		PopMMdesc()

	End Sub

	Private Sub btnAdd_Click(sender As Object, e As ImageClickEventArgs) Handles btnAdd.Click
		AddItem()

	End Sub

	Protected Sub AddItem()
		If cboLotNo.Text = "" Then
			cboLotNo.Focus()
			AdmMsgBox("Select Lot No.")
			Exit Sub

		ElseIf txtCodeNo.Text = "" Then
			cboMMdesc.Focus()
			AdmMsgBox("Select Material from SO")
			Exit Sub

		ElseIf cboMMdesc.Text = Nothing Then
			AdmMsgBox("MM Description is Blank")
			Exit Sub

		ElseIf txtQty.Text = "" Then
			txtQty.Focus()
			AdmMsgBox("Qty is Blank")
			Exit Sub

		ElseIf txtWt.Text = "" Then
			txtWt.Focus()
			AdmMsgBox("Wt/Vol. is Blank")
			Exit Sub

		ElseIf txtSP.Text = "" Then
			txtSP.Focus()
			AdmMsgBox("SP is Blank")
			Exit Sub

		ElseIf cboSmnName.Text <> "" Then
			Select Case cboMovType.Text.Substring(0, 3)
				Case "601"
					If txtSONo.Text = "" Then
						txtSONo.Focus()
						AdmMsgBox("SO No. is Blank")
						Exit Sub

					End If

				Case Else

			End Select

		ElseIf txtItm.Text = "" Then
			AdmMsgBox("Line Item Number is Blank")
			Exit Sub

		ElseIf cboMovType.Text.Substring(0, 3) = "201" Then
			If txtUMmatl.Text = "" Then
				AdmMsgBox("UM is Blank")
				Exit Sub

			ElseIf txtRefNo.Text = "" Then
				AdmMsgBox("Prod No. is Blank, please indicate to Ref No. Field")
				txtSONo.Focus()
				Exit Sub

			End If

		ElseIf CheckBox7.Checked = True Then
			If CDbl(IIf(txtSP.Text = "", 0, txtSP.Text)) > 0 Then
				AdmMsgBox("Deal Item Should have no SP")
				Exit Sub
			End If

		End If

		'check bill ref for 601

		Select Case cboMovType.Text.Substring(0, 3)
			Case "601"
				dt = GetDataTable("select ifnull(billref,'No Bill Ref') from mmasttbl where codeno = '" & txtCodeNo.Text & "'")
				If Not CBool(dt.Rows.Count) Then
					AdmMsgBox("Code No. " & txtCodeNo.Text & " Not Found")
					Exit Sub

				Else
					For Each dr As DataRow In dt.Rows
						Select Case dr.Item(0).ToString()
							Case "No Bill Ref"
								AdmMsgBox("No Bill Ref Assigned, please Contact Material Maintenance ")
								Exit Sub

							Case ""
								AdmMsgBox("No Bill Ref Assigned, please Contact Material Maintenance ")
								Exit Sub

							Case Else
								lblBillRef.Text = dr.Item(0).ToString()

						End Select

					Next
				End If

				dt.Dispose()

				txtCodeNo.ReadOnly = False

		End Select

		'check item no.
		'change to mySQL query
		dt = GetDataTable("select codeno from tempissdettbl where itmno = " & txtItm.Text & " and " &
						  "user = '" & lblUser.Text & "'")
		If Not CBool(dt.Rows.Count) Then

		Else
			sql = "delete from tempissdettbl where itmno = " & txtItm.Text & " and user = '" & lblUser.Text & "'"
			ExecuteNonQuery(sql)

		End If

		dt.Dispose()

		Select Case cboMovType.Text.Substring(0, 3)
			Case "601"
				If CheckBox7.Checked = True Then
					Amt = CDbl(0)
				Else
					Select Case UCase(lblBillRef.Text)
						Case "WT"
							Amt = CDbl(IIf(txtSP.Text = "", 0, txtSP.Text)) * CDbl(IIf(txtWt.Text = "", 0, txtWt.Text))
						Case "QTY"
							Amt = CDbl(IIf(txtSP.Text = "", 0, txtSP.Text)) * CDbl(IIf(txtQty.Text = "", 0, txtQty.Text))
						Case Else
							Amt = CDbl(IIf(txtSP.Text = "", 0, txtSP.Text)) * CDbl(IIf(txtWt.Text = "", 0, txtWt.Text))
					End Select
				End If

			Case Else
				Amt = CDbl(IIf(lblAmt.Text = "", 0, lblAmt.Text)) '6

		End Select


		sql = "insert into tempissdettbl(itmno,codeno,qty,wt,sp,itmamt,sloc,lotno,adddesc,um,billref,user)values" &
			  "('" & txtItm.Text & "','" & txtCodeNo.Text & "'," & CDbl(IIf(txtQty.Text = "", 0, txtQty.Text)) & "," &
			  CDbl(IIf(txtWt.Text = "", 0, txtWt.Text)) & "," & CDbl(IIf(txtSP.Text = "", 0, txtSP.Text)) & "," &
			  CDbl(Amt) & ",'" & lblSLoc.Text & "','" & cboLotNo.Text & "','" & admAddDesc & "','" & txtUMmatl.Text & "'," &
			  "'" & lblBillRef.Text & "','" & lblUser.Text & "')"
		ExecuteNonQuery(sql)

		AddToLotNoTbl()

		Select Case vLoggedBussArea
			Case "8100"
				SaveToPrintTable()
		End Select

		Call ClrLines()
		tsSaveStat.Text = "Not yet Saved"

		FillLvSOdet()

	End Sub

	Protected Sub AddToLotNoTbl()
		sql = "insert into templotnotbl(user,codeno,lotno,note,docno)values('" & lblUser.Text & "','" & txtCodeNo.Text & "'," &
			  "'" & cboLotNo.Text & "','In used','" & txtDONo.Text & "')"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub SaveToPrintTable()
		dt = GetDataTable("select * from mmastprttbl where codeno = '" & txtCodeNo.Text & "'")
		If Not CBool(dt.Rows.Count) Then

		Else
			sql = "delete from mmastprttbl where codeno = '" & txtCodeNo.Text & "'"
			ExecuteNonQuery(sql)

		End If

		sql = "insert into mmastprttbl(codeno,mmdesc,user,dcreate)values('" & txtCodeNo.Text & "'," &
			  "'" & cboMMdesc.Text & "','" & lblUser.Text & "','" & Format(CDate(Now()), "yyyy-MM-dd HH:mm:ss") & "')"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub lbSave_Click(sender As Object, e As EventArgs)
		If cboSmnName.Text = Nothing Or cboSmnName.Text = "" Then
			admSmnNo = ""
		Else
			admSmnNo = cboSmnName.Text.Substring(0, 3)
		End If

		If cboPlnt.Text = Nothing Or cboPlnt.Text = "" Then
			admPlntNo = ""
		Else
			admPlntNo = cboPlnt.Text.Substring(0, 3)
		End If

		If cboPlnt2.Text = Nothing Or cboPlnt2.Text = "" Then
			admPlntNo2 = ""
		Else
			admPlntNo2 = cboPlnt2.Text.Substring(0, 3)
		End If

		Save_PostTrans()

	End Sub

	Protected Sub Save_PostTrans()
		If cboMovType.Text = "" Then
			AdmMsgBox("Select Movement Type")
			Exit Sub

		ElseIf cboPlnt.Text = "" Then
			AdmMsgBox("Select Source Plant")
			Exit Sub
		ElseIf cboCustName.Text = Nothing Then
			AdmMsgBox("Sold To No. is Blank")
			Exit Sub

		ElseIf cboShipTo.Text = Nothing Then
			AdmMsgBox("Ship To is Blank")
			Exit Sub

		ElseIf txtRefNo.Text = "" Or txtRefNo.Text = Nothing Then
			Select Case cboMovType.Text.Substring(0, 3)
				Case "201"
					AdmMsgBox("Please Input Prodn. Worksheet No.")
				Case Else
					AdmMsgBox("Please Input Actual Doc No.")
			End Select

			Exit Sub

		ElseIf DgvDOdet.Rows.Count = 0 Then
			AdmMsgBox("No Line Item yet")
			Exit Sub

		ElseIf cboCheckBy.Text = "" Then
			Select Case vLoggedBussArea
				Case "8300"
					MsgBox("Checked By is Blank")
					Exit Sub
			End Select

		ElseIf cboMovType.Text.Substring(0, 3) = "301" Then
			If cboPlnt2.Text = "" Then
				AdmMsgBox("Select Destination Plant/Warehouse")
				Exit Sub
			End If

		End If

		Select Case vLoggedBussArea
			Case "8300"
				If cboMovType.Text.Substring(0, 3) = "201" Then
					If cboFGmmGrp.Text = "" Then
						AdmMsgBox("Select FG MM Grp")
						Exit Sub
					End If
				End If
		End Select

		admUpdateNo = Format(CDate(Now()), "yyMMddHHmmss")

		If tssDocStat.Text = "New" Then
			If txtDONo.Text = "" Or txtDONo.Text = Nothing Then
				GetDONo()

				If IsNumeric(txtDONo.Text) Then
					gRepTbox(txtRemarks)
					Call SaveHdrDoProc()
					Call SaveDODetProc()
					gRepTboxUndo(txtRemarks)
				Else
					MsgBox("Invalid Character in DO No.")
					txtDONo.Text = ""
					Exit Sub
				End If

			End If
		Else
			If tsDocNoEdit.Text <> txtDONo.Text Then
				MsgBox("DO No. should not be CHANGED")
				txtDONo.Text = tsDocNoEdit.Text
				Exit Sub

			End If
		End If

		If txtDONo.Text = "" Then
			MsgBox("DO No. is Blank")
			Exit Sub
		End If

		'verify if already used in SI
		If IsNumeric(txtDONo.Text) Then
			gRepTbox(txtRemarks)
			Call SaveHdrDoProc()
			Call SaveDODetProc()
			gRepTboxUndo(txtRemarks)
		Else
			MsgBox("Invalid Character in DO No.")
			txtDONo.Text = ""
			Exit Sub

		End If

		tsSaveStat.Text = "SAVED"
		admStatType = Nothing

		'Select Case cboMovType.Text.Substring(0, 3)
		'	Case "501"
		'		mdiMain.tslblLastDoc2.Text = "DO No.: " & txtDONo.Text & " / PARK"

		'	Case "601"
		'		mdiMain.tslblLastDoc2.Text = "DO No.: " & txtDONo.Text & " / SO No.: " & txtSONo.Text

		'	Case Else
		'		mdiMain.tslblLastDoc2.Text = "DO No.: " & txtDONo.Text

		'End Select

		'insert GL entry here
		OnConfirm4()

		'Answer = MsgBox("DO No. " & txtDONo.Text & " Save, do you want to Print Now?", vbExclamation + vbYesNo)
		'If Answer = vbYes Then
		'	ToolStripMenuItem3.PerformClick()
		'	'Call clrFields()

		'Else
		'	Exit Sub

		'End If

	End Sub

	Protected Sub OnConfirm4()
		Dim confirmValue As String = Request.Form("confirm_value")
		If confirmValue = "Yes" Then
			AdmMsgBox("Printing On")

		Else
			AdmMsgBox("Action Aborted")

		End If

	End Sub

	Protected Sub GetDONo()
		Select Case cboMovType.Text.Substring(0, 3)
			Case "201"
				dt = GetDataTable("select max(dono) from isshdrtbl where dono between '40000000' and '49999999' and tc = '" & lblTC.Text & "' order by dono")
				If Not CBool(dt.Rows.Count) Then
					txtDONo.Text = "40000001"

				Else
					For Each dr As DataRow In dt.Rows
						txtDONo.Text = Format(CLng(dr.Item(0).ToString()) + 1, "#00000000")

					Next

				End If

				Call dt.Dispose()

			Case Else
				dt = GetDataTable("select dono from isshdrtbl where dono between '50000001' and '60000000' and tc = '" & lblTC.Text & "' order by dono")
				If Not CBool(dt.Rows.Count) Then
					txtDONo.Text = "50000001"

				Else
					For Each dr As DataRow In dt.Rows
						txtDONo.Text = Format(CLng(dr.Item(0).ToString()) + 1, "#00000000")

					Next

				End If

				Call dt.Dispose()

		End Select

		txtDONo.ReadOnly = True


	End Sub

	Protected Sub SaveHdrDoProc()
		dt = GetDataTable("select * from isshdrtbl where dono = '" & Trim(txtDONo.Text) & "' and tc = '" & lblTC.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			Call SaveDOHdr()

		Else
			If admStatType = "Initial" Then

			Else
				admStatType = "Update"
				SaveDOhdrOldData()
			End If

			SaveDOHdrUpdate()

		End If

		Call dt.Dispose()

		strStat = "SAVE"
		LogMeIn()

		'for mov 501 'scrapping

		Select Case cboMovType.Text.Substring(0, 3)
			Case "501"
				'create/check new table
				dt = GetDataTable("select * from information_schema.tables where table_schema =  '" & vDbase & "' and " &
								  "table_name = 'issscrphdrtbl'")
				If Not CBool(dt.Rows.Count) Then
					sql = "CREATE TABLE issscrphdrtbl LIKE isshdrtbl"
					ExecuteNonQuery(sql)

				End If

				dt.Dispose()

				dt = GetDataTable("select * from information_schema.tables where table_schema =  '" & vDbase & "' and " &
								  "table_name = 'issscrpdettbl'")
				If Not CBool(dt.Rows.Count) Then
					sql = "CREATE TABLE issscrpdettbl LIKE issdettbl"
					ExecuteNonQuery(sql)

				End If

				dt.Dispose()

				ScrapsaveProc()

		End Select

		sql = "update isshdrtbl set sysver = '" & admVersion & "' where dono = '" & txtDONo.Text & "'"
		ExecuteNonQuery(sql)


	End Sub

	Protected Sub ScrapsaveProc()
		dt = GetDataTable("select * from isshdrtbl where dono = '" & Trim(txtDONo.Text) & "' and tc = '" & lblTC.Text & "'")
		If Not CBool(dt.Rows.Count) Then

		Else
			sql = "update isshdrtbl set status = 'PARK' where dono = '" & Trim(txtDONo.Text) & "' and tc = '" & lblTC.Text & "'"
			ExecuteNonQuery(sql)

		End If

		dt = GetDataTable("select * from issscrphdrtbl where dono = '" & Trim(txtDONo.Text) & "' and tc = '" & lblTC.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			ScrapSaveHdr()

		Else
			ScrapUpdateHdr()

		End If

		Call dt.Dispose()
		'update status to 'PARK'

		'check details if available, delete if yes

		dt = GetDataTable("select * from issdettbl where dono = '" & Trim(txtDONo.Text) & "'")
		If Not CBool(dt.Rows.Count) Then


		Else
			'old data
			SaveDetOldData()

			sql = "delete from issdettbl where dono = '" & Trim(txtDONo.Text) & "' and tc = '" & lblTC.Text & "'"
			ExecuteNonQuery(sql)

		End If

		Call dt.Dispose()

		dt = GetDataTable("select * from issscrpdettbl where dono = '" & Trim(txtDONo.Text) & "'")
		If Not CBool(dt.Rows.Count) Then


		Else
			sql = "delete from issscrpdettbl where dono = '" & Trim(txtDONo.Text) & "'"
			ExecuteNonQuery(sql)

		End If

		Call dt.Dispose()

		ScrapSaveDet()

	End Sub

	Protected Sub ScrapSaveHdr()
		sql = "insert into issscrphdrtbl(dono,transdate,ba,plntno,tc,custno,shipto,user,dsrno,dsrstat,status,refdoc,mov,pdate,ttype," &
			  "branch,remarks)values('" & Trim(txtDONo.Text) & "','" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "'," &
			  "'" & vLoggedBussArea & "','" & admPlntNo & "','" & lblTC.Text & "','" & cboCustName.Text.Substring(0, 5) & "'," &
			  "'" & cboShipTo.Text.Substring(0, 5) & "','" & lblUser.Text & "','00000','open','PARK','" & txtRefNo.Text & "'," &
			  "'" & cboMovType.Text.Substring(0, 3) & "','" & Format(CDate(Now), "yyyy-MM-dd HH:mm:ss") & "'," &
			  "'Post','" & vLoggedBranch & "','" & txtRemarks.Text & "')"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub ScrapUpdateHdr()
		sql = "update issscrphdrtbl set transdate = '" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "',ba = '" & vLoggedBussArea & "'," &
			  "badest = '" & cboCustName.Text.Substring(0, 5) & "',plntno = '" & admPlntNo & "',tc = '" & lblTC.Text & "'," &
			  "custno = '" & cboCustName.Text.Substring(0, 5) & "',shipto = '" & cboShipTo.Text.Substring(0, 5) & "'," &
			  "user = '" & lblUser.Text & "',sono = '" & txtSONo.Text & "',dsrno = '00000',dsrstat = 'open'," &
			  "refdoc = '" & txtRefNo.Text & "',mov = '" & cboMovType.Text.Substring(0, 3) & "',remarks = '" & txtRemarks.Text & "'," &
			  "status = 'PARK' where dono = '" & Trim(txtDONo.Text) & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub ScrapSaveDet()
		sql = "insert into issscrpdettbl(dono,codeno,qty,wt,itmno,sloc,slocto,mov,smnno,sp,itmamt,lotno,billref)" &
			  "select dono,codeno,qty,wt,itmno,sloc,slocto,mov,smnno,sp,itmamt,lotno,billref from tempissdettbl " &
			  "where user = '" & lblUser.Text & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub SaveDOhdrOldData()
		sql = "insert into isshdrtbl_update(dono,transdate,ba,badest,smnno,plntno,totqty,totwt,tc," &
			  "custno,shipto,user,sono,dsrno,dsrstat,status,refdoc,mov,pono,pdate,ttype,driver," &
			  "plateno,branch,plntdest,remarks,checkedby,fgmmgrp,pc,nosi,updateid,updatetype,updateby," &
			  "updatedate) select dono,transdate,ba,badest,smnno,plntno,totqty,totwt,tc,custno,shipto," &
			  "user,sono,dsrno,dsrstat,status,refdoc,mov,pono,pdate,ttype,driver,plateno,branch,plntdest,remarks," &
			  "checkedby,fgmmgrp,pc,nosi,'" & admUpdateNo & "','" & admStatType & "','" & lblUser.Text & "'," &
			  "'" & Format(CDate(Now()), "yyyy-MM-dd HH:mm:ss") & "' from isshdrtbl where dono = '" & txtDONo.Text & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub SaveDOHdrUpdate()

		sql = "update isshdrtbl set transdate = '" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "',ba = '" & vLoggedBussArea & "'," &
			  "badest = '" & cboCustName.Text.Substring(0, 5) & "',smnno = '" & admSmnNo & "',plntno = '" & admPlntNo & "'," &
			  "totqty = " & CLng(IIf(lblTotQty.Text = "", 0, lblTotQty.Text)) & ",totwt = " & CDbl(IIf(lblTotWt.Text = "", 0, lblTotWt.Text)) & "," &
			  "tc = '" & lblTC.Text & "',custno = '" & cboCustName.Text.Substring(0, 5) & "',shipto = '" & cboShipTo.Text.Substring(0, 5) & "'," &
			  "user = '" & lblUser.Text & "',sono = '" & txtSONo.Text & "',dsrno = '00000',dsrstat = 'open',refdoc = '" & txtRefNo.Text & "'," &
			  "mov = '" & cboMovType.Text.Substring(0, 3) & "',pono = '" & txtPOno.Text & "',pdupdate = '" & Format(CDate(Now), "yyyy-MM-dd HH:mm:ss") & "'," &
			  "driver = '" & txtDriver.Text & "',plateno = '" & txtPlNo.Text & "',plntdest = '" & admPlntNo2 & "',remarks = '" & txtRemarks.Text & "'," &
			  "checkedby = '" & cboCheckBy.Text & "' where dono = '" & Trim(txtDONo.Text) & "'"
		ExecuteNonQuery(sql)

		SaveCheckedBy()

		Select Case cboMovType.Text.Substring(0, 3)
			Case "201"
				Select Case vLoggedBussArea
					Case "8300"
						sql = "update isshdrtbl set fgmmgrp = '" & cboFGmmGrp.Text & "' where dono = '" & Trim(txtDONo.Text) & "'"
						ExecuteNonQuery(sql)
				End Select

			Case "601"
				Select Case vLoggedBussArea
					Case "8100", "8200"
						sql = "update isshdrtbl set pc = '1' where dono = '" & Trim(txtDONo.Text) & "'"
						ExecuteNonQuery(sql)
					Case "8300"
						sql = "update isshdrtbl set pc = '" & cboPClass.Text.Substring(0, 1) & "' where dono = '" & Trim(txtDONo.Text) & "'"
						ExecuteNonQuery(sql)
				End Select

			Case "613"
				Select Case vLoggedBussArea
					Case "8100", "8200"
						sql = "update isshdrtbl set pc = '1' where dono = '" & Trim(txtDONo.Text) & "'"
						ExecuteNonQuery(sql)
					Case "8300"
						sql = "update isshdrtbl set pc = '" & cboPClass.Text.Substring(0, 1) & "' where dono = '" & Trim(txtDONo.Text) & "'"
						ExecuteNonQuery(sql)

				End Select
		End Select

	End Sub

	Protected Sub SaveDOHdr()
		sql = "insert into isshdrtbl(dono,transdate,ba,badest,smnno,plntno,totqty,totwt,tc," &
			  "custno,shipto,user,sono,dsrno,dsrstat,status,refdoc,mov,pono,pdate,ttype,driver," &
			  "plateno,branch,plntdest,remarks,checkedby)values('" & Trim(txtDONo.Text) & "'," &
			  "'" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "','" & vLoggedBussArea & "'," &
			  "'" & cboCustName.Text.Substring(0, 5) & "','" & admSmnNo & "','" & admPlntNo & "'," &
			  CLng(IIf(lblTotQty.Text = "", 0, lblTotQty.Text)) & "," & CDbl(IIf(lblTotWt.Text = "", 0, lblTotWt.Text)) & "," &
			  "'" & lblTC.Text & "','" & cboCustName.Text.Substring(0, 5) & "','" & cboShipTo.Text.Substring(0, 5) & "'," &
			  "'" & lblUser.Text & "','" & txtSONo.Text & "','00000','open','open','" & txtRefNo.Text & "'," &
			  "'" & cboMovType.Text.Substring(0, 3) & "','" & txtPOno.Text & "','" & Format(CDate(Now), "yyyy-MM-dd hh:mm:ss") & "'," &
			  "'Post','" & txtDriver.Text & "','" & txtPlNo.Text & "','" & vLoggedBranch & "'," &
			  "'" & admPlntNo2 & "','" & txtRemarks.Text & "','" & cboCheckBy.Text & "')"
		ExecuteNonQuery(sql)

		SaveCheckedBy()

		Select Case cboMovType.Text.Substring(0, 3)
			Case "201"
				Select Case vLoggedBussArea
					Case "8300"
						sql = "update isshdrtbl set fgmmgrp = '" & cboFGmmGrp.Text & "' where dono = '" & Trim(txtDONo.Text) & "'"
						ExecuteNonQuery(sql)
				End Select

			Case "601"
				Select Case vLoggedBussArea
					Case "8100", "8200"
						sql = "update isshdrtbl set pc = '1' where dono = '" & Trim(txtDONo.Text) & "'"
						ExecuteNonQuery(sql)
					Case "8300"
						sql = "update isshdrtbl set pc = '" & cboPClass.Text.Substring(0, 1) & "' where dono = '" & Trim(txtDONo.Text) & "'"
						ExecuteNonQuery(sql)
				End Select


			Case "613"
				Select Case vLoggedBussArea
					Case "8100", "8200"
						sql = "update isshdrtbl set pc = '1' where dono = '" & Trim(txtDONo.Text) & "'"
						ExecuteNonQuery(sql)
					Case "8300"
						sql = "update isshdrtbl set pc = '" & cboPClass.Text.Substring(0, 1) & "' where dono = '" & Trim(txtDONo.Text) & "'"
						ExecuteNonQuery(sql)

				End Select
		End Select

	End Sub

	Protected Sub AutoInvSaveProc()
		If tssInvNo.Text = "00000000" Then
			dt = GetDataTable("select max(invno) from saleshdrtbl where invno between '70000000' and '79999999' order by invno")
			If Not CBool(dt.Rows.Count) Then
				tssInvNo.Text = "70000001"

			Else
				For Each dr As DataRow In dt.Rows
					tssInvNo.Text = Format(CLng(dr.Item(0).ToString()) + 1, "#00000000")

				Next

			End If

			Call dt.Dispose()

		End If

		SaveHdrProcInv()

	End Sub

	Protected Sub SaveInvHdrOldData()
		sql = "insert into saleshdrtbl_update(updateid,invno,tc,transdate,custno,smnno,dsrno,grossamt,discamt,fhamt," &
			  "netamt,dono,remarks,status,glstat,user,postdate,pc,vat,docno,dsrstat,shipto,branch,doctype,otherbadoc," &
			  "updateby,postupdate) select '" & admUpdateNo & "',invno,tc,transdate,custno,smnno,dsrno,grossamt,discamt,fhamt," &
			  "netamt,dono,remarks,status,glstat,user,postdate,pc,vat,docno,dsrstat,shipto,branch,doctype,otherbadoc," &
			  "'" & lblUser.Text & "','" & Format(CDate(Now), "yyyy-MM-dd hh:mm:ss") & "' from saleshdrtbl where invno = '" & tssInvNo.Text & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub SaveHdrProcInv()
		dt = GetDataTable("select * from saleshdrtbl where invno = '" & tssInvNo.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			Call SaveHdrInv()
		Else
			SaveInvHdrOldData()
			UpdateHdrInv()
		End If

		'Call SaveLogs()
		sql = "update isshdrtbl set invdate = '" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' where " &
			  "dono = '" & txtDONo.Text & "'"
		ExecuteNonQuery(sql)

		sql = "update saleshdrtbl set sysver = '" & admVersion & "' where invno = '" & tssInvNo.Text & "'"
		ExecuteNonQuery(sql)

		SaveDetProcInv()
		GLEntryProc()

	End Sub

	Protected Sub GLEntryProc()
		Dim strPtype As String = "POST"
		Dim strSourceDoc As String = "Sales"

		dt = GetDataTable("select * from gltranstbl where docno = '" & tssInvNo.Text & "' and jvsource = '" & strSourceDoc & "' " &
						  "and posttype = '" & strPtype & "'")
		If Not CBool(dt.Rows.Count) Then
			Call GLEntry()
		Else
			sql = "delete from gltranstbl where docno = '" & tssInvNo.Text & "' and jvsource = '" & strSourceDoc & "' " &
				  "and posttype = '" & strPtype & "'"
			ExecuteNonQuery(sql)

			Call GLEntry()

		End If

	End Sub

	Protected Sub GLEntry()
		Dim strPtype As String = "POST"
		Dim strSourceDoc As String = "Sales"

		dt = GetDataTable("select acctno,gldisc from pctrtbl where pc = '" & cboPClass.Text.Substring(0, 1) & "'")
		If Not CBool(dt.Rows.Count) Then Exit Sub

		For Each dr As DataRow In dt.Rows
			SalesAcct = dr.Item(0).ToString()
			DiscAcct = dr.Item(1).ToString()
		Next

		Call dt.Dispose()

		strARacctNo = "1110210"

		dt = GetDataTable("select nonexps from batbl where ba = '" & vLoggedBussArea & "'")
		If Not CBool(dt.Rows.Count) Then
			Exit Sub
		Else
			For Each dr As DataRow In dt.Rows
				strCCNo = dr.Item(0).ToString() & ""
			Next

		End If

		dt.Dispose()

		sql = "insert into gltranstbl(acctno,dramt,cramt,ccno,transyear,transmon,subacct," &
			  "user,jvsource,glstatus,dateposted,transdate,docno,tc,pc,pk,posttype,branch,bato,branchto)values" &
			  "('" & strARacctNo & "'," & CDbl(IIf(lblTotAmt.Text = "", 0, lblTotAmt.Text)) & "," &
			  CDbl(0) & ",'" & strCCNo & "','" & Format(CDate(dpSIdate.Text), "yyyy") & "'," &
			  "'" & Format(CDate(dpSIdate.Text), "MM") & "','" & cboCustName.Text.Substring(0, 5) & "'," &
			  "'" & lblUser.Text & "','" & strSourceDoc & "','open','" & Format(CDate(Now), "yyyy-MM-dd hh:mm:ss") & "'," &
			  "'" & Format(CDate(dpSIdate.Text), "yyyy-MM-dd") & "','" & tssInvNo.Text & "'," &
			  "'53','" & cboPClass.Text.Substring(0, 1) & "','09','" & strPtype & "'," &
			  "'" & vLoggedBranch & "','" & vLoggedBussArea & "','" & vLoggedBranch & "')"
		ExecuteNonQuery(sql)

		sql = "insert into gltranstbl(acctno,dramt,cramt,ccno,transyear,transmon,user,jvsource,glstatus,dateposted,transdate," &
			  "docno,tc,pc,pk,posttype,branch,bato,branchto) select '" & SalesAcct & "'," & CDbl(0) & "," &
			  CDbl(IIf(lblTotAmt.Text = "", 0, lblTotAmt.Text)) & ",ccno,'" & Format(CDate(dpSIdate.Text), "yyyy") & "'," &
			  "'" & Format(CDate(dpSIdate.Text), "MM") & "','" & lblUser.Text & "','" & strSourceDoc & "'," &
			  "'open','" & Format(CDate(Now), "yyyy-MM-dd hh:mm:ss") & "','" & Format(CDate(dpSIdate.Text), "yyyy-MM-dd") & "'," &
			  "'" & tssInvNo.Text & "','53','" & cboPClass.Text.Substring(0, 1) & "','40','" & strPtype & "'," &
			  "'" & vLoggedBranch & "','" & vLoggedBussArea & "','" & vLoggedBranch & "' from pctrtbl where " &
			  "pc = '" & cboPClass.Text.Substring(0, 1) & "'"
		ExecuteNonQuery(sql)

		Call dt.Dispose()

	End Sub

	Protected Sub SaveDetProcInv()
		dt = GetDataTable("select * from saleshdrtbl where invno = '" & tssInvNo.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			Call SaveHdrInv()

		End If

		dt = GetDataTable("select * from salesdettbl where invno = '" & tssInvNo.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			Call SaveDetInv()
			MsgBox("Invoice No. " & tssInvNo.Text & " Saved", MsgBoxStyle.Information)

		Else
			SaveDetInvOldData()

			sql = "delete from salesdettbl where invno = '" & tssInvNo.Text & "'"
			ExecuteNonQuery(sql)

			Call SaveDetInv()
			MsgBox("Invoice No. " & tssInvNo.Text & " Update", MsgBoxStyle.Information)

		End If

	End Sub

	Protected Sub SaveDetInvOldData()
		sql = "insert into salesdettbl_update(updateid,invno,codeno,qty,wt,sp,detgrossamt,detdiscamt,itmamt,itemno," &
			  "dsrno,billref,transdate,detvat,status,nv) select '" & admUpdateNo & "',invno,codeno,qty,wt,sp,detgrossamt," &
			  "detdiscamt,itmamt,itemno,dsrno,billref,transdate,detvat,status,nv from salesdettbl where invno = '" & tssInvNo.Text & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub SaveDetInv()
		sql = "insert into salesdettbl(invno,itemno,codeno,qty,wt,sp,itmamt,detgrossamt,detdiscamt," &
			  "dsrno,billref,transdate,detvat,status,nv,dealstat) select '" & tssInvNo.Text & "'," &
			  "itmno,codeno,qty,wt,sp,itmamt,itmamt," & CDbl(0) & ",'" & tssInvNo.Text & "',billref," &
			  "'" & Format(CDate(dpSIdate.Text), "yyyy-MM-dd") & "'," & CDbl(0) & ",'open','nv',status " &
			  "from tempissdettbl where user ='" & lblUser.Text & "' and lotno is not null"
		ExecuteNonQuery(sql)

		If txtDONo.Text <> "" Then
			sql = "update isshdrtbl set dsrno = '" & tssInvNo.Text & "',dsrstat = 'SERVED'," &
				  "salesdoc = 'DR' where dono = '" & txtDONo.Text & "'"
			ExecuteNonQuery(sql)

		End If

	End Sub

	Protected Sub UpdateHdrInv()
		Dim strStat As String = "OPEN"
		sql = "update saleshdrtbl set transdate = '" & Format(CDate(dpSIdate.Text), "yyyy-MM-dd") & "'," &
			  "custno = '" & cboCustName.Text.Substring(0, 5) & "',smnno = '" & admSmnNo & "',dsrno = '" & tssInvNo.Text & "'," &
			  "grossamt = " & CDbl(IIf(lblTotAmt.Text = "", 0, lblTotAmt.Text)) & "," &
			  "discamt = " & CDbl(0) & ",fhamt = " & CDbl(0) & ",netamt = " & CDbl(IIf(lblTotAmt.Text = "", 0, lblTotAmt.Text)) & "," &
			  "dono = '" & txtDONo.Text & "',remarks = '" & txtRemarks.Text & "',status = '" & strStat & "'," &
			  "glstat = '" & strStat & "',updateby = '" & lblUser.Text & "',postupdate = '" & Format(CDate(Now), "yyyy-MM-dd hh:mm:ss") & "'," &
			  "pc = '" & cboPClass.Text.Substring(0, 1) & "',vat = " & CDbl(0) & ",docno = '" & txtRefNo.Text & "',dsrstat = '" & strStat & "'," &
			  "shipto = '" & cboShipTo.Text.Substring(0, 5) & "',branch = '" & vLoggedBranch & "',doctype = 'DR' where " &
			  "invno = '" & tssInvNo.Text & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub SaveHdrInv()
		Dim strStat As String = "OPEN"
		sql = "insert into saleshdrtbl(invno,tc,transdate,custno,smnno,dsrno,grossamt,discamt,fhamt," &
			  "netamt,dono,remarks,status,glstat,user,postdate,pc,vat,docno,dsrstat,shipto,branch,doctype)values" &
			  "('" & tssInvNo.Text & "','53','" & Format(CDate(dpSIdate.Text), "yyyy-MM-dd") & "'," &
			  "'" & cboCustName.Text.Substring(0, 5) & "','" & admSmnNo & "','" & tssInvNo.Text & "'," &
			  CDbl(IIf(lblTotAmt.Text = "", 0, lblTotAmt.Text)) & "," & CDbl(0) & "," & CDbl(0) & "," &
			  CDbl(IIf(lblTotAmt.Text = "", 0, lblTotAmt.Text)) & ",'" & txtDONo.Text & "'," &
			  "'" & txtRemarks.Text & "','" & strStat & "','" & strStat & "','" & lblUser.Text & "'," &
			  "'" & Format(CDate(Now), "yyyy-MM-dd hh:mm:ss") & "','" & cboPClass.Text.Substring(0, 1) & "'," &
			  CDbl(0) & ",'" & txtRefNo.Text & "','" & strStat & "','" & cboShipTo.Text.Substring(0, 5) & "'," &
			  "'" & vLoggedBranch & "','DR')"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub SaveCheckedBy()
		dt = GetDataTable("select * from signtbl where plntno = '" & admPlntNo & "' and frmname = 'DO' and " &
						  "fullname = '" & cboCheckBy.Text & "' and signtype = 'Checked By'")
		If Not CBool(dt.Rows.Count) Then
			sql = "insert into signtbl(plntno,frmname,fullname,signtype)values('" & admPlntNo & "'," &
				  "'DO','" & cboCheckBy.Text & "','Checked By')"
			ExecuteNonQuery(sql)

		End If

		dt.Dispose()

	End Sub

	Protected Sub SaveRevDet()
		sql = "insert into issdettbl(dono,codeno,qty,wt,itmno,sloc,slocto,mov,smnno,sp,itmamt,lotno) " &
			  "select dono,codeno,qty*-1,wt*-1,itmno,sloc,slocto,'" & cboMovType.Text.Substring(0, 3) & "'," &
			  "smnno,sp,amount*-1,lotno from view_dodet where dono = '" & txtDONo.Text & "' and ttype = 'Post'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub SaveDODetProc()
		dt = GetDataTable("select * from isshdrtbl where dono = '" & Trim(txtDONo.Text) & "' and tc = '" & lblTC.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			Call SaveDOHdr()

		End If

		Call dt.Dispose()

		dt = GetDataTable("select * from issdettbl where dono = '" & Trim(txtDONo.Text) & "'")
		If Not CBool(dt.Rows.Count) Then
			Call SaveDODet()

			'strReport = "save matl item no.: " & txtItm.Text & Space(1) & cboMMdesc.Text
			'Call SaveLogs()
		Else
			SaveDetOldData()

			sql = "delete from issdettbl where dono = '" & Trim(txtDONo.Text) & "'"
			ExecuteNonQuery(sql)

			Call SaveDODet()

			'strReport = "update matl item no.: " & txtItm.Text & Space(1) & cboMMdesc.Text
			'Call SaveLogs()
		End If

		Call dt.Dispose()

		sql = "update issdettbl set mov = '" & cboMovType.Text.Substring(0, 3) & "' where dono = '" & Trim(txtDONo.Text) & "'"
		ExecuteNonQuery(sql)

		UpdateDOhdrQty()


	End Sub

	Protected Sub UpdateDOhdrQty()
		Select Case cboMovType.Text.Substring(0, 3)
			Case "301"
				sql = "delete from tempinvdettbl where user = '" & lblUser.Text & "'"
				ExecuteNonQuery(sql)

				dt = GetDataTable("select codeno,lotno from issdettbl where dono = '" & txtDONo.Text & "' group by codeno,lotno")
				If Not CBool(dt.Rows.Count) Then

				Else
					For Each dr As DataRow In dt.Rows
						sql = "insert into tempinvdettbl(codeno,lotno,qty,wt,itmamt,user) select a.codeno,a.lotno,ifnull(sum(a.qty),0)," &
							  "ifnull(sum(a.wt),0),ifnull(sum(a.itmamt),0),'" & lblUser.Text & "' from invdettbl a left join invhdrtbl b " &
							  "on a.mmrrno=b.mmrrno where b.status <> 'void' and a.codeno = '" & dr.Item(0).ToString() & "' and " &
							  "a.lotno = '" & dr.Item(1).ToString() & "' and ifnull(a.sp,0) <> 0 and " &
							  "b.transdate <= '" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' group by a.codeno,a.lotno"
						ExecuteNonQuery(sql)

					Next

				End If

				dt.Dispose()

				sql = "update tempinvdettbl a,(select codeno,ifnull(cosbillref,'wt') as billref from mmasttbl) as b " &
					  "set a.billref = b.billref where a.codeno = b.codeno and a.user = '" & lblUser.Text & "'"
				ExecuteNonQuery(sql)

				sql = "update tempinvdettbl set sp = ifnull(itmamt,0) / ifnull(wt,0) where user = '" & lblUser.Text & "' and billref = 'wt'"
				ExecuteNonQuery(sql)

				sql = "update tempinvdettbl set sp = ifnull(itmamt,0) / ifnull(qty,0) where user = '" & lblUser.Text & "' and billref = 'qty'"
				ExecuteNonQuery(sql)

				'update unit cost
				sql = "update issdettbl a,(select codeno,lotno,sp,billref from tempinvdettbl where user = '" & lblUser.Text & "') as b " &
					  "set a.uc=b.sp,a.billref=b.billref where a.codeno=b.codeno and a.lotno=b.lotno and a.dono = '" & txtDONo.Text & "'"
				ExecuteNonQuery(sql)

				sql = "update issdettbl set cosamt = ifnull(qty,0) * ifnull(uc,0) where dono = '" & txtDONo.Text & "' and billref = 'qty'"
				ExecuteNonQuery(sql)

				sql = "update issdettbl set cosamt = ifnull(wt,0) * ifnull(uc,0) where dono = '" & txtDONo.Text & "' and billref = 'wt'"
				ExecuteNonQuery(sql)

				'update total qty/wt/amt isshdr
				sql = "update isshdrtbl a,(select ifnull(sum(qty),0) as qty,ifnull(sum(wt),0) as wt,ifnull(sum(cosamt),0) as amt " &
					  "from issdettbl where dono = '" & txtDONo.Text & "' group by dono) as b set a.totqty = b.qty,a.totwt = b.wt," &
					  "a.totcost = b.amt where a.dono = '" & txtDONo.Text & "'"
				ExecuteNonQuery(sql)

			Case Else
				dt = GetDataTable("select ifnull(sum(qty),0),ifnull(sum(wt),0) from issdettbl where " &
						  "dono = '" & txtDONo.Text & "' group by dono")
				If Not CBool(dt.Rows.Count) Then Exit Sub

				For Each dr As DataRow In dt.Rows
					sql = "update isshdrtbl set totqty = " & CLng(dr.Item(0).ToString()) & "," &
						  "totwt= " & CDbl(dr.Item(1).ToString()) & " where dono = '" & txtDONo.Text & "'"
					ExecuteNonQuery(sql)

				Next

				Call dt.Dispose()

		End Select



	End Sub

	Protected Sub SaveDetOldData()
		sql = "insert into issdettbl_update(dono,codeno,qty,wt,itmno,sloc,slocto,mov,smnno,sp,itmamt,lotno,adddesc,billref,updateid) " &
			  "select dono,codeno,qty,wt,itmno,sloc,slocto,mov,smnno,sp,itmamt,lotno,adddesc,billref,'" & admUpdateNo & "' from " &
			  "issdettbl where dono = '" & txtDONo.Text & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub SaveDODet()
		'For i As Integer = 0 To lvDOdet.Items.Count - 1
		Select Case cboMovType.Text.Substring(0, 3)
			Case "201"
				sql = "insert into issdettbl(dono,codeno,qty,wt,itmno,sloc,slocto,mov,sp,itmamt,lotno,adddesc) " &
					  "select '" & txtDONo.Text & "',codeno,qty,wt,itmno,sloc,slocto,'" & cboMovType.Text.Substring(0, 3) & "'," &
					  "sp,itmamt,lotno,adddesc from tempissdettbl where user = '" & lblUser.Text & "'"
				ExecuteNonQuery(sql)

			Case "301"
				sql = "insert into issdettbl(dono,codeno,qty,wt,itmno,sloc,slocto,mov,sp,itmamt,lotno,billref) " &
					  "select '" & txtDONo.Text & "',codeno,qty,wt,itmno,sloc,slocto,'" & cboMovType.Text.Substring(0, 3) & "'," &
					  "sp,itmamt,lotno,billref from tempissdettbl where user = '" & lblUser.Text & "'"
				ExecuteNonQuery(sql)

			Case "501"
					'no details to insert

			Case "601", "613"
				sql = "insert into issdettbl(dono,codeno,qty,wt,itmno,sloc,slocto,mov,smnno,sp,itmamt,lotno,adddesc,billref,stat) " &
					  "select '" & txtDONo.Text & "',codeno,qty,wt,itmno,sloc,slocto,'" & cboMovType.Text.Substring(0, 3) & "'," &
					  "'" & cboSmnName.Text.Substring(0, 3) & "',sp,itmamt,lotno,adddesc,billref,status " &
					  "from tempissdettbl where user = '" & lblUser.Text & "' and lotno is not null"
				ExecuteNonQuery(sql)

				AddMMtoCust()

			Case Else
				sql = "insert into issdettbl(dono,codeno,qty,wt,itmno,sloc,slocto,mov,smnno,sp,itmamt,lotno,adddesc) " &
					  "select '" & txtDONo.Text & "',codeno,qty,wt,itmno,sloc,slocto,'" & cboMovType.Text.Substring(0, 3) & "'," &
					  "smnno,sp,itmamt,lotno,adddesc from tempissdettbl where user = '" & lblUser.Text & "' and " &
					  "lotno Is Not null"
				ExecuteNonQuery(sql)

				AddMMtoCust()

		End Select

		'Next

		If cboMovType.Text.Substring(0, 3) = "201" Then
			SaveWIPdetProc()

		End If

		If txtSONo.Text <> "" Then
			Select Case cboMovType.Text.Substring(0, 3)
				Case "201"
					sql = "update invhdrtbl set status = 'close',dsrno = '" & txtDONo.Text & "' where mmrrno = '" & txtSONo.Text & "'"
					ExecuteNonQuery(sql)

				Case "601"
					'SaveDetProc() 'update SO
					GetSOItemBalsClosing()
					Dim SOBal As Double

					dt = GetDataTable("select ifnull(sum(qtbal),0) from sodettbl where sono = '" & txtSONo.Text & "' group by sono")
					If Not CBool(dt.Rows.Count) Then
						AdmMsgBox("SO No.:" & txtSONo.Text & " Not found")
						Exit Sub

					Else
						For Each dr As DataRow In dt.Rows
							SOBal = CLng(dr.Item(0).ToString())
							Select Case SOBal
								Case Is < 1
									dt2 = GetDataTable("select ifnull(sum(wtbal),0) from sodettbl where sono = '" & txtSONo.Text & "' group by sono")
									If Not CBool(dt2.Rows.Count) Then

									Else
										For Each dr2 As DataRow In dt2.Rows
											SOBal = CLng(dr2.Item(0).ToString())
											Select Case SOBal
												Case Is < 1
													strStat = "Served"
												Case Is > 0
													strStat = "DR Saved"

											End Select
										Next

									End If

									dt2.Dispose()

								Case Is > 0
									strStat = "DR Saved"

							End Select

						Next

					End If

					sql = "update sohdrtbl set delstat = '" & strStat & "' where sono = '" & txtSONo.Text & "'"
					ExecuteNonQuery(sql)

					dt.Dispose()

			End Select

		End If

	End Sub

	Protected Sub GetSOItemBalsClosing()
		sql = "update sodettbl set issqty = 0,isswt = 0,issby = null,issdate=null where sono = '" & txtSONo.Text & "'"
		ExecuteNonQuery(sql)

		sql = "update sodettbl a,(select a.codeno,ifnull(sum(a.qty),0) as qty,ifnull(sum(a.wt),0) as wt from issdettbl a " &
			  "left join isshdrtbl b on a.dono=b.dono where b.sono = '" & txtSONo.Text & "' and b.status <> 'void' " &
			  "group by a.codeno) as b set a.issqty = b.qty,a.isswt = b.wt,a.issby = '" & lblUser.Text & "'," &
			  "a.issdate = '" & Format(CDate(Now()), "yyyy-MM-dd HH:mm:ss") & "' where a.sono = '" & txtSONo.Text & "' " &
			  "and a.codeno=b.codeno"
		ExecuteNonQuery(sql)

		sql = "update sodettbl set qtbal = qty - ifnull(issqty,0),wtbal = wt - ifnull(isswt,0) where sono = '" & txtSONo.Text & "'"
		ExecuteNonQuery(sql)

	End Sub

	Protected Sub SaveWIPdetProc()
		dt = GetDataTable("select * from wipdettbl where wipno = '" & txtRefNo.Text & "' and tc = '20' " &
							  "and dono = '" & txtDONo.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			Call SaveWIPdet()

		Else
			sql = "delete from wipdettbl where wipno = '" & txtRefNo.Text & "' and tc = '20' and dono = '" & txtDONo.Text & "'"
			ExecuteNonQuery(sql)

			Call SaveWIPdet()

		End If

	End Sub

	Protected Sub SaveWIPdet()
		sql = "insert into wipdettbl(wipno,dono,transdate,lotno,itmno,codeno,source,wt,stduc,stdcosamt,status," &
			  "dprno,datepost,plntno,tc,fgtype,user,um,remarks,qty) select '" & txtRefNo.Text & "','" & txtDONo.Text & "'," &
			  "'" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "',lotno,itmno,codeno,'',wt,sp,itmamt,'open'," &
			  "'" & txtRefNo.Text & "','" & Format(CDate(Now), "yyyy-MM-dd HH:mm:ss") & "','" & admPlntNo & "'," &
			  "'20','Matl Input','" & lblUser.Text & "',um,'Manual Entry',qty from tempissdettbl where " &
			  "user = '" & lblUser.Text & "' and lotno is not null"

		sql = "delete from tempdodet where user = '" & lblUser.Text & "'"
		ExecuteNonQuery(sql)

		dt = GetDataTable("select codeno,lotno from issdettbl where dono = '" & txtDONo.Text & "' group by codeno,lotno")
		If Not CBool(dt.Rows.Count) Then
			Exit Sub
		Else
			For Each dr As DataRow In dt.Rows

			Next

		End If

		dt.Dispose()

	End Sub

	Protected Sub AddMMtoCust()
		dt = GetDataTable("select codeno from issdettbl where dono = '" & txtDONo.Text & "' group by codeno")
		If Not CBool(dt.Rows.Count) Then
			Exit Sub
		Else
			For Each dr As DataRow In dt.Rows
				admCodeNo = dr.Item(0).ToString()

				AddMatl()

			Next

		End If

		dt.Dispose()

	End Sub

	Protected Sub AddMatl()
		dt = GetDataTable("select * from custmmtbl where custno = '" & cboCustName.Text.Substring(0, 5) & "' " &
						  "and codeno = '" & admCodeNo & "'")
		If Not CBool(dt.Rows.Count) Then
			sql = "insert into custmmtbl(custno,codeno,user,dateupdate)values" &
				  "('" & cboCustName.Text.Substring(0, 5) & "','" & admCodeNo & "','" & lblUser.Text & "'," &
				  "'" & Format(CDate(Now), "yyyy-MM-dd hh:mm:ss") & "')"
			ExecuteNonQuery(sql)

		End If

	End Sub

	Protected Sub ExecProcBtn()
		'get plant
		dt = GetDataTable("select concat(a.plntno,space(1),b.plntname) from isshdrtbl a left join plnttbl b on a.plntno=b.plntno " &
						  "where a.dono = '" & txtDONo.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			Exit Sub
		Else
			For Each dr As DataRow In dt.Rows

				cboPlnt.Text = dr.Item(0).ToString()

			Next
		End If

		dt.Dispose()

		dt = GetDataTable("select a.status,a.salesdoc,a.dsrno,a.dsrstat,concat(ifnull(a.pc,c.pc),space(1),b.pclass) from isshdrtbl a " &
						  "left join plnttbl c on a.plntno=c.plntno  left join pctrtbl b on ifnull(a.pc,c.pc)=b.pc where " &
						  "a.dono = '" & txtDONo.Text & "'")
		If Not CBool(dt.Rows.Count) Then  'include
			tssErrorMsg.Text = "DO No.:" & txtDONo.Text & " Not found"
			Call clrFields()
			Call ClrLines()
			Exit Sub

		Else
			For Each dr As DataRow In dt.Rows
				cboPClass.Items.Add(dr.Item(4).ToString())
				cboPClass.Text = dr.Item(4).ToString()

				Select Case UCase(dr.Item(0).ToString())
					Case "CLOSE"
						AdmMsgBox("DO No.:" & txtDONo.Text & Space(1) & " Already " & dr.Item(0).ToString())
						txtDONo.Text = ""
						txtDONo.Focus()
						tsSaveStat.Text = "SAVED"
						Call clrFields()
						Exit Sub

					Case "VOID"
						lbSave.Enabled = False
						AdmMsgBox("DO No.:" & txtDONo.Text & Space(1) & " Already " & dr.Item(0).ToString())
						Call LoadOpenDO()

					Case Else
						Select Case UCase(dr.Item(3).ToString())
							Case "SERVED"
								lbSave.Enabled = False
								lbDelete.Enabled = False
								tsSaveStat.Text = "SAVED"

							Case "OPEN"
								tssDocStat.Text = "EDIT"
								tsSaveStat.Text = "SAVED"

						End Select

						tsDocNoEdit.Text = txtDONo.Text
						tssDSRstat.Text = dr.Item(3).ToString() & ""
						'AdmMsgBox("DO No.:" & txtDONo.Text & Space(1) & " Already Served to:" & dr.Item(1).ToString() & "" & Space(1) & dr.Item(2).ToString() & "")

						Call LoadOpenDO()

				End Select

				btnUpdate.Visible = True

				txtDONo.ReadOnly = True
				'btnOpenSO.Enabled = False

			Next

		End If

		Call dt.Dispose()

	End Sub

	Private Sub LoadOpenDO()
		Select Case vLoggedBussArea
			Case "8100", "8200"
				'dt = GetDataTable("select")
				'If Not CBool(dt.Rows.Count) Then Call MessageBox.Show("Not found.", "Delivery Order", MessageBoxButtons.OK, MessageBoxIcon.Warning) : Exit Sub


			Case "8200"

		End Select

		'cboMovType.DropDownStyle = ComboBoxStyle.DropDown

		dt = GetDataTable("select a.transdate,concat(a.smnno,space(1),b.fullname),concat(a.plntno,space(1),c.plntname)," &
						  "concat(a.mov,space(1),d.movdesc),concat(a.custno,space(1),e.bussname),concat(a.shipto,space(1),f.bussname)," &
						  "a.sono,a.refdoc,a.pono,a.driver,a.plateno,a.remarks,a.checkedby,ifnull(a.nosi,'No')," &
						  "ifnull(f.drbiropt,'No BIR') from isshdrtbl a left join smnmtbl b on a.smnno=b.smnno " &
						  "left join plnttbl c on a.plntno=c.plntno left join movtbl d on a.mov=d.mov left join custmasttbl e on a.custno=e.custno " &
						  "left join custmasttbl f on a.shipto=f.custno where a.dono = '" & txtDONo.Text & "' group by a.dono")
		If Not CBool(dt.Rows.Count) Then
			AdmMsgBox("Not found.")
			Exit Sub
		Else
			For Each dr As DataRow In dt.Rows
				dpTransDate.Text = Format(CDate(dr.Item(0).ToString()), "yyyy-MM-dd")
				admDOdate = dr.Item(0).ToString()
				cboSmnName.Items.Add(dr.Item(1).ToString() & "")
				cboSmnName.Text = dr.Item(1).ToString() & ""
				cboPlnt.Text = dr.Item(2).ToString() & ""
				cboMovType.Items.Add(dr.Item(3).ToString() & "")
				cboMovType.Text = dr.Item(3).ToString() & ""
				cboCustName.Items.Add(dr.Item(4).ToString() & "")
				cboCustName.Text = dr.Item(4).ToString() & ""
				cboShipTo.Items.Add(dr.Item(5).ToString() & "")
				cboShipTo.Text = dr.Item(5).ToString() & ""
				txtSONo.Text = dr.Item(6).ToString() & ""
				txtRefNo.Text = dr.Item(7).ToString() & ""
				txtPOno.Text = dr.Item(8).ToString() & ""
				txtDriver.Text = dr.Item(9).ToString() & ""
				txtPlNo.Text = dr.Item(10).ToString() & ""
				txtRemarks.Text = dr.Item(11).ToString() & ""
				cboCheckBy.Text = dr.Item(12).ToString() & ""


				tssDRprtOpt.Text = dr.Item(14).ToString() & ""

			Next

		End If

		dt.Dispose()

		'insert plant 2 for mov 301
		Select Case cboMovType.Text.Substring(0, 3)
			Case "301"
				cboPlnt2.Enabled = True
				dt = GetDataTable("select concat(a.plntdest,space(1),b.plntname) from isshdrtbl a " &
								  "left join plnttbl b on a.plntdest=b.plntno where a.dono = '" & txtDONo.Text & "'")
				If Not CBool(dt.Rows.Count) Then
					tssErrorMsg.Text = "Not found."
				Else
					For Each dr As DataRow In dt.Rows
						cboPlnt2.Items.Add(dr.Item(0).ToString())
						cboPlnt2.Text = dr.Item(0).ToString()
					Next
				End If

				dt.Dispose()

			Case Else
				cboPlnt2.Enabled = False

		End Select



		FillDOdetData()
		FillLvSOdet()

		dt = GetDataTable("select user from doclocktbl where docno = '" & txtDONo.Text & "' and user <> '" & lblUser.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			strStat = "EDIT"
			LogMeIn()
		Else
			For Each dr As DataRow In dt.Rows
				AdmMsgBox("DO No. " & txtDONo.Text & " is currently open by: " & dr.Item(0).ToString() & ", try again later")
				lbSave.Enabled = False
				lbDelete.Enabled = False
				btnAdd.Enabled = False
				btnDel.Enabled = False
			Next
		End If

		'PeriodCheck()

	End Sub

	Protected Sub FillDOdetData()
		sql = "delete from tempissdettbl where user = '" & lblUser.Text & "'"
		ExecuteNonQuery(sql)

		sql = "insert into tempissdettbl(itmno,codeno,qty,wt,sp,itmamt,sloc,lotno,adddesc,um,billref,user) " &
			  "select itmno,codeno,qty,wt,sp,itmamt,sloc,lotno,adddesc,um,billref,'" & lblUser.Text & "' " &
			  "from issdettbl where dono = '" & txtDONo.Text & "' order by itmno"
		ExecuteNonQuery(sql)

	End Sub

	'Private Sub lbReLoadDoc_Click(sender As Object, e As EventArgs) Handles lbReLoadDoc.Click
	'	If txtDONo.Text = "" Or txtDONo.Text = Nothing Then
	'		Exit Sub
	'	End If

	'	ExecProcBtn()

	'End Sub

	Protected Sub DgvDOsumList_RowDataBound(sender As Object, e As GridViewRowEventArgs)

	End Sub

	Protected Sub DgvDOsumList_RowCreated(sender As Object, e As GridViewRowEventArgs)

	End Sub

	Protected Sub FillDOsumList()
		Dim adapter As New MySqlDataAdapter
		Dim ds As New DataSet()
		Dim i As Integer = 0
		sqldata = Nothing

		Select Case cboDOstatus.Text
			Case "ALL"
				sqldata = "select a.dono,a.transdate,concat(a.custno,space(1),b.bussname) as custno,concat(a.mov,space(1),c.movdesc) as mov," &
						  "concat(a.plntno,space(1),d.plntname) as plntno,ucase(a.status) as status,ucase(a.dsrstat) as dsrstat from " &
						  "isshdrtbl a left join custmasttbl b on a.custno=b.custno left join movtbl c on a.mov=c.mov left join plnttbl d " &
						  "on a.plntno=d.plntno where a.transdate between '" & Format(CDate(dpDateFrT3.Text), "yyyy-MM-dd") & "' and " &
						  "'" & Format(CDate(dpDateToT3.Text), "yyyy-MM-dd") & "' and a.mfgdate is null order by a.transdate desc,a.dono"
			Case Else
				sqldata = "select a.dono,a.transdate,concat(a.custno,space(1),b.bussname) as custno,concat(a.mov,space(1),c.movdesc) as mov," &
						  "concat(a.plntno,space(1),d.plntname) as plntno,ucase(a.status) as status,ucase(a.dsrstat) as dsrstat from " &
						  "isshdrtbl a left join custmasttbl b on a.custno=b.custno left join movtbl c on a.mov=c.mov left join plnttbl d " &
						  "on a.plntno=d.plntno where a.transdate between '" & Format(CDate(dpDateFrT3.Text), "yyyy-MM-dd") & "' and " &
						  "'" & Format(CDate(dpDateToT3.Text), "yyyy-MM-dd") & "' and a.dsrstat = '" & cboDOstatus.Text & "' " &
						  "and a.mfgdate is null order by a.transdate desc,a.dono"
		End Select

		conn.Open()
		Dim command As New MySqlCommand(sqldata, conn)
		adapter.SelectCommand = command
		adapter.Fill(ds)
		adapter.Dispose()
		command.Dispose()
		conn.Close()
		DgvDOsumList.DataSource = ds.Tables(0)
		DgvDOsumList.DataBind()

	End Sub

	Private Sub dpDateFrT3_TextChanged(sender As Object, e As EventArgs) Handles dpDateFrT3.TextChanged, dpDateToT3.TextChanged
		If dpDateFrT3.Text = Nothing Then
			Exit Sub
		ElseIf dpDateToT3.Text = Nothing Then
			Exit Sub
		End If

		If CDate(dpDateToT3.Text) < CDate(dpDateFrT3.Text) Then
			Exit Sub
		End If

		PopDOstatusList()

	End Sub

	Protected Sub PopDOstatusList()
		cboDOstatus.Items.Clear()
		dt = GetDataTable("select ucase(dsrstat) from isshdrtbl where transdate between '" & Format(CDate(dpDateFrT3.Text), "yyyy-MM-dd") & "' " &
						  "and '" & Format(CDate(dpDateToT3.Text), "yyyy-MM-dd") & "' group by dsrstat")
		If Not CBool(dt.Rows.Count) Then
			tssErrorMsg.Text = "Not found."
		Else
			cboDOstatus.Items.Add("ALL")
			For Each dr As DataRow In dt.Rows
				cboDOstatus.Items.Add(dr.Item(0).ToString())

			Next

		End If

		dt.Dispose()

	End Sub

	Private Sub cboDOstatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboDOstatus.SelectedIndexChanged

		FillDOsumList()

	End Sub

	Private Sub lbDOstatus_Click(sender As Object, e As EventArgs) Handles lbDOstatus.Click
		If dpDateFrT3.Text = Nothing Then
			Exit Sub
		ElseIf dpDateToT3.Text = Nothing Then
			Exit Sub
		End If

		If CDate(dpDateToT3.Text) < CDate(dpDateFrT3.Text) Then
			Exit Sub
		ElseIf cboDOstatus.Text = Nothing Or cboDOstatus.Text = "" Then
			Exit Sub
		End If

		FillDOsumList()

	End Sub

	Private Sub DgvDOsumList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles DgvDOsumList.SelectedIndexChanged
		txtDONo.Text = DgvDOsumList.SelectedRow.Cells(1).Text
		ExecProcBtn()
		TabContainer1.ActiveTabIndex = 0

	End Sub

	Private Sub VoidProcNew()

		dt = GetDataTable("select dsrno from isshdrtbl where dono = '" & txtDONo.Text & "'")
		If Not CBool(dt.Rows.Count) Then
			MsgBox("DO No. " & txtDONo.Text & " not found or not belong to " & vLoggedBranch)
			Exit Sub

		Else
			For Each dr As DataRow In dt.Rows
				Select Case UCase(dr.Item(0).ToString())
					Case "00000"
						If CDate(dpTransDate.Text) < vTransMon Then
							AdmMsgBox(Format(CDate(dpTransDate.Text), "MMM yyyy") & " is Already CLOSED")
							Exit Sub
						End If
						'create function
						'Answer = MessageBox.Show("Are you sure to VOID DO No.: " & txtDONo.Text, "DO Void Procedure", MessageBoxButtons.YesNo)
						'If Answer = vbYes Then

						admUpdateNo = Format(CDate(Now()), "yyMMddHHmmss")
							admStatType = "Void"
							SaveDOhdrOldData()
							SaveDetOldData()

							Select Case cboMovType.Text.Substring(0, 3)
								Case "201"
									'check costing
									If CDate(dpTransDate.Text) < vTransMon Then
										AdmMsgBox(Format(CDate(dpTransDate.Text), "MMM yyyy") & " is Already CLOSED")
										Exit Sub
									Else
										dt = GetDataTable("select * from gljvhdrtbl where sourcedoc = 'Sales' and " &
														  "'" & Format(CDate(dpTransDate.Text), "yyyy-MM-dd") & "' " &
														  "between dfrom and dto")
										If Not CBool(dt.Rows.Count) Then
											sql = "update isshdrtbl set status = 'void',dsrno = '00000' " &
												  "where dono = '" & txtDONo.Text & "' and branch = '" & vLoggedBranch & "'"
											ExecuteNonQuery(sql)
										Else
											AdmMsgBox("Sales GL Transaction already Processed")
											Exit Sub

										End If

									End If

									dt.Dispose()

									sql = "update isshdrtbl set status = 'void',dsrno = '00000' " &
										  "where dono = '" & txtDONo.Text & "' and branch = '" & vLoggedBranch & "'"
									ExecuteNonQuery(sql)

									sql = "update invhdrtbl set status = 'open',dsrno = null where " &
										  "mmrrno = '" & txtSONo.Text & "'"
									ExecuteNonQuery(sql)

								Case "501"
									sql = "update isshdrtbl set status = 'void',dsrno = '00000' where dono = '" & txtDONo.Text & "'"
									ExecuteNonQuery(sql)

									sql = "update issscrphdrtbl set status = 'void' where dono = '" & txtDONo.Text & "'"
									ExecuteNonQuery(sql)

								Case "601"
									sql = "update sohdrtbl set delstat = 'open' where sono = '" & txtSONo.Text & "'"
									ExecuteNonQuery(sql)

							Case Else
									sql = "update isshdrtbl set status = 'void',dsrno = '00000' " &
										  "where dono = '" & txtDONo.Text & "' and branch = '" & vLoggedBranch & "'"
									ExecuteNonQuery(sql)

							End Select

							strReport = "DO VOID"
							Call SaveLogs()

							AdmMsgBox("DO No. " & txtDONo.Text & " VOID")
						'ToolStripMenuItem1.PerformClick()

						'Else
						'	AdmMsgBox("Void Aborted")
						'	Exit Sub

						'End If

					Case Else
						Select Case cboMovType.Text.Substring(0, 3)
							Case "201"
								MsgBox("Void Not Possible, Production Worksheet No.: " & dr.Item(0).ToString() & " already Found")
							Case "601"
								MsgBox("Void Not Possible, SI already Issued")
							Case Else
								MsgBox("Void Not Possible")
						End Select

						Exit Sub

				End Select

			Next

		End If

		Call dt.Dispose()

	End Sub

	Private Sub txtDONo_TextChanged(sender As Object, e As EventArgs) Handles txtDONo.TextChanged
		If txtDONo.Text = "" Or txtDONo.Text = Nothing Then
			Exit Sub
		End If

		ExecProcBtn()

	End Sub

	Private Sub txtSONo_TextChanged(sender As Object, e As EventArgs) Handles txtSONo.TextChanged
		If txtSONo.Text <> "" Then
			Select Case cboMovType.Text.Substring(0, 3)
				Case "121"
						'dt = GetDataTable("select delstat from sohdrtbl where sono = '" & txtSONo.Text & "' and delstat = '" & "served" & "'")

				Case "601", "611"
					dt = GetDataTable("select delstat,status from sohdrtbl where sono = '" & txtSONo.Text & "'")
					If Not CBool(dt.Rows.Count) Then
						Exit Sub

					Else
						For Each dr As DataRow In dt.Rows
							Select Case UCase(dr.Item(1).ToString())
								Case "APPROVED"
									GetSOdetAll()
								Case Else
									AdmMsgBox("SO No. " & txtSONo.Text & " / Status: " & dr.Item(1).ToString())
									Exit Sub
							End Select

						Next

					End If

					Call dt.Dispose()

					'txtDONo.Focus()

			End Select

		End If
	End Sub

	Private Sub txtRefNo_TextChanged(sender As Object, e As EventArgs) Handles txtRefNo.TextChanged
		If txtRefNo.Text <> "" Then
			dt = GetDataTable("select dono from isshdrtbl where refdoc = '" & txtRefNo.Text & "' " &
							  "and status <> 'void' and dono <> '" & txtDONo.Text & "'")
			If Not CBool(dt.Rows.Count) Then
				Exit Sub

			Else
				For Each dr As DataRow In dt.Rows
					tssErrorMsg.Text = "DO No.:" & txtRefNo.Text & " already used in AOS Doc. No.:" & dr.Item(0).ToString()
					txtRefNo.Text = ""
					Exit Sub

				Next

			End If

			Call dt.Dispose()

			tssErrorMsg.Text = ""

			If dpTransDate.Text = Nothing Then
				tssErrorMsg.Text = "Date Not Yet Set"
				Exit Sub
			End If

			Call PopMMdesc()



		Else
			dt = GetDataTable("select dono from isshdrtbl where refdoc = '" & txtRefNo.Text & "' " &
							  "and status <> 'void'")
			If Not CBool(dt.Rows.Count) Then
				Exit Sub
			Else
				For Each dr As DataRow In dt.Rows
					tssErrorMsg.Text = "DO No.:" & txtRefNo.Text & " already used in AOS Doc. No.:" & dr.Item(0).ToString()
					txtRefNo.Text = ""
					Exit Sub

				Next
			End If

			Call dt.Dispose()

		End If

	End Sub

	Private Sub txtQty_TextChanged(sender As Object, e As EventArgs) Handles txtQty.TextChanged
		Dim wtpk As Double
		Dim Qty As Long = CLng(IIf(txtQty.Text = "", 0, txtQty.Text))
		txtQty.Text = Format(Qty, "##,##0")
		Select Case vLoggedBussArea
			Case "8300"
				Select Case cboMovType.Text.Substring(0, 3)
					Case "601"
						wtpk = Qty * CDbl(IIf(lblQtPk.Text = "", 0, lblQtPk.Text))
						txtWt.Text = Format(wtpk, "#,##0.00")
				End Select

		End Select

		Select Case cboMovType.Text.Substring(0, 3)
			Case "201"

			Case Else
				wtpk = Qty * CDbl(IIf(lblQtPk.Text = "", 0, lblQtPk.Text))
				txtWt.Text = Format(wtpk, "#,##0.00")

		End Select

		txtWt.Focus()

	End Sub

	Private Sub txtWt_TextChanged(sender As Object, e As EventArgs) Handles txtWt.TextChanged
		If cboLotNo.Text = "" Then
			tssErrorMsg.Text = "Select Lot No."
			Exit Sub
		End If

		Dim Wt As Double = CDbl(IIf(txtWt.Text = "", 0, txtWt.Text))
		Select Case cboAdmDig.Text
			Case "2"
				txtWt.Text = Format(Wt, "##,##0.00")
			Case "3"
				txtWt.Text = Format(Wt, "##,##0.000")
			Case "4"
				txtWt.Text = Format(Wt, "##,##0.0000")
			Case "5"
				txtWt.Text = Format(Wt, "##,##0.00000")
			Case "6"
				txtWt.Text = Format(Wt, "##,##0.000000")
		End Select

		Dim Amt As Double
		Select Case UCase(lblBillRef.Text)
			Case "WT"
				Amt = CDbl(IIf(txtWt.Text = "", 0, txtWt.Text)) * CDbl(IIf(txtSP.Text = "", 0, txtSP.Text))

			Case "QTY"
				Amt = CDbl(IIf(txtQty.Text = "", 0, txtQty.Text)) * CDbl(IIf(txtSP.Text = "", 0, txtSP.Text))

		End Select

		lblAmt.Text = Format(Amt, "#,##0.00")

		If Wt > BalWt Then
			'MsgBox("Insufficient Wt available")
			'Exit Sub
			'txtWt.Text = Format(BalWt, "##,##0.000")


		End If

		'cmdAddItm.Focus()
		txtSP.Focus()

	End Sub

	Private Sub txtSP_TextChanged(sender As Object, e As EventArgs) Handles txtSP.TextChanged
		SP = CDbl(IIf(txtSP.Text = "", 0, txtSP.Text))
		txtSP.Text = Format(SP, "#,##0.0000")

		Select Case UCase(lblBillRef.Text)
			Case "WT"
				Amt = CDbl(txtWt.Text) * CDbl(txtSP.Text)
				lblAmt.Text = Format(Amt, "#,##0.00")

			Case "QTY"
				Amt = CDbl(txtQty.Text) * CDbl(txtSP.Text)
				lblAmt.Text = Format(Amt, "#,##0.00")

				'Case Else
				'    Dim Amt As Double = CDbl(txtQty.Text) * CDbl(txtSP.Text)
				'    lblAmt.Text = Format(Amt, "#,##0.00")

		End Select

		'insert item max check
		If txtItm.Text > 10 Then
			Select Case cboMovType.Text.Substring(0, 3)
				Case "601"
					tssErrorMsg.Text = "Order cannot be accept more 10 items, please make sepate SO"
					Exit Sub

			End Select

		End If

		cboSLoc.Focus()
	End Sub

	Private Sub cboSmnName_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboSmnName.SelectedIndexChanged
		If cboSmnName.Text = "" Then
			Exit Sub
		ElseIf cboMovType.Text = "" Then
			Exit Sub
		End If

		Select Case cboMovType.Text.Substring(0, 3)
			Case "601", "613"
				PopOpenSOlview()
		End Select

	End Sub

	'Protected Sub lbNew_Click(sender As Object, e As EventArgs)
	'	Dim confirmValue As String = Request.Form("confirm_value")
	'	If confirmValue = "Yes" Then
	'		tssErrorMsg.Text = "Test"
	'		'StartNewDoc()

	'	Else
	'		AdmMsgBox("Action Aborted")

	'	End If
	'End Sub


End Class