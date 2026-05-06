using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MetierAppSenagriculture.Model;

namespace MetierAppSenagriculture.Library
{
    public class ProduitController
    {
        // methode ajouter un produit
        public bool addProduit(Produit produit)
        {
            try
            {
                using (var bd = new BdSenAgricultureContext())
                {
                    bd.Produits.Add(produit);
                    bd.SaveChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ERREUR addProduit: {ex.Message}");
                return false;
            }
        }
        public bool updateProduit(Produit produit)
        {
            try
            {
                using (var bd = new BdSenAgricultureContext())
                {
                    bd.Entry(produit).State = System.Data.Entity.EntityState.Modified;
                    bd.SaveChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ERREUR updateProduit: {ex.Message}");
                return false;
            }
        }
        public bool deleteProduit(int idProduit)
        {
            try
            {
                using (var bd = new BdSenAgricultureContext())
                {
                    bd.Entry(new Produit { idProduit = idProduit }).State = System.Data.Entity.EntityState.Deleted;
                    bd.SaveChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ERREUR deleteProduit: {ex.Message}");
                return false;
            }
        }
        public List<Produit> getAllProduits()
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("=== DEBUT getAllProduits ===");

                using (var bd = new BdSenAgricultureContext())
                {
                    // Désactiver le lazy loading pour éviter les problèmes de sérialisation WCF
                    bd.Configuration.ProxyCreationEnabled = false;
                    bd.Configuration.LazyLoadingEnabled = false;

                    System.Diagnostics.Debug.WriteLine("Configuration EF OK");

                    // Tester la connexion
                    var canConnect = bd.Database.Exists();
                    System.Diagnostics.Debug.WriteLine($"Base de données existe: {canConnect}");

                    var produits = bd.Produits.ToList();
                    System.Diagnostics.Debug.WriteLine($"Nombre de produits récupérés: {produits.Count}");

                    foreach (var p in produits)
                    {
                        System.Diagnostics.Debug.WriteLine($"Produit: ID={p.idProduit}, Nom={p.NomProduit}, Prix={p.PrixUnitaire}");
                    }

                    System.Diagnostics.Debug.WriteLine("=== FIN getAllProduits ===");
                    return produits;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ERREUR getAllProduits: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"StackTrace: {ex.StackTrace}");
                if (ex.InnerException != null)
                {
                    System.Diagnostics.Debug.WriteLine($"InnerException: {ex.InnerException.Message}");
                }
                return new List<Produit>();
            }
        }
        public Produit getProduitById(int  idProduit)
        {
            try
            {
                using (var bd = new BdSenAgricultureContext())
                {
                    return bd.Produits.Find(idProduit);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ERREUR getProduitById: {ex.Message}");
                return null;
            }
        }
    }
}
