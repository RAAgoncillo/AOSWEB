Option Explicit On
Imports MySql.Data.MySqlClient

Public Class DailySalesReport
    Inherits System.Web.UI.Page
    Dim strReport As String
    Dim sql As String
    Dim dt As DataTable
    Dim dt2 As DataTable
    Dim sortColumn As Integer = -1
    Dim MyDA_conn As New MySqlDataAdapter
    Dim MyDataSet As New DataSet
    Dim MySqlScript As String
    Dim strTC As String
    Dim strUnit As String
    Dim Answer As String
    Dim vDateIndex As Integer
    Dim strAMsckDSR As String
    Dim admMMdesc As String
    Dim admAmt As Double
    Dim sqldata As String
    Dim Qty As Long
    Dim Wt As Double

    Protected Sub AdmMsgBox(ByVal sMessage As String)
        Dim msg As String
        msg = "<script language='javascript'>"
        msg += "alert('" & sMessage & "');"
        msg += "<" & "/script>"
        Response.Write(msg)

    End Sub

    Private Sub SaveLogs()

        Dim strForm As String = "DSR"
        sql = "insert into translog(trans,form,datetimelog,user,docno,tc)values" &
              "('" & strReport & "','" & strForm & "','" & Format(CDate(Now), "yyyy-MM-dd hh:mm:ss") & "'," &
              "'" & lblUser.Text & "','" & txtDSRNo.Text & "','" & "dsr" & "')"
        ExecuteNonQuery(sql)

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If lblUser.Text = Nothing Then
            Response.Redirect("login.aspx")

        End If

        If Not Me.IsPostBack Then
            lblUser.Text = Session("UserID")
            lblGrpUser.Text = Session("UserGrp")

            vThisFormCode = "046"
            Call CheckGroupRights()

            vJVsource = "Sales"

            txtDSRNo.ReadOnly = False

            cboStat.Items.Clear()
            cboStat.Items.Add("")
            cboStat.Items.Add("OPEN")
            cboStat.Items.Add("COMPLETED")

            cboShrUnit.Items.Clear()
            cboShrUnit.Items.Add("")
            Select Case vLoggedBussArea
                Case "8100", "8200"
                    cboShrUnit.Items.Add("Heads")
                    cboShrUnit.Items.Add("Kilos")
                    'Label9.Text = "Salesman:"

                Case Else
                    cboShrUnit.Items.Add("Packs")
                    cboShrUnit.Items.Add("Pcs")
                    'Label9.Text = "Salesman:"

            End Select

            cboStatAll.Items.Clear()
            cboStatAll.Items.Add("")
            cboStatAll.Items.Add("ALL")
            cboStatAll.Items.Add("OPEN")
            cboStatAll.Items.Add("COMPLETED")

            cboInv.Items.Clear()
            cboInv.Items.Add("")
            cboInv.Items.Add("84 ETCSI")
            cboInv.Items.Add("85 ETCI")

            popPC()

            cboSmnName.Items.Clear()
            dt = GetDataTable("select concat(smnno,space(1),fullname) from smnmtbl where status = 'active' order by fullname")
            If Not CBool(dt.Rows.Count) Then
                Exit Sub

            Else
                cboSmnName.Items.Add("")
                For Each dr As DataRow In dt.Rows
                    cboSmnName.Items.Add(dr.Item(0).ToString())

                Next
            End If

            Call dt.Dispose()

        End If

    End Sub

    Private Sub popPC()

        cboPC.Items.Clear()

        dt = GetDataTable("select pclass from pctrtbl where stat = 'Active' and tradetype = 'trade' and dsr = 'yes'")
        If Not CBool(dt.Rows.Count) Then
            Exit Sub

        Else
            For Each dr As DataRow In dt.Rows
                cboPC.Items.Add(dr.Item(0).ToString())

            Next

        End If

        dt.Dispose()

    End Sub

    Protected Sub OnConfirm2(sender As Object, e As EventArgs)
        Dim confirmValue As String = Request.Form("confirm_value")
        If confirmValue = "Yes" Then
            'RemoveLineItem()
        Else
            'lblErrMsg.Text = "Delete Cancelled"
        End If

    End Sub

    Private Sub CheckGroupRights()
        If IsAllowed(vLoggedUserGroupID, vThisFormCode, 3) = True Then ' 3 = Insert 
            cmdAddDO.Enabled = True
            'cmdAddSI.Enabled = True
            lbSave.Enabled = True
            Button3.Enabled = True
            'cmdAddItm.Enabled = True 'temp comment
            'ToolStripMenuItem2.Enabled = True

        Else
            cmdAddDO.Enabled = False
            'cmdAddSI.Enabled = False
            lbSave.Enabled = False
            Button3.Enabled = False
            'cmdAddItm.Enabled = False


        End If


        'If IsAllowed(vLoggedUserGroupID, vThisFormCode, 5) = True Then ' 5 post
        '    txtDSRamReload.ReadOnly = False
        '    btnAMreload.Enabled = True

        'Else
        '    txtDSRamReload.ReadOnly = True
        '    btnAMreload.Enabled = False

        'End If


        'If IsAllowed(vLoggedUserGroupID, vThisFormCode, 4) = True Then ' 4 = Delete
        '    VoidToolStripMenuItem.Enabled = True
        '    cmdRemDO.Enabled = True
        '    Button1.Enabled = True
        '    cmdDetItm.Enabled = True
        '    VoidToolStripMenuItem.Enabled = True

        'Else
        '    VoidToolStripMenuItem.Enabled = False
        '    cmdRemDO.Enabled = False
        '    Button1.Enabled = False
        '    cmdDetItm.Enabled = False
        '    VoidToolStripMenuItem.Enabled = False

        'End If


    End Sub

    Private Sub LoadExistingDSR()

        Call RRsalesAmt()
        Call popDONo()
        Call popWRRNo()
        Call fillWRRsum()
        Call ListDOsmn()
        Call FillLvPMstk()
        Call getMMstocks()
        Call UpdateStocks()
        Call ChkStockAvail()
        Call CalcRR()

        vLastAct = "DSR" & " Reload DSR No." & txtDSRNo.Text & Space(1) & cboSmnName.Text.Substring(0, 3)
        WriteToLogs(vLastAct)

    End Sub

    Private Sub CalcRR()
        Try

            If txtDSRNo.Text = "" Then
                'txtDSRNo.Focus()
                MsgBox("DSR No. is Blank")

                Exit Sub

            Else

                dt = GetDataTable("select ifnull(sum(netamt),0) from saleshdrtbl where " &
                                  "dsrno = '" & txtDSRNo.Text & "' and tc = '" & "84" & "' and " &
                                  "status <> '" & "void" & "'")
                If Not CBool(dt.Rows.Count) Then
                    'Call MessageBox.Show("No Cash Sales found.", "DSR System", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Exit Sub
                End If

                For Each dr As DataRow In dt.Rows
                    lblRRtot84.Text = Format(dr.Item(0), "##,##0.00".ToString())
                    lblTot84.Text = Format(dr.Item(0), "##,##0.00".ToString())

                Next

                Call dt.Dispose()

                dt = GetDataTable("select ifnull(sum(netamt),0) from saleshdrtbl where dsrno = '" & txtDSRNo.Text & "' " &
                                  "and tc = '" & "85" & "' and status <> '" & "void" & "'")
                If Not CBool(dt.Rows.Count) Then
                    'Call MessageBox.Show("No Charge Sales found.", "DSR System", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Exit Sub
                End If

                For Each dr As DataRow In dt.Rows
                    lblTot85.Text = Format(dr.Item(0), "##,##0.00".ToString())

                Next

                Call dt.Dispose()

                Dim RRVar As Double = CDbl(IIf(lblRRtot84.Text = "", 0, lblRRtot84.Text)) - CDbl(IIf(txtRRAmt.Text = "", 0, txtRRAmt.Text))
                lblVarRR.Text = Format(RRVar, "##,##0.00")

                'If lblVarRR.Text < 0 Then
                '    lblVarRR.ForeColor = Color.red
                'Else
                '    lblVarRR.ForeColor = Color.Black
                'End If

                Dim TotSales As Double = CDbl(IIf(lblTot84.Text = "", 0, lblTot84.Text)) + CDbl(IIf(lblTot85.Text = "", 0, lblTot85.Text))
                lblTotalSales.Text = Format(TotSales, "##,##0.00")


            End If

        Catch ex As Exception
            'mdiMain.tsErrMsg.Text = ErrorToString()

        End Try

    End Sub

    Private Sub ChkStockAvail()
        dt = GetDataTable("select ifnull(availablestck,0),ifnull(sales,0),ifnull(wrr,0),ifnull(pmstock,0),ifnull(qty,0),ifnull(qty2,0)," &
                          "ifnull(qty3,0),ifnull(qty4,0) from tempdsreport where codeno = '" & txtCodeNo.Text & "' and user = '" & lblUser.Text & "'")
        If Not CBool(dt.Rows.Count) Then
            Exit Sub

        Else
            For Each dr As DataRow In dt.Rows
                Dim Avai As Double = CDbl(dr.Item(0).ToString() - dr.Item(1).ToString() - dr.Item(2).ToString() - dr.Item(3).ToString())
                Dim Heads As Long = CLng(dr.Item(4).ToString() - dr.Item(5).ToString() - dr.Item(6).ToString() - dr.Item(7).ToString())

                'put modal here
                tssErrorMsg.Text = "Available for " & txtCodeNo.Text & ":" & Space(3) & Format(Heads, "#,##0Hds") & Space(3) & Format(Avai, "#,##0.00kgs")

            Next

        End If

        Call dt.Dispose()

    End Sub

    Private Sub clrLines()

        txtCodeNo.Text = ""
        cboMMdesc.Text = Nothing
        txtQty.Text = ""
        txtWt.Text = ""
        txtCodeNo.Focus()

    End Sub

    Private Sub FillLvPMstk()
        dt = GetDataTable("select ifnull(sum(ifnull(qty,0)),0),ifnull(sum(ifnull(wt,0)),0) from pmstocktbl where " &
                          "dsrno = '" & txtDSRNo.Text & "' and smnno = '" & cboSmnName.Text.Substring(0, 3) & "'")
        If Not CBool(dt.Rows.Count) Then
            dgvPMstock.DataSource = Nothing
            dgvPMstock.DataBind()
            Exit Sub '
        Else
            For Each dr As DataRow In dt.Rows
                lblPMqtyTot.Text = Format(CLng(dr.Item(0).ToString()), "#,##0 ")
                lblPMwtTot.Text = Format(CLng(dr.Item(1).ToString()), "#,##0.00 ")

            Next

            txtItm.Text = dgvPMstock.Rows.Count + 1


        End If

        Call dt.Dispose()

        Dim adapter As New MySqlDataAdapter
        Dim ds As New DataSet()
        Dim i As Integer = 0
        sqldata = Nothing

        sqldata = "select a.itmno,a.codeno,b.mmdesc,ifnull(a.qty,0) as qty,ifnull(a.wt,0) as wt from pmstocktbl a " &
                  "left join mmasttbl b on a.codeno=b.codeno where a.dsrno = '" & txtDSRNo.Text & "' " &
                  "and a.smnno = '" & cboSmnName.Text.Substring(0, 3) & "' order by a.itmno"

        conn.Open()
        Dim command As New MySqlCommand(sqldata, conn)
        adapter.SelectCommand = command
        adapter.Fill(ds)
        adapter.Dispose()
        command.Dispose()
        conn.Close()

        dgvPMstock.DataSource = ds.Tables(0)
        dgvPMstock.DataBind()



    End Sub

    Private Sub ListDOsmn()

        dt = GetDataTable("select dono from isshdrtbl where dsrno = '" & txtDSRNo.Text & "' and " &
                          "smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and mov = '603' limit 1")
        If Not CBool(dt.Rows.Count) Then
            dgvDOdsr.DataSource = Nothing
            dgvDOdsr.DataBind()
            Exit Sub 'Call MessageBox.Show("No DO Selected yet.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning) :
        End If

        Call dt.Dispose()

        Dim adapter As New MySqlDataAdapter
        Dim ds As New DataSet()
        Dim i As Integer = 0
        sqldata = Nothing

        sqldata = "select dono,transdate,totqty,totwt,plntno from isshdrtbl where dsrno = '" & txtDSRNo.Text & "' " &
                  "and smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and mov = '603'"

        conn.Open()
        Dim command As New MySqlCommand(sqldata, conn)
        adapter.SelectCommand = command
        adapter.Fill(ds)
        adapter.Dispose()
        command.Dispose()
        conn.Close()

        dgvDOdsr.DataSource = ds.Tables(0)
        dgvDOdsr.DataBind()

    End Sub

    Private Sub fillWRRsum()
        dt = GetDataTable("select wrrno from wrrhdrtbl where dsrno = '" & txtDSRNo.Text & "' and mov = '409'")
        If Not CBool(dt.Rows.Count) Then
            'lblMsg.Text = "Error: No Inventory Found"
            dgvWRRhdr.DataSource = Nothing
            dgvWRRhdr.DataBind()
            Exit Sub

        End If

        dt.Dispose()

        Dim adapter As New MySqlDataAdapter
        Dim ds As New DataSet()
        Dim i As Integer = 0
        sqldata = Nothing

        sqldata = "select a.wrrno,a.transdate,a.totqty,a.totwt,concat(a.plntno,space(1),b.plntname) as plntno " &
                  "from wrrhdrtbl a left join plnttbl b on a.plntno = b.plntno where a.dsrno = '" & txtDSRNo.Text & "' " &
                  "and a.mov = '409'"

        conn.Open()
        Dim command As New MySqlCommand(sqldata, conn)
        adapter.SelectCommand = command
        adapter.Fill(ds)
        adapter.Dispose()
        command.Dispose()
        conn.Close()
        dgvWRRhdr.DataSource = ds.Tables(0)
        dgvWRRhdr.DataBind()

    End Sub

    Private Sub popWRRNo() '

        'Call cboWRRNo.Items.Clear()
        'cboWRRNo.Items.Add("<Clear>")
        'dt = GetDataTable("select wrrno from wrrhdrtbl where smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and " &
        '                  "custno = '" & lblCustNo.Text & "' and dsrno is null " &
        '                  "and mov = '" & "409" & "' order by wrrno")
        'If Not CBool(dt.Rows.Count) Then
        '    Exit Sub

        'Else
        '    cboWRRNo.Items.Add("")
        '    For Each dr As DataRow In dt.Rows
        '        cboWRRNo.Items.Add(dr.Item(0).ToString())

        '    Next

        'End If


        'Call dt.Dispose()

    End Sub

    Private Sub popDONo()

        'Call cboDONo.Items.Clear()
        ''cboDONo.Items.Add("<Clear>")
        'dt = GetDataTable("select dono from isshdrtbl where smnno = '" & cboSmnName.Text.Substring(0, 3) & "' " &
        '                  "and custno = '" & lblCustNo.Text & "' and dsrno = '00000' " &
        '                  "and mov = '603' and status <> 'void' order by dono")
        'If Not CBool(dt.Rows.Count) Then
        '    Exit Sub

        'Else
        '    cboDONo.Items.Add("")
        '    For Each dr As DataRow In dt.Rows
        '        cboDONo.Items.Add(dr.Item(0).ToString())

        '    Next

        'End If

        'Call dt.Dispose()

    End Sub

    Private Sub RRsalesAmt()

        Dim RRamt As Double

        dt = GetDataTable("select smnno,dsrno,ifnull(tc84amt,0),transdate,tc85amt,status from dsrnotbl " &
                          "where smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and status = '" & "OPEN" & "' " &
                          "and dsrno = '" & Trim(txtDSRNo.Text) & "'")
        If Not CBool(dt.Rows.Count) Then
            'Call MessageBox.Show("RR Amount not yet Checked", "DSR System", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Exit Sub

        Else

            For Each dr As DataRow In dt.Rows
                If dr.Item(5).ToString() = "OPEN" Then
                    lbSave.Enabled = True

                Else
                    lbSave.Enabled = False

                End If

                lblRRtot84.Text = Format(dr.Item(2), "##,##0.00".ToString())
                lblTot84.Text = Format(dr.Item(2), "##,##0.00".ToString())
                RRamt = CDbl(dr.Item(2).ToString())
                txtRRAmt.Text = Format(RRamt, "#,##0.00")
                'dpTransDateDSR.Text = Format(CDate(dr.Item(3).ToString()), "dd/MM/yyyy")
                lblTot85.Text = Format(dr.Item(4), "##,##0.00".ToString())
                cboStat.Text = dr.Item(5).ToString()

            Next

            RRamt = CDbl(IIf(txtRRAmt.Text = "", 0, txtRRAmt.Text))

            If RRamt <> CDbl(0) Then
                tssDocStat.Text = "Saved"

            Else
                tssDocStat.Text = "Not Yet Saved"

            End If

            Dim TSales As Double = CDbl(IIf(lblTot84.Text = "", 0, lblTot84.Text)) + CDbl(IIf(lblTot85.Text = "", 0, lblTot85.Text))
            lblTotalSales.Text = Format(TSales, "#,##0.00")

            Call UpdateStocks()

        End If

        Call dt.Dispose()

    End Sub

    Private Sub UpdateStocks()

        sql = "delete from tempdsrstck where user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        'do
        sql = "insert into tempdsrstck(codeno,mmdesc,wt,qty,user) " &
              "select a.codeno,b.mmdesc,ifnull(sum(a.wt),0),ifnull(sum(qty),0),'" & lblUser.Text & "' " &
              "from issdettbl a, mmasttbl b, isshdrtbl c where a.codeno=b.codeno and c.dono=a.dono and " &
              "c.dsrno = '" & txtDSRNo.Text & "' and c.smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and " &
              "c.mov between '" & "603" & "' and '" & "604" & "' group by a.codeno"
        ExecuteNonQuery(sql)

        '==== am stock
        sql = "insert into tempdsrstck(codeno,mmdesc,wt,qty,user) " &
              "select a.codeno,b.mmdesc,ifnull(sum(a.wt),0),ifnull(sum(a.qty),0),'" & lblUser.Text & "' from " &
              "amstocktbl a, mmasttbl b where a.codeno=b.codeno and " &
              "a.smnno = '" & cboSmnName.Text.Substring(0, 3) & "' group by a.codeno"
        ExecuteNonQuery(sql)

        'updating available stock

        '=== sales 
        sql = "insert into tempdsrstck(codeno,mmdesc,wt,qty,user) " &
              "select a.codeno,b.mmdesc,ifnull(sum(a.wt),0)*-1,ifnull(sum(a.qty),0)*-1,'" & lblUser.Text & "' " &
              "from salesdettbl a, mmasttbl b where a.codeno=b.codeno and a.dsrno = '" & txtDSRNo.Text & "' group by codeno"
        ExecuteNonQuery(sql)

        '=== wrr 
        sql = "insert into tempdsrstck(codeno,mmdesc,wt,qty,user) " &
              "select a.codeno,b.mmdesc,ifnull(sum(a.wt),0)*-1,ifnull(sum(a.qty),0)*-1,'" & lblUser.Text & "' " &
              "from wrrdettbl a, mmasttbl b,wrrhdrtbl c where a.codeno=b.codeno and c.wrrno=a.wrrno and " &
              "a.dsrno = '" & txtDSRNo.Text & "' and c.smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and a.mov " &
              "between '" & "409" & "' and '" & "410" & "' and c.tc = '" & "88" & "' group by codeno"
        ExecuteNonQuery(sql)

        '=== pmstock


        '=== get available
        sql = "delete from tempdsreport where user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        sql = "insert into tempdsreport(codeno,description,availablestck,qty,user) " &
              "select codeno,mmdesc,ifnull(sum(wt),0),ifnull(sum(qty),0),'" & lblUser.Text & "' from " &
              "tempdsrstck where user = '" & lblUser.Text & "' group by codeno"
        ExecuteNonQuery(sql)


    End Sub

    Protected Sub lbNew_Click(sender As Object, e As EventArgs)

    End Sub

    Protected Sub lbClose_Click(sender As Object, e As EventArgs)

        Response.Redirect("FinancialAccounting.aspx")

    End Sub

    Protected Sub DgvDOdet_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub DgvDOdet_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub DgvSalesdet_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub DgvSalesdet_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvWRR_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvWRR_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvTC8485_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvTC8485_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvDOdsr_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvDOdsr_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvWRRhdr_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvWRRhdr_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvPMstock_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvPMstock_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvShrink_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvShrink_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvDSRlist_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvDSRlist_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvExcep_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvExcep_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Private Sub getMMstocks()

        cboMMdesc.Items.Clear()
        cboMMdescSI.Items.Clear()
        dt = GetDataTable("select description from tempdsreport where user = '" & lblUser.Text & "'")
        If Not CBool(dt.Rows.Count) Then
            Exit Sub

        Else
            cboMMdesc.Items.Add("")
            cboMMdescSI.Items.Add("")
            For Each dr As DataRow In dt.Rows
                cboMMdesc.Items.Add(dr.Item(0).ToString())
                cboMMdescSI.Items.Add(dr.Item(0).ToString())
            Next

        End If

        Call dt.Dispose()

    End Sub

    Private Sub cboSmnName_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboSmnName.SelectedIndexChanged
        'txtSmnNo.Text = ""
        lblCustNo.Text = "00000"
        lblAreaNo.Text = "000"
        txtDSRNo.Text = ""
        'tssDocNo.Text = "00000000"
        'tssDSRstat.Text = "New"
        txtRRAmt.Text = ""

        dt = GetDataTable("select custno,areano from smnmtbl where smnno = '" & cboSmnName.Text.Substring(0, 3) & "'")
        If Not CBool(dt.Rows.Count) Then
            'mdiMain.tsErrMsg.Text = "Salesman Not found."
            Exit Sub

        Else
            For Each dr As DataRow In dt.Rows
                lblCustNo.Text = dr.Item(0).ToString()
                lblAreaNo.Text = dr.Item(1).ToString()
                lblArea.Text = lblAreaNo.Text

            Next

        End If

        Call dt.Dispose()

        lblBAto.Text = vLoggedBussArea
        lblBranchTo.Text = vLoggedBranch

        filldgvAMstocKSmn()

        'check for open DSR Temp Disable
        dt = GetDataTable("select status,dsrno,transdate,ifnull(tc84amt,0) from dsrnotbl where smnno = '" & cboSmnName.Text.Substring(0, 3) & "' " &
                          "and status = 'OPEN' order by transdate desc limit 1") ' 
        If Not CBool(dt.Rows.Count) Then
            Exit Sub

        Else
            For Each dr As DataRow In dt.Rows
                'place modal here
                'AdmMsgBox("Salesman No. " & txtSmnNo.Text & " have OPEN DSR No. " & dr.Item(1).ToString())
                cboStat.Text = dr.Item(0).ToString() & ""
                txtDSRNo.Text = dr.Item(1).ToString() & ""
                tssDocNo.Text = dr.Item(1).ToString() & ""
                dpTransDateDSR.Text = Format(CDate(dr.Item(2).ToString()), "yyyy-MM-dd")
                tssDSRstat.Text = "Edit"

                If dr.Item(1).ToString() > 0 Then
                    tssDocStat.Text = "Saved"

                End If

            Next

            lblDSRNo.Text = txtDSRNo.Text

        End If

        If txtDSRNo.Text = "" Then
            Exit Sub

        End If

        cboSalesSmn.Items.Clear()
        cboSalesSmn.Items.Add(cboSmnName.Text)


        btnDisAbleFalse()
        LoadExistingDSR()
        'popDSRinvoices()
        'fillExcepList()
        'clrExcepRep()
    End Sub

    Private Sub btnDisAbleFalse()
        cmdAddDO.Enabled = True
        'cmdAddItm.Enabled = True
        'cmdAddSI.Enabled = True
        'cmdDetItm.Enabled = True
        cmdRemDO.Enabled = True
        lbSave.Enabled = True
        Button1.Enabled = True
        Button3.Enabled = True


    End Sub

    Private Sub filldgvAMstocKSmn()
        dt = GetDataTable("select * from amstocktbl where smnno = '" & cboSmnName.Text.Substring(0, 3) & "'")
        If Not CBool(dt.Rows.Count) Then
            dgvAMstock.DataSource = Nothing
            dgvAMstock.DataBind()
            Exit Sub

        End If

        Dim adapter As New MySqlDataAdapter
        Dim ds As New DataSet()
        Dim i As Integer = 0
        sqldata = Nothing

        sqldata = "select a.codeno,b.mmdesc,a.qty,a.wt from amstocktbl a left join mmasttbl b on a.codeno = b.codeno " &
                  "where a.smnno = '" & cboSmnName.Text.Substring(0, 3) & "'"

        With dgvAMstock
            .Columns(0).HeaderText = "Code No."
            .Columns(1).HeaderText = "Description"
            .Columns(2).HeaderText = "Qty"
            .Columns(3).HeaderText = "Wt"

        End With

        conn.Open()
        Dim command As New MySqlCommand(sqldata, conn)
        adapter.SelectCommand = command
        adapter.Fill(ds)
        adapter.Dispose()
        command.Dispose()
        conn.Close()
        dgvAMstock.DataSource = ds.Tables(0)
        dgvAMstock.DataBind()

    End Sub

    Protected Sub dgvAMstock_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvAMstock_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvInvListDSR_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvInvListDSR_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Private Sub getCustListSmn()

        cboCustName.Items.Clear()

        Select Case cboInv.Text.Substring(0, 2)
            Case "84"
                dt = GetDataTable("select concat(custno,space(1),bussname) from custmasttbl where custno = '" & lblCustNo.Text & "'")

            Case "85"
                dt = GetDataTable("select concat(custno,space(1),bussname) from custmasttbl where accttype = 'Main' and " &
                                  "smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and custtype <> 'SMN' order by bussname")
        End Select


        If Not CBool(dt.Rows.Count) Then
            'Call MessageBox.Show("Customer Not found.", "DSR System", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Exit Sub

        Else

            For Each dr As DataRow In dt.Rows
                cboCustName.Items.Add(dr.Item(0).ToString())

            Next


        End If

        Call dt.Dispose()

        cboShipTo.Items.Clear()

        dt = GetDataTable("select concat(custno,space(1),bussname) from custmasttbl where " &
                          "moacctno = '" & cboCustName.Text.Substring(0, 5) & "' order by bussname")
        If Not CBool(dt.Rows.Count) Then
            'Call MessageBox.Show("Customer Not found.", "DSR System", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Exit Sub

        Else

            For Each dr As DataRow In dt.Rows
                cboShipTo.Items.Add(dr.Item(0).ToString())

            Next


        End If

        Call dt.Dispose()

    End Sub

    Private Sub cboInv_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboInv.SelectedIndexChanged
        If cboSalesSmn.Text = Nothing Then
            Exit Sub

        ElseIf cboInv.Text = Nothing Then
            Exit Sub

        End If

        getCustListSmn()

    End Sub

    Private Sub cboSalesSmn_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboSalesSmn.SelectedIndexChanged


    End Sub

    Private Sub txtDSRNo_TextChanged(sender As Object, e As EventArgs) Handles txtDSRNo.TextChanged
        If txtDSRNo.Text = Nothing Then
            Exit Sub

        End If

        lblDSRNo.Text = txtDSRNo.Text

    End Sub

    Private Sub cboShipTo_TextChanged(sender As Object, e As EventArgs) Handles cboShipTo.TextChanged
        If cboCustName.Text = Nothing Then
            Exit Sub

        End If

        popShipToAll()

    End Sub

    Private Sub popShipToAll()
        cboShipTo.Items.Clear()

        dt = GetDataTable("select concat(custno,space(1),bussname) from custmasttbl where " &
                          "moacctno = '" & cboCustName.Text.Substring(0, 5) & "' order by bussname")
        If Not CBool(dt.Rows.Count) Then
            'Call MessageBox.Show("Customer Not found.", "DSR System", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Exit Sub

        Else
            For Each dr As DataRow In dt.Rows
                cboShipTo.Items.Add(dr.Item(0).ToString())

            Next


        End If

        Call dt.Dispose()

    End Sub

    Protected Sub FillLvDodet()
        PandgvDOlist.Visible = False
        PanDgvDOdet.Visible = True

        DgvDOdet.DataSource = Nothing
        DgvDOdet.DataBind()

        dt = GetDataTable("select sum(ifnull(qty,0)),sum(ifnull(wt,0)) from issdettbl where dono = '" & txtDONo.Text & "'")
        If Not CBool(dt.Rows.Count) Then
            lblTotQtyDSR.Text = "0"
            lblTotWtDSR.Text = "0.00"
            Exit Sub

        Else
            For Each dr As DataRow In dt.Rows
                lblTotQtyDSR.Text = Format(CDbl(dr.Item(0).ToString()), "0")
                lblTotWtDSR.Text = Format(CDbl(dr.Item(1).ToString()), "0.00")

            Next

        End If

        dt.Dispose()

        Dim adapter As New MySqlDataAdapter
        Dim ds As New DataSet()
        Dim i As Integer = 0
        sqldata = Nothing

        sqldata = "select a.codeno,b.mmdesc,ifnull(a.qty,0) as qty,ifnull(a.wt,0) as wt from issdettbl a " &
                  "left join mmasttbl b on a.codeno=b.codeno where a.dono = '" & txtDONo.Text & "' group by a.idno"

        conn.Open()
        Dim command As New MySqlCommand(sqldata, conn)
        adapter.SelectCommand = command
        adapter.Fill(ds)
        adapter.Dispose()
        command.Dispose()
        conn.Close()
        DgvDOdet.DataSource = ds.Tables(0)
        DgvDOdet.DataBind()

        With DgvDOdet
            .Columns(0).HeaderText = "Code No."
            .Columns(1).HeaderText = "Description"
            .Columns(2).HeaderText = "Qty"
            .Columns(3).HeaderText = "Wt"

        End With


    End Sub

    Private Sub dpTransDateDSR_TextChanged(sender As Object, e As EventArgs) Handles dpTransDateDSR.TextChanged
        If cboSmnName.Text = "" Or cboSmnName.Text = Nothing Then
            'MsgBox("Select " & Label9.Text)
            Exit Sub

        ElseIf cboStat.Text = "COMPLETED" Then
            'MsgBox("Please check DSR Status")
            Exit Sub

        End If

        'If dpTransDate.Value > Now() Then
        '    AdmMsgBox("Please Check DSR Date, Post Date not Allowed")
        '    dpTransDate.Value = Now()
        '    Exit Sub

        'End If

        PeriodCheck()

    End Sub

    Private Sub PeriodCheck()
        If dpTransDateDSR.Text = Nothing Then
            Exit Sub
        End If

        If CDate(dpTransDateDSR.Text) < vTransMon Then
            'AdmMsgBox(Format(CDate(dpTransDateDSR.Text), "MMM yyyy") & " is Already CLOSED")
            dpTransDateDSR.Text = CDate(Now())
            Exit Sub

        Else
            dt = GetDataTable("select * from gljvhdrtbl where sourcedoc = '" & vJVsource & "' and " &
                              "'" & Format(CDate(dpTransDateDSR.Text), "yyyy-MM-dd") & "' " &
                              "between dfrom and dto")
            If Not CBool(dt.Rows.Count) Then

                'txtDSRNo.Text = txtSmnNo.Text & "-" & Format(CDate(dpTransDate.Value), "yyMMdd")
                'DSRNoEnter()
                'txtDSRNo.ReadOnly = True

            Else

                AdmMsgBox(vJVsource & " GL Transaction already Processed")
                dpTransDateDSR.Text = CDate(Now())
                Exit Sub

            End If

        End If

    End Sub

    Protected Sub dgvDOlist_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvDOlist_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Private Sub cmdAddDO_Click(sender As Object, e As ImageClickEventArgs) Handles cmdAddDO.Click

        If txtDONo.Text = "" Then
            AdmMsgBox("Please select DO No.")
            'cboDONo.Focus()
            Exit Sub

        ElseIf cboStat.Text = "" Then
            'cboStat.Focus()
            AdmMsgBox("Select Status")
            Exit Sub

        ElseIf txtDSRNo.Text = "" Then
            'txtDSRNo.Focus()
            AdmMsgBox("DSR No. is Blank")
            Exit Sub

        ElseIf DgvDOdet.Rows.Count = 0 Then
            AdmMsgBox("DO details is empty")
            Exit Sub

        ElseIf cboStat.Text = "COMPLETED" Then
            AdmMsgBox("Not Possible DSR is already Completed")
            Exit Sub

        End If

        If IsNumeric(txtDSRNo.Text) Then
            'insert validation
            dt = GetDataTable("select status from dsrnotbl where dsrno = '" & txtDSRNo.Text & "'")
            If Not CBool(dt.Rows.Count) Then

            Else
                For Each dr As DataRow In dt.Rows
                    Select Case dr.Item(0).ToString()
                        Case "COMPLETED"
                            AdmMsgBox("Not Possible DSR No. " & txtDSRNo.Text & " already COMPLETED")
                            Exit Sub

                    End Select

                Next


            End If

            dt.Dispose()

        Else
            AdmMsgBox("Invalid DSR No., please Check")
            Exit Sub

        End If

        dt = GetDataTable("select dsrno from isshdrtbl where dono = '" & txtDONo.Text & "' and " &
                          "smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and mov = '603'")
        If Not CBool(dt.Rows.Count) Then
            AdmMsgBox("DO No." & txtDONo.Text & " not found")
            Exit Sub

        Else
            For Each dr As DataRow In dt.Rows
                Answer = MsgBox("DO No. " & txtDONo.Text & " is already in DSR No. " & dr.Item(0).ToString & " are you sure you want to add?", vbExclamation + vbYesNo)
                If Answer = vbYes Then

                    Dim strStat As String = "OPEN"
                    sql = "update isshdrtbl set dsrno = '" & Trim(txtDSRNo.Text) & "',salesdoc = '" & "dsr" & "' " &
                          "where dono = '" & Trim(txtDONo.Text) & "' and smnno = '" & cboSmnName.Text.Substring(0, 3) & "'"
                    ExecuteNonQuery(sql)

                    sql = "update issdettbl set dsrno = '" & Trim(txtDSRNo.Text) & "',dsrstat = '" & strStat & "' where dono = '" & txtDONo.Text & "'"
                    ExecuteNonQuery(sql)

                    AdmMsgBox("DO No. " & txtDONo.Text & " Added")

                    Call ListDOsmn()
                    'vLastAct = Me.Text & " Load DO No. " & cboDONo.Text & Space(1) & txtDSRNo.Text & Space(1) & txtSmnNo.Text
                    'WriteToLogs(vLastAct)

                Else

                    AdmMsgBox("Updating DSR Cancelled")

                End If

            Next

        End If

        Call UpdateStocks()
        popExpMMdesc()

        DgvDOdet.DataSource = Nothing
        DgvDOdet.DataBind()

        lblTotQtyDSR.Text = "0"
        lblTotWtDSR.Text = "0.00"
        txtDONo.Text = ""

    End Sub

    Private Sub popExpMMdesc()
        cboMMdescExcep.Items.Clear()
        dt = GetDataTable("select concat(codeno,space(1),mmdesc) from tempdsrstck where user = '" & lblUser.Text & "' group by codeno order by mmdesc")
        If Not CBool(dt.Rows.Count) Then
            Exit Sub

        Else
            cboMMdescExcep.Items.Add("")
            For Each dr As DataRow In dt.Rows
                cboMMdescExcep.Items.Add(dr.Item(0).ToString())
            Next

        End If

        dt.Dispose()

    End Sub

    Protected Sub fillDOlist()
        dt = GetDataTable("select a.dono,a.transdate,concat(a.plntno,space(1),b.plntname) as plntno,ifnull(a.totqty,0) as totqty," &
                          "ifnull(a.totwt,0) as totwt from isshdrtbl a left join plnttbl b on a.plntno = b.plntno " &
                          "where a.smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and a.custno = '" & lblCustNo.Text & "' and " &
                          "a.dsrno = '00000' and a.mov = '603' and a.status <> 'void' order by a.dono")
        If Not CBool(dt.Rows.Count) Then
            dgvDOlist.DataSource = Nothing
            dgvDOlist.DataBind()

        End If

        dt.Dispose()

        Dim adapter As New MySqlDataAdapter
        Dim ds As New DataSet()
        Dim i As Integer = 0
        sqldata = Nothing

        sqldata = "select a.dono,a.transdate,concat(a.plntno,space(1),b.plntname) as plntno,ifnull(a.totqty,0) as totqty," &
                  "ifnull(a.totwt,0) as totwt from isshdrtbl a left join plnttbl b on a.plntno = b.plntno " &
                  "where a.smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and a.custno = '" & lblCustNo.Text & "' and " &
                  "a.dsrno = '00000' and a.mov = '603' and a.status <> 'void' order by a.dono"

        conn.Open()
        Dim command As New MySqlCommand(sqldata, conn)
        adapter.SelectCommand = command
        adapter.Fill(ds)
        adapter.Dispose()
        command.Dispose()
        conn.Close()
        dgvDOlist.DataSource = ds.Tables(0)
        dgvDOlist.DataBind()

        With dgvDOlist
            .Columns(0).HeaderText = "Select"
            .Columns(1).HeaderText = "DO No."
            .Columns(2).HeaderText = "Date"
            .Columns(3).HeaderText = "Source Plant"
            .Columns(4).HeaderText = "Total Qty"
            .Columns(5).HeaderText = "Total Wt"

        End With

    End Sub

    Private Sub txtDONo_TextChanged(sender As Object, e As EventArgs) Handles txtDONo.TextChanged
        If txtDONo.Text = "" Or txtDONo.Text = Nothing Then
            Exit Sub
        End If

        PandgvDOlist.Visible = False
        PanDgvDOdet.Visible = True

        'Call FillLvDodet()
        'Select Case cboDONo.Text
        '    Case "<Clear>"
        '        DgvDOdet.DataSource = Nothing
        '        DgvDOdet.DataBind()

        '        lblTotQtyDSR.Text = "0"
        '        lblTotWtDSR.Text = "0.00"

        '        Exit Sub

        '    Case Else

        '        Call FillLvDodet()

        'End Select

    End Sub

    Private Sub dgvDOlist_SelectedIndexChanged(sender As Object, e As EventArgs) Handles dgvDOlist.SelectedIndexChanged
        txtDONo.Text = dgvDOlist.SelectedRow.Cells(1).Text
        FillLvDodet()
    End Sub

    Private Sub lbOpenDO_Click(sender As Object, e As ImageClickEventArgs) Handles lbOpenDO.Click
        If cboSmnName.Text = "" And cboSmnName.Text = Nothing Then
            Exit Sub
        End If

        PandgvDOlist.Visible = True
        PanDgvDOdet.Visible = False

        fillDOlist()

    End Sub

    Protected Sub dgvWRRlist_RowDataBound(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Protected Sub dgvWRRlist_RowCreated(sender As Object, e As GridViewRowEventArgs)

    End Sub

    Private Sub lbWRRlist_Click(sender As Object, e As ImageClickEventArgs) Handles lbWRRlist.Click
        PandgvWRR.Visible = False
        PandgvWRRlist.Visible = True

        dgvWRRlist.DataSource = Nothing
        dgvWRRlist.DataBind()

        dt = GetDataTable("select ifnull(totqty,0),ifnull(totwt,0) from wrrhdrtbl where smnno = '" & cboSmnName.Text.Substring(0, 3) & "' " &
                          "and custno = '" & lblCustNo.Text & "' and dsrno is null and mov = '409' and status <> 'void'")
        If Not CBool(dt.Rows.Count) Then
            Exit Sub
        Else
            For Each dr As DataRow In dt.Rows
                lblTotWRRqtyDSR.Text = Format(CDbl(dr.Item(0).ToString), "#,##0 ; (#,##0)")
                lblTotWRRwtDSR.Text = Format(CDbl(dr.Item(1).ToString), "#,##0.00 ; (#,##0.00)")

            Next

        End If

        dt.Dispose()

        Dim adapter As New MySqlDataAdapter
        Dim ds As New DataSet()
        Dim i As Integer = 0
        sqldata = Nothing

        sqldata = "select a.wrrno,a.transdate,concat(a.plntno,space(1),b.plntname) as plntno,ifnull(a.totqty,0) as totqty," &
                  "ifnull(a.totwt,0) as totwt from wrrhdrtbl a left join plnttbl b on a.plntno = b.plntno " &
                  "where a.smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and a.custno = '" & lblCustNo.Text & "' and " &
                  "a.dsrno is null and a.mov = '409' and a.status <> 'void'"

        With dgvWRRlist
            .Columns(0).HeaderText = "Select"
            .Columns(1).HeaderText = "WRR No."
            .Columns(2).HeaderText = "Date"
            .Columns(3).HeaderText = "Source Plant"
            .Columns(4).HeaderText = "Qty/Head"
            .Columns(5).HeaderText = "Wt/Kilos"

        End With

        conn.Open()
        Dim command As New MySqlCommand(sqldata, conn)
        adapter.SelectCommand = command
        adapter.Fill(ds)
        adapter.Dispose()
        command.Dispose()
        conn.Close()

        dgvWRRlist.DataSource = ds.Tables(0)
        dgvWRRlist.DataBind()



    End Sub

    Private Sub txtWRRNo_TextChanged(sender As Object, e As EventArgs) Handles txtWRRNo.TextChanged




    End Sub

    Private Sub cboShrUnit_TextChanged(sender As Object, e As EventArgs) Handles cboShrUnit.TextChanged
        If txtDSRNo.Text = "" Then
            'MsgBox("DSR No. is Blank", vbCritical)
            'txtDSRNo.Focus()
            Exit Sub

        ElseIf cboSmnName.Text.Substring(0, 3) = "" Then
            'MsgBox("Salesman No. is Blank", vbCritical)
            'txtSmnNo.Focus()
            Exit Sub

        ElseIf cboShrUnit.Text = "" Or cboShrUnit.Text = Nothing Then
            'cboShrUnit.Focus()
            'MsgBox("Select UM", vbInformation)
            Exit Sub
        End If

        CalcRR()

        Call ShrinkRep()
        Call filldgview()

    End Sub

    Protected Sub ShrinkRep()
        sql = "delete from tempdsrstck where user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        'do
        sql = "insert into tempdsrstck(codeno,wt,qty,user) select a.codeno,ifnull(sum(a.wt),0)," &
              "ifnull(sum(a.qty),0),'" & lblUser.Text & "' from issdettbl a left join isshdrtbl b on a.dono=b.dono " &
              "where (a.wt <> 0 or a.qty <> 0) and a.dsrno = '" & txtDSRNo.Text & "' and b.smnno = '" & cboSmnName.Text.Substring(0, 3) & "' group by a.codeno"
        ExecuteNonQuery(sql)


        '==== am stock

        sql = "delete from amstocktbl where codeno = '' and smnno = '" & cboSmnName.Text.Substring(0, 3) & "'"
        ExecuteNonQuery(sql)

        sql = "insert into tempdsrstck(codeno,wt,qty,user) select codeno,ifnull(sum(wt),0)," &
              "ifnull(sum(qty),0),'" & lblUser.Text & "' from amstocktbl where " &
              "(wt <> 0 or qty <> 0) and smnno = '" & cboSmnName.Text.Substring(0, 3) & "' group by codeno"
        ExecuteNonQuery(sql)

        'sales items
        sql = "insert into tempdsrstck(codeno,wt,qty,user) select a.codeno,0,0,'" & lblUser.Text & "' from " &
              "salesdettbl a left join saleshdrtbl b on a.invno=b.invno where a.dsrno = '" & txtDSRNo.Text & "' " &
              "and b.smnno = '" & cboSmnName.Text.Substring(0, 3) & "' group by a.codeno"
        ExecuteNonQuery(sql)

        'check if data imgrated to shirkage temptable
        dt = GetDataTable("select * from tempdsrstck where user = '" & lblUser.Text & "'")
        If Not CBool(dt.Rows.Count) Then
            'Call MessageBox.Show("DO / AM Stock Found", "DSR System", MessageBoxButtons.OK, MessageBoxIcon.Warning) ': Exit Sub
        End If

        '*****insert new PM stock codes here *****
        sql = "insert into tempdsrstck(codeno,pmstock,qty4,user,wt,qty) select codeno,ifnull(sum(wt),0),ifnull(sum(qty),0)," &
              "'" & lblUser.Text & "',0,0 from pmstocktbl where dsrno = '" & txtDSRNo.Text & "' group by codeno"
        ExecuteNonQuery(sql)

        'insert of dsreport
        sql = "delete from tempdsreport where user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        sql = "insert into tempdsreport(codeno,availablestck,qty,pmstock,qty4,user) " &
              "select codeno,ifnull(sum(wt),0),ifnull(sum(qty),0),ifnull(sum(pmstock),0),ifnull(sum(qty4),0),'" & lblUser.Text & "' " &
              "from tempdsrstck where user = '" & lblUser.Text & "' group by codeno"
        ExecuteNonQuery(sql)

        '==== am stock =====

        'new code AM stock
        sql = "update tempdsreport,(select codeno,ifnull(sum(wt),0) as wt,ifnull(sum(qty),0) as qty from amstocktbl where smnno = '" & cboSmnName.Text.Substring(0, 3) & "' " &
              "and (wt <> 0 or qty <> 0) group by codeno) as amstockqty set tempdsreport.amstock = amstockqty.wt," &
              "tempdsreport.amqty = amstockqty.qty where tempdsreport.codeno = amstockqty.codeno and tempdsreport.user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        'new update DO
        sql = "update tempdsreport,(select codeno,ifnull(sum(wt),0) as wt,ifnull(sum(qty),0) as qty from issdettbl where dsrno = '" & txtDSRNo.Text & "' " &
              "and (wt <> 0 or qty <> 0) and smnno = '" & cboSmnName.Text.Substring(0, 3) & "' group by codeno) as dodata set tempdsreport.dos = dodata.wt," &
              "tempdsreport.doqty = dodata.qty where tempdsreport.codeno = dodata.codeno and tempdsreport.user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        'new sales code
        sql = "update tempdsreport,(select a.codeno,ifnull(sum(a.wt),0) as wt,ifnull(sum(a.qty),0) as qty from salesdettbl a " &
              "left join saleshdrtbl b on a.invno=b.invno where b.status <> 'void' and (a.wt <> 0 or a.qty <> 0) and b.smnno = '" & cboSmnName.Text.Substring(0, 3) & "' " &
              "and a.dsrno = '" & txtDSRNo.Text & "' group by a.codeno,b.smnno) as salesdata set tempdsreport.sales = salesdata.wt," &
              "tempdsreport.qty2 = salesdata.qty where tempdsreport.codeno = salesdata.codeno and tempdsreport.user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        'new wrr update
        sql = "update tempdsreport,(select a.codeno,ifnull(sum(a.wt),0) as wt,ifnull(sum(a.qty),0) as qty from wrrdettbl a " &
              "left join wrrhdrtbl b on a.wrrno=b.wrrno where a.dsrno = '" & txtDSRNo.Text & "' and b.smnno = '" & cboSmnName.Text.Substring(0, 3) & "' " &
              "and b.status <> 'void' group by a.codeno,b.smnno) as wrrdata set tempdsreport.wrr = wrrdata.wt,tempdsreport.qty3 = wrrdata.qty " &
              "where tempdsreport.codeno = wrrdata.codeno and tempdsreport.user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        'new PM stock code
        'sql = "update tempdsreport,(select codeno,ifnull(sum(wt),0) as wt,ifnull(sum(qty),0) as qty from pmstocktbl where " & _
        '      "dsrno = '" & txtDSRNo.Text & "' and smnno = '" & cboSmnName.Text.Substring(0, 3) & "' and (wt <> 0 or qty <> 0) group by codeno,smnno) as PMstockData " & _
        '      "set tempdsreport.pmstock= PMstockData.wt,tempdsreport.qty4 = PMstockData.qty where tempdsreport.codeno = PMstockData.codeno " & _
        '      "and tempdsreport.user = '" & lblUser.text & "'"
        'ExecuteNonQuery(sql)

        '==== shinkage update

        sql = "update tempdsreport set netavail_wt = (ifnull(amstock,0) + ifnull(dos,0)) - (ifnull(wrr,0) + ifnull(pmstock,0)) where user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        sql = "update tempdsreport set shrinkage = ifnull(netavail_wt,0) - ifnull(sales,0) where user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        sql = "update tempdsreport set pcnt = (ifnull(shrinkage,0)/ifnull(netavail_wt,0)) * 100 where user = '" & lblUser.Text & "' " &
              "and netavail_wt <> 0"
        ExecuteNonQuery(sql)

        sql = "update tempdsreport set pcnt = 0 where user = '" & lblUser.Text & "' and shrinkage = 0"
        ExecuteNonQuery(sql)

        sql = "update tempdsreport set pcnt = 0 where user = '" & lblUser.Text & "' and sales = 0"
        ExecuteNonQuery(sql)

        'no sales with shrinkage
        sql = "update tempdsreport set pcnt = (ifnull(shrinkage,0)/(ifnull(amstock,0) + ifnull(dos,0))) * 100 where user = '" & lblUser.Text & "' " &
              "and sales = 0"
        ExecuteNonQuery(sql)


        'sql = "update tempdsreport set pcnt = 0 where user = '" & lblUser.text & "' and netavail_wt = 0"
        'ExecuteNonQuery(sql)

        sql = "update tempdsreport set netavail_qty = (ifnull(amqty,0) + ifnull(doqty,0)) - (ifnull(qty3,0) + ifnull(qty4,0)) where user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        sql = "update tempdsreport set varqty = ifnull(netavail_qty,0)-ifnull(qty2,0) where user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)

        sql = "update tempdsreport a left join mmasttbl b on a.codeno=b.codeno set a.description=b.mmdesc where a.user = '" & lblUser.Text & "'"
        ExecuteNonQuery(sql)


    End Sub

    Private Sub filldgview()

        dgvShrink.DataSource = Nothing
        dgvShrink.DataBind()

        Select Case cboShrUnit.Text
            Case "Kilos"
                strUnit = "Kilos"

            Case "Heads"
                strUnit = "Heads"

            Case "Packs"
                strUnit = "Heads"

            Case "Pcs"
                strUnit = "Kilos"

            Case "Liters"
                strUnit = "Kilos"

        End Select

        dt = GetDataTable("select sum(ifnull(varqty,0)),sum(ifnull(shrinkage,0)) from tempdsreport " &
                          "where user = '" & lblUser.Text & "'")
        If Not CBool(dt.Rows.Count) Then
            Exit Sub

        Else
            For Each dr As DataRow In dt.Rows
                lblVarQty2.Text = Format(CDbl(dr.Item(0).ToString), "#,##0 ; (#,##0)")
                lblTotVar.Text = Format(CDbl(dr.Item(1).ToString), "#,##0.00 ; (#,##0.00)")

            Next
        End If

        dt.Dispose()

        Dim adapter As New MySqlDataAdapter
        Dim ds As New DataSet()
        Dim i As Integer = 0
        sqldata = Nothing

        sqldata = "select a.codeno,b.mmdesc,ifnull(a.amqty,0) as qty_amstock,ifnull(a.amstock,0) as wt_amstock,ifnull(a.doqty,0) as qty_do," &
                  "ifnull(a.dos,0) as wt_do,ifnull(a.qty,0) as qty_totload,ifnull(a.availablestck,0) as wt_totload,ifnull(a.qty2,0) as qty_sales," &
                  "ifnull(a.sales,0) as wt_sales,ifnull(a.qty3,0) as qty_wrr,ifnull(a.wrr,0) as wt_wrr,ifnull(a.qty4,0) as qty_pmstock," &
                  "ifnull(a.pmstock,0) as wt_pmstock,ifnull(a.varqty,0) as qty_var,ifnull(a.shrinkage,0) as wt_var,ifnull(a.pcnt,0)/100 as perc_wt " &
                  "from tempdsreport a left join mmasttbl b on a.codeno=b.codeno where a.user = '" & lblUser.Text & "' and b.mmtype = 'Finished Goods'"

        With dgvShrink
            .Columns(0).HeaderText = "Code No."
            .Columns(1).HeaderText = "Description"
            .Columns(2).HeaderText = "AM Stock"
            .Columns(3).HeaderText = "AM Stock"
            .Columns(4).HeaderText = "Total DO"
            .Columns(5).HeaderText = "Total DO"
            .Columns(6).HeaderText = "Total Load"
            .Columns(7).HeaderText = "Total Load"
            .Columns(8).HeaderText = "Sales"
            .Columns(9).HeaderText = "Sales"
            .Columns(10).HeaderText = "WRR"
            .Columns(11).HeaderText = "WRR"
            .Columns(12).HeaderText = "PM Stock"
            .Columns(13).HeaderText = "PM Stock"
            .Columns(14).HeaderText = "Var. Qty"
            .Columns(15).HeaderText = "Shrinkage"
            .Columns(16).HeaderText = "Percent"

            Select Case strUnit
                Case "Kilos"
                    .Columns(2).Visible = False
                    .Columns(4).Visible = False
                    .Columns(6).Visible = False
                    .Columns(8).Visible = False
                    .Columns(10).Visible = False
                    .Columns(12).Visible = False
                    .Columns(14).Visible = False

                    .Columns(3).Visible = True
                    .Columns(5).Visible = True
                    .Columns(7).Visible = True
                    .Columns(9).Visible = True
                    .Columns(11).Visible = True
                    .Columns(13).Visible = True
                    .Columns(15).Visible = True
                    .Columns(16).Visible = True

                Case "Heads"
                    .Columns(3).Visible = False
                    .Columns(5).Visible = False
                    .Columns(7).Visible = False
                    .Columns(9).Visible = False
                    .Columns(11).Visible = False
                    .Columns(13).Visible = False
                    .Columns(15).Visible = False
                    .Columns(16).Visible = False

                    .Columns(2).Visible = True
                    .Columns(4).Visible = True
                    .Columns(6).Visible = True
                    .Columns(8).Visible = True
                    .Columns(10).Visible = True
                    .Columns(12).Visible = True
                    .Columns(14).Visible = True
            End Select

        End With

        conn.Open()
        Dim command As New MySqlCommand(sqldata, conn)
        adapter.SelectCommand = command
        adapter.Fill(ds)
        adapter.Dispose()
        command.Dispose()
        conn.Close()
        dgvShrink.DataSource = ds.Tables(0)
        dgvShrink.DataBind()



    End Sub

    Private Sub getMMcode()

        dt = GetDataTable("select codeno from mmasttbl where mmdesc = '" & cboMMdesc.Text & "'")
        If Not CBool(dt.Rows.Count) Then
            'Call MessageBox.Show("Material Not found in Materfile.", "DSR System", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Exit Sub
        Else
            For Each dr As DataRow In dt.Rows
                txtCodeNo.Text = dr.Item(0).ToString()

            Next
        End If


        Call dt.Dispose()

    End Sub

    Private Sub cboMMdesc_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboMMdesc.SelectedIndexChanged
        Call getMMcode()

        dt = GetDataTable("select * from pmstocktbl where codeno = '" & txtCodeNo.Text & "' and " &
                          "dsrno = '" & txtDSRNo.Text & "' and smnno = '" & cboSmnName.Text.Substring(0, 3) & "'")
        If Not CBool(dt.Rows.Count) Then
            dt2 = GetDataTable("select codeno from tempdsreport where codeno = '" & txtCodeNo.Text & "' " &
                              "and user = '" & lblUser.Text & "'") ''
            If Not CBool(dt2.Rows.Count) Then
                Answer = MsgBox("Material " & cboMMdesc.Text & " Not Available in Stock, Do you want to Add?", vbExclamation + vbYesNo)
                If Answer = vbYes Then
                    Call UpdateStocks()
                    'Call ChkStockAvail()

                Else
                    Exit Sub

                End If
                'Call MessageBox.Show("Material " & txtCodeNo.Text & " Not Available", "DSR System", MessageBoxButtons.OK, MessageBoxIcon.Warning)

            Else
                'Call UpdateStocks()
                'Call ChkStockAvail()

            End If

            dt2.Dispose()

        Else
            AdmMsgBox("Duplicate Material not allowed, Material " + txtCodeNo.Text + Space(1) + cboMMdesc.Text + " Already on file")
            Call clrLines()
            'Call FillLvPMstk()
            Exit Sub

        End If

        Call dt.Dispose()

        txtQty.Focus()


    End Sub

    Private Sub DailySalesReport_Unload(sender As Object, e As EventArgs) Handles Me.Unload



    End Sub

    Protected Sub OnConfirm4(sender As Object, e As EventArgs)
        Dim confirmValue As String = Request.Form("confirm_value4")
        If confirmValue = "Yes" Then
            AdmMsgBox("Yes")

        Else
            AdmMsgBox("Action Aborted")

        End If

    End Sub

    Private Sub dgvWRRlist_SelectedIndexChanged(sender As Object, e As EventArgs) Handles dgvWRRlist.SelectedIndexChanged

        txtWRRNo.Text = dgvWRRlist.SelectedRow.Cells(1).Text
        fillLVwrrDet()

    End Sub

    Protected Sub fillLVwrrDet()
        PandgvWRRlist.Visible = False
        PandgvWRR.Visible = True

        dgvWRR.Visible = True

        dgvWRR.DataSource = Nothing
        dgvWRR.DataBind()

        dt = GetDataTable("select sum(ifnull(qty,0)),sum(ifnull(wt,0)) from wrrdettbl where wrrno = '" & txtWRRNo.Text & "'")
        If Not CBool(dt.Rows.Count) Then
            lblTotWRRqtyDSR.Text = "0"
            lblTotWRRwtDSR.Text = "0.00"
            Exit Sub

        Else
            For Each dr As DataRow In dt.Rows
                lblTotWRRqtyDSR.Text = Format(CDbl(dr.Item(0).ToString()), "0")
                lblTotWRRwtDSR.Text = Format(CDbl(dr.Item(1).ToString()), "0.00")

            Next

        End If

        dt.Dispose()

        Dim adapter As New MySqlDataAdapter
        Dim ds As New DataSet()
        Dim i As Integer = 0
        sqldata = Nothing

        sqldata = "select a.codeno,b.mmdesc,ifnull(a.qty,0) as qty,ifnull(a.wt,0) as wt from wrrdettbl a " &
                  "left join mmasttbl b on a.codeno=b.codeno where a.dono = '" & txtWRRNo.Text & "'"

        With dgvWRR
            .Columns(0).HeaderText = "Code No."
            .Columns(1).HeaderText = "Description"
            .Columns(2).HeaderText = "Qty"
            .Columns(3).HeaderText = "Wt"

        End With

        conn.Open()
        Dim command As New MySqlCommand(sqldata, conn)
        adapter.SelectCommand = command
        adapter.Fill(ds)
        adapter.Dispose()
        command.Dispose()
        conn.Close()
        dgvWRR.DataSource = ds.Tables(0)
        dgvWRR.DataBind()



    End Sub
End Class