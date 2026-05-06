using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace FrontSenAgriculture
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        ServiceSenAgriculture.Service1Client service = new ServiceSenAgriculture.Service1Client();

        private void Form1_Load(object sender, EventArgs e)
        {
            String a = service.GetData(1);
            MessageBox.Show(a);
        }
    }
}
