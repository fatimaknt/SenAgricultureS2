using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using MetierAppSenagriculture.Library;
using MetierAppSenagriculture.Model;

namespace MetierAppSenagriculture
{
    // REMARQUE : vous pouvez utiliser la commande Renommer du menu Refactoriser pour changer le nom de classe "Service1" dans le code, le fichier svc et le fichier de configuration.
    // REMARQUE : pour lancer le client test WCF afin de tester ce service, sélectionnez Service1.svc ou Service1.svc.cs dans l'Explorateur de solutions et démarrez le débogage.
    public class Service1 : IService1
    {
        private readonly ProduitController produitController = new ProduitController();
        public string GetData(int value)
        {
            return string.Format("You entered: {0}", value);
        }

        public CompositeType GetDataUsingDataContract(CompositeType composite)
        {
            if (composite == null)
            {
                throw new ArgumentNullException("composite");
            }
            if (composite.BoolValue)
            {
                composite.StringValue += "Suffix";
            }
            return composite;
        }

        public bool addProduit(Produit produit)
        {
            return produitController.addProduit(produit);
        }

        public bool deleteProduit(int idProduit)
        {
            return produitController.deleteProduit(idProduit);
        }

        public List<Produit> getAllProduits()
        {
            return produitController.getAllProduits();
        }

        public bool updateProduit(Produit produit)
        {
            return produitController.updateProduit(produit);
        }

        public Produit getProduitById(int idProduit)
        {
            return produitController.getProduitById(idProduit);
        }

        public string DiagnosticDatabase()
        {
            var diagnostic = new DiagnosticController();
            return diagnostic.TestDatabaseConnection();
        }

        public string TestConnection()
        {
            try
            {
                using (var bd = new BdSenAgricultureContext())
                {
                    var canConnect = bd.Database.Exists();
                    if (!canConnect)
                    {
                        return "ERREUR: La base de données n'existe pas!";
                    }

                    var connectionString = bd.Database.Connection.ConnectionString;
                    var count = bd.Produits.Count();

                    // Tester une requête SQL directe
                    var sqlQuery = "SELECT COUNT(*) FROM produits";
                    var directCount = bd.Database.SqlQuery<int>(sqlQuery).FirstOrDefault();

                    return $"CONNEXION OK!\nNombre de produits (EF): {count}\nNombre de produits (SQL direct): {directCount}\nConnection String: {connectionString}";
                }
            }
            catch (Exception ex)
            {
                return $"ERREUR: {ex.Message}\n\nInnerException: {ex.InnerException?.Message}\n\nStackTrace: {ex.StackTrace}";
            }
        }
    }
}
