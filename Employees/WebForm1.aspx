<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="Employees.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function () {

        $("#btnSave").click(function (e) {
            let isValid = true;


            if ($("#txtName").val().trim() === "") {
                alert("Name is required.");
                isValid = false;
            }


            if ($("#txtDesignation").val().trim() === "") {
                alert("Designation is required.");
                isValid = false;
            }

            if ($("#txtDOJ").val().trim() === "" || !isValidDate($("#txtDOJ").val())) {
                alert("Enter a valid Date of Joining (dd/MM/yyyy).");
                isValid = false;
            }

            if ($("#txtSalary").val().trim() === "" || isNaN($("#txtSalary").val())) {
                alert("Enter a valid Salary.");
                isValid = false;
            }

            if (!$("input[name='gender']:checked").val()) {
                alert("Select Gender.");
                isValid = false;
            }


            if ($("#ddlState").val() === "Select") {
                alert("Select a State.");
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
            }
        });

        function isValidDate(dateString) {
            const regex = /^\d{2}\/\d{2}\/\d{4}$/;
            if (!regex.test(dateString)) {
                return false;
            }

            const [day, month, year] = dateString.split("/").map(Number);
            const date = new Date(year, month - 1, day);
            return (
                date.getFullYear() === year &&
                date.getMonth() === month - 1 &&
                date.getDate() === day
            );
        }


        function calculateTotalSalary() {
            let total = 0;
            $("#gvEmployees tbody tr").each(function () {
                const salary = parseFloat($(this).find("td:nth-child(5)").text());
                if (!isNaN(salary)) {
                    total += salary;
                }
            });
            $("#lblTotalSalary").text("Total Salary: " + total.toFixed(2));
        }


        calculateTotalSalary();


        $("#gvEmployees").on("click", ".btn-delete, .btn-edit", function () {
            setTimeout(calculateTotalSalary, 500);
        });
    });
</script>

    <style type="text/css">
        .auto-style1 {
            width: 225px;
            height: 38px;
        }
        .auto-style2 {
            height: 34px;
        }
        .auto-style3 {
            width: 225px;
            height: 34px;
        }
        .auto-style4 {
            height: 45px;
        }
        .auto-style5 {
            width: 225px;
            height: 45px;
        }
        .auto-style6 {
            height: 41px;
        }
        .auto-style7 {
            width: 225px;
            height: 41px;
        }
        .auto-style8 {
            height: 38px;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
       <h2 style="background-color:aqua" align="center">Employee Details</h2>
    <table style="border:double" align="center">
        <tr>
            <td class="auto-style8">Name:</td>
            <td class="auto-style1"><asp:TextBox ID="txtName" runat="server"></asp:TextBox><span style="color:red">*</span></td>
            
        </tr>
        <tr>
            <td class="auto-style6">Designation:</td>
            <td class="auto-style7"><asp:TextBox ID="txtDesignation" runat="server"></asp:TextBox><span style="color:red">*</span></td>
        </tr>
        <tr>
            <td class="auto-style6">Date of Join:</td>
            <td class="auto-style7"><asp:TextBox ID="txtDOJ" runat="server"></asp:TextBox><span style="color:red">*</span></td>
        </tr>
        <tr>
            <td class="auto-style4">Salary:</td>
            <td class="auto-style5"><asp:TextBox ID="txtSalary" runat="server"></asp:TextBox><span style="color:red">*</span></td>
        </tr>
        <tr>
            <td class="auto-style2">Gender:</td>
            <td class="auto-style3">
                <asp:RadioButton ID="rbtnMale" runat="server" GroupName="Gender" Text="Male" />
                <asp:RadioButton ID="rbtnFemale" runat="server" GroupName="Gender" Text="Female" /><span style="color:red">*</span>
            </td>
        </tr>
        <tr>
            <td class="auto-style2">State:</td>
            <td class="auto-style3">
               <asp:DropDownList ID="ddlState" runat="server" Height="27px" Width="164px">

                   <asp:ListItem Text="Select" Value="" />
                    <asp:ListItem Text="California" Value="California" />
                    <asp:ListItem Text="New York" Value="New York" />
               </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td>
           
            </td>
            <td>
                <asp:Button ID="btnsave" runat="server" Text="save" OnClick="btnSave_Click" Width="135px" />
            </td>
        </tr>
    </table>
  <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" DataKeyNames="id" OnRowCommand="gvEmployees_RowCommand" Width="1525px">
    <Columns>
        <asp:BoundField DataField="id" HeaderText="S.No" />
        <asp:BoundField DataField="Name" HeaderText="Name" />
        <asp:BoundField DataField="Designation" HeaderText="Designation" />
        <asp:BoundField DataField="DOJ" HeaderText="Date of Join" />
        <asp:BoundField DataField="Salary" HeaderText="Salary" />
        <asp:BoundField DataField="Gender" HeaderText="Gender" />
        <asp:BoundField DataField="State" HeaderText="State" />
        <asp:ButtonField CommandName="Edit" Text="Edit" />
        <asp:ButtonField CommandName="Delete" Text="Delete" />
    </Columns>
</asp:GridView>

    </form>
</body>
</html>
