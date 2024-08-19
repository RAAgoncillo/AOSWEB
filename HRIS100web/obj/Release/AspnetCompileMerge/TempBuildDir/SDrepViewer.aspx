﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SDrepViewer.aspx.vb" Inherits="AOS100web.SDrepViewer" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.3500.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<!DOCTYPE html>

<script type="text/javascript">  
    function Print() {  
        var dvReport = document.getElementById("dvReport");  
        var frame1 = dvReport.getElementsByTagName("iframe")[0];  
        if (navigator.appName.indexOf("Internet Explorer") != -1 || navigator.appVersion.indexOf("Trident") != -1) {  
            frame1.name = frame1.id;  
            window.frames[frame1.id].focus();  
            window.frames[frame1.id].print();  
        } else {  
            var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;  
            frameDoc.print();  
        }  
    }  
</script>  

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>

    <%-- <CR:CrystalReportViewer ID="CrystalReportViewer2" runat="server" AutoDataBind="true" />--%>
    <form id="form1" runat="server">
        <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" AutoDataBind="true" ToolPanelView="None" />
      
    </form>

</body>

</html>
