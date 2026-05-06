using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using FrontSenAgriculture.ServiceSenAgriculture;

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
            // Test de diagnostic au chargement
            TestDatabaseDiagnostic();
            RefreshDataGrid();
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            RefreshDataGrid();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void Effacer()  {

            txtNom.Text = string.Empty;
            txtDescription .Text = string.Empty;
            txtPU.Text = string.Empty;
            txtNom.Focus();
        }

        private void RefreshDataGrid()
        {
            try
            {
                dgProduit.DataSource = null;

                var produits = service.getAllProduits();

                // Debug: Afficher le nombre de produits
                MessageBox.Show($"Nombre de produits récupérés: {produits?.Length ?? 0}", "Debug", MessageBoxButtons.OK, MessageBoxIcon.Information);

                if (produits != null && produits.Length > 0)
                {
                    dgProduit.DataSource = produits;

                    // Configuration des colonnes dans le bon ordre
                    if (dgProduit.Columns.Count > 0)
                    {
                        // Masquer la colonne ID si vous ne voulez pas l'afficher
                        // dgProduit.Columns["idProduit"].Visible = false;

                        // Définir l'ordre des colonnes
                        dgProduit.Columns["idProduit"].DisplayIndex = 0;
                        dgProduit.Columns["NomProduit"].DisplayIndex = 1;
                        dgProduit.Columns["DescriptionProduit"].DisplayIndex = 2;
                        dgProduit.Columns["PrixUnitaire"].DisplayIndex = 3;

                        // Définir les en-têtes personnalisés
                        dgProduit.Columns["idProduit"].HeaderText = "ID";
                        dgProduit.Columns["NomProduit"].HeaderText = "Nom";
                        dgProduit.Columns["DescriptionProduit"].HeaderText = "Description";
                        dgProduit.Columns["PrixUnitaire"].HeaderText = "Prix Unitaire";

                        // Ajuster la largeur des colonnes
                        dgProduit.Columns["idProduit"].Width = 50;
                        dgProduit.Columns["NomProduit"].Width = 120;
                        dgProduit.Columns["DescriptionProduit"].Width = 180;
                        dgProduit.Columns["PrixUnitaire"].Width = 90;
                    }
                }
                else
                {
                    MessageBox.Show("Aucun produit trouvé dans la base de données!", "Attention", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }

                dgProduit.Refresh();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erreur lors du chargement: {ex.Message}\n\nStackTrace: {ex.StackTrace}", "Erreur", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        

        private void btnAdd_Click(object sender, EventArgs e)
        {
            try
            {
                ServiceSenAgriculture.Produit produit = new ServiceSenAgriculture.Produit();
                produit.NomProduit = txtNom.Text;
                produit.PrixUnitaire = float.Parse(txtPU.Text);
                produit.DescriptionProduit = txtDescription.Text;

                bool result = service.addProduit(produit);

                if (result)
                {
                    MessageBox.Show("Produit ajouté avec succès!", "Succès", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    Effacer();
                    RefreshDataGrid();
                }
                else
                {
                    MessageBox.Show("Erreur lors de l'ajout du produit.", "Erreur", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erreur: {ex.Message}", "Erreur", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void TestDatabaseDiagnostic()
        {
            try
            {
                // Appeler la nouvelle méthode de diagnostic
                var diagnostic = service.DiagnosticDatabase();
                MessageBox.Show(diagnostic, "Diagnostic de la base de données", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Impossible d'appeler le diagnostic.\nVeuillez mettre à jour la référence du service!\n\nErreur: {ex.Message}", "Erreur", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
