using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Employees
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
            }
        }
        private void BindGrid()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Employee", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvEmployees.DataSource = dt;
                gvEmployees.DataBind();
            }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            string name = txtName.Text;
            string designation = txtDesignation.Text;
            DateTime doj = DateTime.Parse(txtDOJ.Text);
            decimal salary = decimal.Parse(txtSalary.Text);
            string gender = rbtnMale.Checked ? "Male" : "Female";
            string state = ddlState.SelectedValue;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd;
                if (ViewState["EditEmployeeID"] == null)
                {
                    cmd = new SqlCommand("INSERT INTO Employee (Name, Designation, DOJ, Salary, Gender, State) VALUES (@Name, @Designation, @DOJ, @Salary, @Gender, @State)", con);
                }
                else
                {
                    int id = Convert.ToInt32(ViewState["EditEmployeeID"]);
                    cmd = new SqlCommand("UPDATE Employee SET Name = @Name, Designation = @Designation, DOJ = @DOJ, Salary = @Salary, Gender = @Gender, State = @State WHERE id = @id", con);
                    cmd.Parameters.AddWithValue("@id", id);
                    ViewState["EditEmployeeID"] = null;
                }

                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Designation", designation);
                cmd.Parameters.AddWithValue("@DOJ", doj);
                cmd.Parameters.AddWithValue("@Salary", salary);
                cmd.Parameters.AddWithValue("@Gender", gender);
                cmd.Parameters.AddWithValue("@State", state);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClearForm();
            BindGrid();
        }
        protected void gvEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = gvEmployees.Rows[rowIndex];

            if (e.CommandName == "Edit")
            {
                int id = Convert.ToInt32(gvEmployees.DataKeys[rowIndex].Value);
                ViewState["EditEmployeeID"] = id;

                txtName.Text = row.Cells[1].Text;
                txtDesignation.Text = row.Cells[2].Text;
                txtDOJ.Text = DateTime.Parse(row.Cells[3].Text).ToString("yyyy-MM-dd");
                txtSalary.Text = row.Cells[4].Text;
                if (row.Cells[5].Text == "Male")
                {
                    rbtnMale.Checked = true;
                }
                else
                {
                    rbtnFemale.Checked = true;
                }
                ddlState.SelectedValue = row.Cells[6].Text;
            }
            else if (e.CommandName == "Delete")
            {

                int id = Convert.ToInt32(gvEmployees.DataKeys[rowIndex].Value);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Employee WHERE id = @id", con);
                    cmd.Parameters.AddWithValue("@id", id);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                BindGrid();
            }
        }
        private void ClearForm()
        {  
            txtName.Text = "";
            txtDesignation.Text = "";
            txtDOJ.Text = "";
            txtSalary.Text = "";
            rbtnMale.Checked = false;
            rbtnFemale.Checked = false;
            ddlState.SelectedIndex = 0;
        }
    }
}