using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DevelopersGuide
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            string feature = txtbtn1.Text;

            if (!string.IsNullOrEmpty(feature))
            {
                Response.Redirect("QandA.aspx?feature=" + txtbtn1.Text);
            }
            else
            {
                Response.Write("<Script>alert('Please enter the Feature to be developed.');</script>");
            }
        }
    }
}